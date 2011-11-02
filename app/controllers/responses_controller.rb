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
  end

  def create
    @topic = Topic.find_by_id(params[:topic_id])
    @response = @topic.responses.build(params[:response])
    if @response.save
      # flash[:success] = "Response saved: " + @response.value.to_s + " email=" + @response.email
      session[:you] = @response.value
      session[:email] = @response.email
      
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
        redirect_to topic_path(session[:topic])
      else
        redirect_to root_path
      end
    else
      render 'new'
    end
  end

  def show
    @response = Response.find(params[:id])
  end

  def index
    redirect_to root_path
  end

  def stkresponses
    @responses = Response.all(:order => 'id DESC')
    @count = Response.count
    @topics = Topic.select("id, name").group('id', 'name')
  end

end
