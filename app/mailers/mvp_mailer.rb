class MvpMailer < ActionMailer::Base
  default :from => "sbrown@stkup.com"

  def mvp_email(email, from_email)
    @response = Response.new
    @email = email
    @from_email = from_email
    mail(:to => email, :from => from_email, :subject => "Parenting question")
  end
end
