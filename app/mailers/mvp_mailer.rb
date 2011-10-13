class MvpMailer < ActionMailer::Base
  default :from => "parenting@stkup.com"

  def mvp_email(email)
    @response = Response.new
    @email = email
    # @from_email = from_email
    mail(:to => email, :subject => "Parenting question")
  end
end
