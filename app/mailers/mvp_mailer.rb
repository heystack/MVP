class MvpMailer < ActionMailer::Base
  default :from => "parenting@stkup.com"

  def mvp_email(topic, email, from_email)
    @topic = topic
    @response = @topic.responses.new
    @email = email
    @from_email = from_email
    mail(:to => email, :subject => "Alexandria parenting question")
  end

  def email_neighbor(topic, contact, from_email)
    @topic = topic
    @response = @topic.responses.new
    @contact = contact
    @from_email = from_email
    mail(:to => @contact[:email], :subject => @contact[:email_subject])
  end

  def suggestion_email(suggestion)
    @suggestion = suggestion
    mail(:to => "nycbrown@gmail.com", :subject => "Topic Suggestion!")
  end
end
