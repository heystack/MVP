class ResponsesController < ApplicationController
  # Required to prevent session from resetting, due to use of 'def protect_from_forgery? false' in mvp_mailer_helper 
  skip_before_filter :verify_authenticity_token

  def new
    if !session[:topic]
      @topic = Topic.first
      session[:topic] = @topic.id
    else
      @topic = Topic.find_by_id(session[:topic])
    end
    @response = @topic.responses.new
    @title = "New Response"
    @form_capable = true
    if session[:you]
      @ask_location = false
    else
      @ask_location = true
    end
    @host_url = request.host_with_port
    @base_url = "/topics/" + @topic.id.to_s + "/responses"
    if @topic.name == "Babysitter Pay Rate"
      @response_value = session[:babysitter_pay_rate] ? ("%.2f" % session[:babysitter_pay_rate]).to_s : ""
      @mad_libs_intro = "I pay my babysitter <span class=\"dollar_sign\">$</span>"
      @mad_libs_label = "$ per hour"
      @mad_libs_units = " per hour"
    elsif @topic.name == "Mobilizers"
      @response_value = session[:mobilizers] ? ("%.f" % session[:mobilizers]).to_s : ""
      @mad_libs_intro = "My child got/will get a cell phone at "
      @mad_libs_label = "age"
      @mad_libs_units = " years old"
    elsif @topic.name == "Homework"
      @response_value = session[:homework] ? ("%.1f" % session[:homework]).to_s : ""
      @mad_libs_intro = 'My child in the 
        <label>
    		<select name="response[qualifier1]">
    		<option value="3rd grade">3rd grade</option>
    		<option value="4th grade">4th grade</option>
    		<option value="5th grade">5th grade</option>
    		<option value="6th grade" selected="selected">6th grade</option>
    		<option value="7th grade">7th grade</option>
    		<option value="8th grade">8th grade</option>
    		<option value="9th grade">9th grade</option>
    		<option value="10th grade">10th grade</option>
    		<option value="11th grade">11th grade</option>
    		<option value="12th grade">12th grade</option>
    		</select>
        </label> gets '.html_safe
      @mad_libs_label = "hours"
      @mad_libs_units = " hours of homework per weeknight"
    end
    if session[:email]
      @email = session[:email]
    else
      @email = ""
    end
    if session[:neighborhood]
      @neighborhood = session[:neighborhood]
    else
      @neighborhood = ""
    end
  end

  def create
    @topic = Topic.find_by_id(session[:topic])
    @response = @topic.responses.build(params[:response])
    if @response.save
      # flash[:success] = "Response saved: " + @response.value.to_s + " email=" + @response.email
      session[:you] = @response.value
      session[:email] = @response.email
      session[:response_id] = @response.id
      session[:neighborhood] = @response.neighborhood
      
      if @topic.name == "Babysitter Pay Rate"
        session[:babysitter_pay_rate] = session[:you]
      elsif @topic.name == "Mobilizers"
        session[:mobilizers] = session[:you]
      elsif @topic.name == "Homework"
        session[:homework] = session[:you]
      end

      # Session vars must be set since we might be coming from an external form submission
      session[:topic] = @topic.id
      if session[:topic]
        redirect_to @topic
      else
        redirect_to root_path
      end
    else
      render 'new'
    end
  end

  def edit
    if !session[:response_id]
      redirect_to root_path
    end
    @response = Response.find(params[:id])
    @topic = Topic.find(@response.topic_id)
    @form_capable = true
    @ask_location = true
    @neighborhood = session[:neighborhood]
    @email = session[:email]
    @host_url = request.host_with_port
    @base_url = "/topics/" + @topic.id.to_s + "/responses"
    if @topic.name == "Babysitter Pay Rate"
      @response_value = ("%.2f" % session[:babysitter_pay_rate]).to_s
      @mad_libs_intro = "I pay my babysitter <span class=\"dollar_sign\">$</span>"
      @mad_libs_label = "$ per hour"
      @mad_libs_units = " per hour"
    elsif @topic.name == "Mobilizers"
      @response_value = ("%.1f" % session[:mobilizers]).to_s.gsub(/".0"/,"")
      @mad_libs_intro = "My child got/will get a cell phone at "
      @mad_libs_label = "age"
      @mad_libs_units = " years old"
    elsif @topic.name == "Homework"
      @response_value = ("%.1f" % session[:homework]).to_s.gsub(/".0"/,"")
      @mad_libs_intro = 'My child in the 
        <label>
    		<select name="response[qualifier1]">
    		<option value="3rd grade">3rd grade</option>
    		<option value="4th grade">4th grade</option>
    		<option value="5th grade">5th grade</option>
    		<option value="6th grade" selected="selected">6th grade</option>
    		<option value="7th grade">7th grade</option>
    		<option value="8th grade">8th grade</option>
    		<option value="9th grade">9th grade</option>
    		<option value="10th grade">10th grade</option>
    		<option value="11th grade">11th grade</option>
    		<option value="12th grade">12th grade</option>
    		</select>
        </label> gets '.html_safe
      @mad_libs_label = "hours"
      @mad_libs_units = " hours of homework per weeknight"
    end
  end

  def update
    @response = Response.find(params[:id])
    @topic = Topic.find(@response.topic_id)
    session[:response_id] = @response.id
    if @response.update_attributes(params[:response])
      session[:you] = @response.value
      session[:email] = @response.email
      session[:response_id] = @response.id
      session[:neighborhood] = @response.neighborhood
      
      if @topic.name == "Babysitter Pay Rate"
        session[:babysitter_pay_rate] = session[:you]
      elsif @topic.name == "Mobilizers"
        session[:mobilizers] = session[:you]
      elsif @topic.name == "Homework"
        session[:homework] = session[:you]
      end
      redirect_to @topic
    else
      render 'edit'
    end
  end
  
  def show
    @response = Response.find(params[:id])
    session[:response_id] = @response.id
  end

  def index
    # Create new response from URL-based GET form submission
    if !params[:response]
      redirect_to root_path and return
    end
    @topic = Topic.find_by_id(params[:topic_id])
    @response = @topic.responses.build(params[:response])
    if @response.save
      # flash[:success] = "Your response, " + @response.value.to_s + ", has been added to the stack!"
      session[:you] = @response.value
      session[:email] = @response.email
      session[:response_id] = @response.id
      session[:neighborhood] = ""
      
      if @topic.name == "Babysitter Pay Rate"
        session[:babysitter_pay_rate] = session[:you]
      elsif @topic.name == "Mobilizers"
        session[:mobilizers] = session[:you]
      elsif @topic.name == "Homework"
        session[:homework] = session[:you]
      end

      # Session vars must be set since we might be coming from an email form submission
      session[:topic] = @topic.id
      if session[:topic]
        redirect_to edit_response_path(@response.id)
        # redirect_to topic_path(session[:topic])
      else
        redirect_to root_path
      end
    else
      render 'new'
    end
  end

  def stkresponses
    @responses = Response.all(:order => 'id DESC')
    @count = Response.count
    @topics = Topic.select("id, name").group('id', 'name')
  end

end
