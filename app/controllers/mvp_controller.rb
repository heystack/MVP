class MvpController < ApplicationController
  # Required to prevent session from resetting, due to use of 'def protect_from_forgery? false' in mvp_mailer_helper 
  skip_before_filter :verify_authenticity_token

  def home
    if !session[:you]
      redirect_to new_response_path
    end
    session[:you] ||= 0
    @lowest_color = '#89A54E'
    @all_neighbors_color = '#92A8CD'
    @you_color = '#4572A7'
    @biggest_color = '#DB843D'

    @count = Response.count

    if @count > 0
      # Calculate all_neighbors
      @all_neighbors = Response.average(:value)
      # Used for debug purposes only
      @responses = Response.all(:order => 'value')

      # TODO: There must be an easier way to calculate the top and bottom 20%!!
      @count_20_percent = (0.20 * @count).ceil

      # Calculate lowest_spenders
      @lowest_spenders_amounts = Response.order('value ASC').limit(@count_20_percent)
      @lowest_spenders_total = 0
      @lowest_spenders_amounts.each { |a| @lowest_spenders_total += a.value }
      @lowest_spenders = @lowest_spenders_total / @count_20_percent

      # Calculate biggest_spenders
      @biggest_spenders_amounts = Response.order('value DESC').limit(@count_20_percent)
      @biggest_spenders_total = 0
      @biggest_spenders_amounts.each { |a| @biggest_spenders_total += a.value }
      @biggest_spenders = @biggest_spenders_total / @count_20_percent
      
      # Calculate user_rank
      if session[:you] <= @lowest_spenders
        @user_rank = "lowest"
      elsif session[:you] <= @all_neighbors
        @user_rank = "average"
      elsif session[:you] < @biggest_spenders
        @user_rank = "more than most"
      else
        @user_rank = "biggest"
      end
      
      # Calculate percent_diff
      if @user_rank == "lowest"
        @percent = (( @lowest_spenders - session[:you] ) / @lowest_spenders) * 100
        @percent_diff = ("%.f" % @percent).to_s + "% less"
      else
        @percent = (( session[:you] - @lowest_spenders ) / @lowest_spenders) * 100
        @percent_diff = ("%.f" % @percent).to_s + "% more"
      end

      # Calculate dollar_diff
      if @user_rank == "lowest"
        # The following line works, but does not put the commas in the amount
        # @dollar_diff = "$" + "%.f" % (( @lowest_spenders - session[:you] ) * 240) + " less"
        @dollar_diff_amt = (( @lowest_spenders - session[:you] ) * 240).round
        @dollar_diff_text = " less"
      else
        # Same here...
        # @dollar_diff = "$" + "%.f" % (( session[:you] - @lowest_spenders ) * 240) + " more"
        @dollar_diff_amt = (( session[:you] - @lowest_spenders ) * 240).round
        @dollar_diff_text = " more"
      end

    else
      @lowest_spenders = 0
      @biggest_spenders = 0
    end
  end

  def contact
  end

  def send_stack_form
    @contact = params[:contact]
    session[:email] = @contact[:email]
    # if !@contact[:from_email].blank?
    #   session[:from_email] = @contact[:from_email]
    # else
    #   session[:from_email] = "sbrown@stkup.com"
    # end
    MvpMailer.mvp_email(@contact[:email]).deliver
    flash[:success] = "Thanks for sharing with #{@contact[:email]}. Feel free to share as many times as you'd like!"
    redirect_to root_path
  end

end
