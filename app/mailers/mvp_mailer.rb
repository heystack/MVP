class MvpMailer < ActionMailer::Base
  default :from => "sbrown@stkup.com"

  def mvp_email(email)
    @response = Response.new
    mail(:to => email, :subject => "Parenting question")
  end
end
