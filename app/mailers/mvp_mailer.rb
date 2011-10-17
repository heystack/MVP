class MvpMailer < ActionMailer::Base
  default :from => "parenting@stkup.com"

  def mvp_email(email, from_email)
    @response = Response.new
    @email = email
    @from_email = from_email
    mail(:to => email, :subject => "Alexandria parenting question")
  end

  def suggestion_email(suggestion)
    @suggestion = suggestion
    mail(:to => "nycbrown@gmail.com", :subject => "Topic Suggestion!")
  end
end
