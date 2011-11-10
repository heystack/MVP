class MvpController < ApplicationController
  # Required to prevent session from resetting, due to use of 'def protect_from_forgery? false' in mvp_mailer_helper 
  skip_before_filter :verify_authenticity_token

  def home
    session[:topic] ||= Topic.first.id
    if !session[:you]
      redirect_to new_topic_response_path(session[:topic])
    else
      session[:you] ||= 0

      if Topic.count > 0
        flash.keep
        redirect_to topic_path(session[:topic])
      else
        redirect_to new_topic_path
      end
    end
  end

  def email_preview
    @contact = params[:contact]
    @topic = Topic.find_by_id(session[:topic])
    @from_email = session[:email]
    session[:to_email] = @contact[:email]
  end

  def share_with_neighbor
    @contact = params[:contact]
    @topic = Topic.find_by_id(session[:topic])
    @from_name = @contact[:from_name]
    @user_email = @contact[:user_email]
    MvpMailer.email_neighbor(@topic, @contact, @from_name, @user_email).deliver
    flash[:success] = "Thanks for sharing with #{@contact[:email]}. Feel free to share as many times as you\'d like!"
    redirect_to root_path
  end

  def send_comment
    @contact = params[:contact]
    MvpMailer.comment_email(@contact).deliver
    flash[:success] = "Thanks for the comment!"
    redirect_to root_path
  end

  def send_feedback
    @contact = params[:contact]
    MvpMailer.feedback_email(@contact).deliver
    flash[:success] = "Thanks for the feedback!"
    redirect_to root_path
  end

  def stack_request
    @request = params[:request]
    MvpMailer.stack_request_email(@request).deliver
    flash[:success] = "Thanks for the stack request! If you provided your email, we'll get back to you shortly."
    redirect_to root_path
  end

end
