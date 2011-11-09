class MvpMailer < ActionMailer::Base
  default :from => "'DC Parents StkUp' <parenting@stkup.com>"

  def mvp_email(topic, email, from_email)
    @topic = topic
    @response = @topic.responses.new
    @email = email
    @from_email = from_email
    mail(:to => email, :bcc => "sbrown@stkup.com", :subject => "Alexandria parenting question")
  end

  def email_neighbor(topic, contact, from_name)
    @topic = topic
    @response = @topic.responses.new
    @contact = contact
    @from_email = from_name + " <parenting@stkup.com>"
    @email = @contact[:email]
    @form_capable = false
    @host_url = "http://stkup.com"
    # @host_url = "http://localhost:3000"
    @base_url = @host_url + "/topics/" + @topic.id.to_s + "/responses"
    mail(:to => @email, :from => @from_email, :bcc => "sbrown@stkup.com", :subject => @contact[:email_subject])
  end

  def comment_email(contact)
    @contact = contact
    @from_email = @contact[:from_email]
    mail(:to => "nycbrown@gmail.com", :from => @from_email, :bcc => "sbrown@stkup.com", :subject => "User Comment!")
  end

  def feedback_email(contact)
    @contact = contact
    @from_email = @contact[:from_email]
    mail(:to => "nycbrown@gmail.com", :from => @from_email, :bcc => "sbrown@stkup.com", :subject => "User Feedback!")
  end

  def suggestion_email(suggestion)
    @suggestion = suggestion
    mail(:to => "nycbrown@gmail.com", :bcc => "sbrown@stkup.com", :subject => "Topic Suggestion!")
  end

  def stack_request_email(request)
    @request = request
    mail(:to => "nycbrown@gmail.com", :bcc => "sbrown@stkup.com", :subject => "Stack Request!")
  end
end
