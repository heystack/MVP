class Topic < ActiveRecord::Base
  attr_accessible :name, :question

  has_many :responses
end
