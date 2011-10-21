# == Schema Information
#
# Table name: responses
#
#  id         :integer         not null, primary key
#  value      :float
#  created_at :datetime
#  updated_at :datetime
#  email      :string
#

class Response < ActiveRecord::Base
  attr_accessible :value, :email
  
  validates :value, :presence => true
  
  belongs_to :topic
  
  def all_neighbors
    Response.average(:value)
  end

end
