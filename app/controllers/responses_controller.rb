class ResponsesController < ApplicationController
  # Required to prevent session from resetting, due to use of 'def protect_from_forgery? false' in mvp_mailer_helper 
  skip_before_filter :verify_authenticity_token

  def new
    @response = Response.new
    @title = "New Response"
  end

  def create
    @response = Response.new(params[:response])
    if @response.save
      # flash[:success] = "Response saved: " + @response.value.to_s
      session[:you] = @response.value
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @response = Response.find(params[:id])
  end

end