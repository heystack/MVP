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
    @from_email = @contact[:from_email]
    respond_to do |format|  
      MvpMailer.email_neighbor(@topic, @contact, @from_email).deliver
      format.html { redirect_to(root_path, :success => "Thanks for sharing with #{@contact[:email]}. Feel free to share as many times as you\'d like!") }  
      format.xml  { render :location => root_path }  
    end
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

end
