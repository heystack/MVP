class Topic < ActiveRecord::Base
  attr_accessible :name, :question

  has_many :responses
  
  def tipped?
    count = self.responses.count
    (count / TIPPING_POINT ) >= 1
  end
  
end
