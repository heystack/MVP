class Topic < ActiveRecord::Base
  attr_accessible :name, :question

  has_many :responses
  
  def tipped?
    count = self.responses.count
    (count / TIPPING_POINT ) >= 1
  end

  def answered?(user_email)
    self.responses.find_by_email(user_email) && user_email != "feedback@stkup.com"
  end

end
