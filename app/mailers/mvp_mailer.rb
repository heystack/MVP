class MvpMailer < ActionMailer::Base
  default :from => "'StkUp Feedback' <feedback@stkup.com>"

  def email_neighbor(topic, contact, from_name, user_email)
    @topic = topic
    @response = @topic.responses.new
    @contact = contact
    @from_name = from_name
    @from_email = @from_name + " via StkUp <feedback@stkup.com>"
    @email = @contact[:email]
    @user_email = user_email
    @form_capable = false
    @host_url = "http://stkup.com"
    # @host_url = "http://localhost:3000"
    @base_url = @host_url + "/topics/" + @topic.id.to_s + "/responses"
    mail(:to => @email, :from => @from_email, :bcc => "feedback@stkup.com", :subject => @contact[:email_subject])
  end

  def comment_email(contact)
    @contact = contact
    @from_email = @contact[:from_email]
    mail(:to => "nycbrown@gmail.com", :from => @from_email, :subject => "User Comment!")
  end

  def feedback_email(contact)
    @contact = contact
    @from_email = @contact[:from_email]
    mail(:to => "nycbrown@gmail.com", :from => @from_email, :subject => "User Feedback!")
  end

  def suggestion_email(suggestion)
    @suggestion = suggestion
    mail(:to => "nycbrown@gmail.com", :subject => "Topic Suggestion!")
  end

  def stack_request_email(request)
    @request = request
    mail(:to => "nycbrown@gmail.com", :subject => "Stack Request!")
  end
end
