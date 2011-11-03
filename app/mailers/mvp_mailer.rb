class MvpMailer < ActionMailer::Base
  default :from => "parenting@stkup.com"

  def mvp_email(topic, email, from_email)
    @topic = topic
    @response = @topic.responses.new
    @email = email
    @from_email = from_email
    mail(:to => email, :bcc => "sbrown@stkup.com", :subject => "Alexandria parenting question")
  end

  def email_neighbor(topic, contact, from_email)
    @topic = topic
    @response = @topic.responses.new
    @contact = contact
    @from_email = from_email
    @email = @contact[:email]
    @form_capable = false
    @host_url = "http://parenting-mvp.heroku.com"
    @base_url = @host_url + "/topics/" + @topic.id.to_s + "/responses"
    mail(:to => @email, :bcc => "sbrown@stkup.com", :subject => @contact[:email_subject])
  end

  def comment_email(contact)
    @contact = contact
    mail(:to => "nycbrown@gmail.com", :bcc => "sbrown@stkup.com", :subject => "User Comment!")
  end

  def suggestion_email(suggestion)
    @suggestion = suggestion
    mail(:to => "nycbrown@gmail.com", :bcc => "sbrown@stkup.com", :subject => "Topic Suggestion!")
  end
end
