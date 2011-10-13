class MvpMailer < ActionMailer::Base
  default :from => "parenting@stkup.com"

  def mvp_email(email, from_email)
    @response = Response.new
    @email = email
    @from_email = from_email
    mail(:to => email, :subject => "Parenting question")
  end

  def suggestion_email(contact)
    @contact = contact
    mail(:to => "nycbrown@gmail.com", :subject => "Stack Suggestion!")
  end
end
