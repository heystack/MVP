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

  def contact
  end

  def send_stack_form
    @contact = params[:contact]
    @topic = Topic.find_by_id(session[:topic])
    @from_email = session[:email]
    MvpMailer.mvp_email(@topic, @contact[:email], @from_email).deliver
    flash[:success] = "Thanks for sharing with #{@contact[:email]}. Feel free to share as many times as you'd like!"
    redirect_to root_path
  end

  def suggestion_form
  end

  # def send_suggestion
  #   # @contact_email = params[:contact_email]
  #   @contact = params[:contact]
  #   MvpMailer.suggestion_email(@contact).deliver
  #   flash[:success] = "Thanks for the suggestion!"
  #   redirect_to root_path
  # end

  def suggestion
    @suggestion = params[:suggested_topic]
    MvpMailer.suggestion_email(@suggestion).deliver
    flash[:success] = "Thanks for the suggestion!"
    redirect_to root_path
  end

end
