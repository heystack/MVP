class TopicsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  # Required to prevent session from resetting, due to use of 'def protect_from_forgery? false' in mvp_mailer_helper 
  skip_before_filter :verify_authenticity_token

  def new
    @topic = Topic.new
    @title = "New Topic"
  end

  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      flash[:success] = "Topic saved: " + @topic.name
      session[:topic] = @topic.id
      redirect_to topic_path(@topic)
    else
      flash[:error] = "Topic not saved"
      render 'new'
    end
  end

  def show
    @topic = Topic.find(params[:id])

    if !@topic
      redirect_to new_topic_path
    end
    
    @topics = Topic.all
    session[:topic] = @topic.id

    if !session[:you]
      redirect_to new_topic_response_path(@topic) and return
    else
      session[:you] ||= 0
    end

    if @topic.name == "Babysitter Pay Rate"
      if !session[:babysitter_pay_rate]
        redirect_to new_topic_response_path(@topic)
      else
        session[:you] = session[:babysitter_pay_rate]
        session[:response_id] = session[:babysitter_id]
      end
    elsif @topic.name == "Mobilizers"
      if !session[:mobilizers]
        redirect_to new_topic_response_path(@topic)
      else
        session[:you] = session[:mobilizers]
        session[:response_id] = session[:mobilizers_id]
      end
    elsif @topic.name == "Homework"
      if !session[:homework]
        redirect_to new_topic_response_path(@topic)
      else
        session[:you] = session[:homework]
        session[:response_id] = session[:homework_id]
      end
    end

    # Not sure what would cause a zero, but seems to be happening, so check for it
    if session[:you] == 0
      redirect_to new_topic_response_path(@topic)
    end

    @lowest_color = LOWEST_COLOR
    @all_neighbors_color = ALL_NEIGHBORS_COLOR
    @you_color = YOU_COLOR
    @biggest_color = BIGGEST_COLOR

    @count = @topic.responses.count

    @tipping_point_progress = ("%.0f" % ((@count.to_f / TIPPING_POINT) * 100)).to_s + "%"
    
    if @count > 0
      # Calculate all_neighbors
      @all_neighbors = @topic.responses.average(:value)
      # Used for debug purposes only
      @responses = @topic.responses.all(:order => 'value')

      # TODO: There must be an easier way to calculate the top and bottom 20%!!
      @count_20_percent = (0.20 * @count).ceil

      # Calculate lowest_spenders
      @lowest_amounts = @topic.responses.order('value ASC').limit(@count_20_percent)
      @lowest_total = 0
      @lowest_amounts.each { |a| @lowest_total += a.value }
      @lowest_amt = @lowest_total / @count_20_percent

      # Calculate biggest_spenders
      @biggest_amounts = @topic.responses.order('value DESC').limit(@count_20_percent)
      @biggest_total = 0
      @biggest_amounts.each { |a| @biggest_total += a.value }
      @biggest_amt = @biggest_total / @count_20_percent
      
      # Calculate user_rank
      if session[:you] <= @lowest_amt
        @user_rank = "lowest"
      elsif session[:you] <= @all_neighbors
        @user_rank = "average"
      elsif session[:you] < @biggest_amt
        @user_rank = "more than most"
      else
        @user_rank = "biggest"
      end
      
      # Calculate percent_diff
      if @user_rank == "lowest"
        @percent = (( @lowest_amt - session[:you] ) / @lowest_amt) * 100
        @percent_diff = ("%.f" % @percent).to_s + "%"
      else
        @percent = (( session[:you] - @lowest_amt ) / @lowest_amt) * 100
        @percent_diff = ("%.f" % @percent).to_s + "%"
      end

      # Calculate mult_diff
      if @user_rank == "lowest"
        @mult = ( @lowest_amt / session[:you] ).round
        @mult_diff = ("%.f" % @mult).to_s + " times"
      else
        @mult = ( session[:you] / @lowest_amt ).round
        @mult_diff = ("%.f" % @mult).to_s + " times"
      end

      # Generate topic-specific text for display
      if @topic.name == "Babysitter Pay Rate"
        if @user_rank == "lowest"
          @diff_amt = (( @lowest_amt - session[:you] ) * 240).round
          @diff_text = "&nbsp;less"
        else
          @diff_amt = (( session[:you] - @lowest_amt ) * 240).round
          @diff_text = "&nbsp;more"
        end
        @diff_amt = number_to_currency(@diff_amt, :strip_insignificant_zeros => true)
        if @diff_amt == 0
          @comparison_text = "You spend <span class='em'>" + "the same as" + "</span> your lowest spending neighbors."
          @diff_text = ""
        else
          @comparison_text = "You spend <span class='em'>" + @percent_diff + @diff_text + "</span> than your lowest spending neighbors."
          @diff_text = "With four 5 hours sits per month, you spend <span class='em'>" + @diff_amt.to_s + @diff_text + " per year</span> than your lowest spending neighbors."
        end
        @lowest_desc = "Lowest Spenders"
        @lowest_legend = "The&nbsp;lowest&nbsp;spending&nbsp;20% from&nbsp;ALL&nbsp;NEIGHBORS."
        @biggest_desc = "Biggest Spenders"
        @than_most_desc = "More&nbsp;Than&nbsp;Most"
        @hc_tooltip = "this.x +': $'+ this.y.toFixed(2).gsub(\".00\", \"\") +'/hr'"
        @hc_dataLabel = "'$'+ this.y.toFixed(2).gsub(\".00\", \"\")"
        # Icon from http://www.napkee.com/napkee/features/exports/icons/
        @legend_icon = "<img src=\"/images/dollar_icon.png\" width=\"15\">"
        @smiley_lowest = "<img src=\"/images/smiley_1.png\" height=\"25\">"
        @smiley_average = "<img src=\"/images/smiley_2.png\" height=\"25\">"
        @smiley_more_than_most = "<img src=\"/images/smiley_3.png\" height=\"25\">"
        @smiley_biggest = "<img src=\"/images/smiley_4.png\" height=\"25\">"
        @action_step = "<a href='http://bit.ly/o1WtS9' target='_blank'>Find a babysitter in the DC area >> <span class='text-75'>SitterCity</span></a><br/>
          <a href='http://bit.ly/vk65wE' target='_blank'>Factors to consider in paying a babysitter >> <span class='text-75'>StackExchange</span></a><br/>"

      elsif @topic.name == "Mobilizers"
        if @user_rank == "lowest"
          @diff_amt = ( @lowest_amt - session[:you] ).round
          @diff_text = "about " + help.pluralize(@diff_amt, 'year') + " earlier"
        else
          @diff_amt = ( session[:you] - @lowest_amt ).round
          @diff_text = "about " + help.pluralize(@diff_amt, 'year') + " later"
        end
        if @diff_amt == 0
          @comparison_text = "You gave your child a mobile phone <span class='em'>" + "at the same age" + "</span> as your earliest mobilizing neighbors"
          @diff_text = ""
        else
          @comparison_text = "You gave your child a mobile phone <span class='em'>" + @diff_text + "</span> than your earliest mobilizing neighbors."
          @diff_text = "Based on an average child's cell phone use, your child may spend up to <span class='em'>" + "6 hours per week" + "</span> on their cell phone."
        end
        @lowest_desc = "Earliest Mobilizers"
        @lowest_legend = "The&nbsp;earliest&nbsp;mobilizing&nbsp;20% of&nbsp;ALL&nbsp;NEIGHBORS."
        @biggest_desc = "Latest Mobilizers"
        @than_most_desc = "Later&nbsp;Than&nbsp;Most"
        @hc_tooltip = "this.x +': '+ this.y.toFixed(1).gsub(\".0\", \"\") +' yrs old'"
        @hc_dataLabel = "''+ this.y.toFixed(1).gsub(\".0\", \"\")"
        @legend_icon = "<img src=\"/images/cell_phone_icon.png\" width=\"15\">"
        @smiley_lowest = "<img src=\"/images/smiley_4.png\" height=\"25\">"
        @smiley_average = "<img src=\"/images/smiley_2.png\" height=\"25\">"
        @smiley_more_than_most = "<img src=\"/images/smiley_5.png\" height=\"25\">"
        @smiley_biggest = "<img src=\"/images/smiley_4.png\" height=\"25\">"
        @action_step = "<a href='http://bit.ly/tshjGn' target='_blank'>What's the right age for a cellphone? >> <span class='text-75'>MSNBC Red Tape</span></a><br/>"

      elsif @topic.name == "Homework"
        if @user_rank == "lowest"
          @diff_amt = (( @lowest_amt - session[:you] ) * 21).round
          @diff_text = "&nbsp;less"
        else
          @diff_amt = (( session[:you] - @lowest_amt ) * 21).round
          @diff_text = "&nbsp;more"
        end
        if @diff_amt == 0
          @comparison_text = "Your child's homework load is <span class='em'>" + "the same as" + "</span> as their least loaded peers."
          @diff_text = ""
        else
          @comparison_text = "Your child's homework load is <span class='em'>" + @mult_diff + @diff_text + "</span> than their least loaded peers."
          @diff_text = "In a typical month, your child may spend up to <span class='em'>" + @diff_amt.to_s + @diff_text + "</span> hours on homework than their least loaded peers."
        end
        @lowest_desc = "Lightest Load"
        @lowest_legend = "The&nbsp;least&nbsp;loaded&nbsp;20% of&nbsp;ALL&nbsp;NEIGHBORS."
        @biggest_desc = "Heaviest Load"
        @than_most_desc = "More&nbsp;Than&nbsp;Most"
        @hc_tooltip = "this.x +': '+ this.y.toFixed(1).gsub(\".0\", \"\") +' hours'"
        @hc_dataLabel = "''+ this.y.toFixed(1).gsub(\".0\", \"\")"
        @legend_icon = "<img src=\"/images/pencil_icon.png\" width=\"15\">"
        @smiley_lowest = "<img src=\"/images/smiley_4.png\" height=\"25\">"
        @smiley_average = "<img src=\"/images/smiley_2.png\" height=\"25\">"
        @smiley_more_than_most = "<img src=\"/images/smiley_3.png\" height=\"25\">"
        @smiley_biggest = "<img src=\"/images/smiley_4.png\" height=\"25\">"
        @action_step = "<a href='http://usat.ly/stkup-hw' target='_blank'>What is the right amount of homework? >> <span class='text-75'>USA Today</span></a><br/>
          <a href='http://nyti.ms/s5SC9x' target='_blank'>Parents Embrace \"Race to Nowhere\" >> <span class='text-75'>NY Times</span></a><br/>"

      end

    else
      @lowest_amt = 0
      @biggest_amt = 0
      @comparison_text = "There is nothing to compare yet."
      @diff_text = "There are no interesting observations to make yet."
      @biggest_desc = "Most"
      @than_most_desc = "More Than Most"
      @hc_tooltip = "this.x +': '+ this.y.toFixed(1).gsub(\".0\", \"\") +''"
      @hc_dataLabel = "''+ this.y.toFixed(1).gsub(\".0\", \"\")"
      @legend_icon = "?"
      @smiley_lowest = "<img src=\"/images/smiley_4.png\" height=\"25\">"
      @smiley_average = "<img src=\"/images/smiley_4.png\" height=\"25\">"
      @smiley_more_than_most = "<img src=\"/images/smiley_4.png\" height=\"25\">"
      @smiley_biggest = "<img src=\"/images/smiley_4.png\" height=\"25\">"
    end
  end
end
