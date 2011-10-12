# == Schema Information
#
# Table name: responses
#
#  id         :integer         not null, primary key
#  value      :float
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Response do
  before(:each) do
    @attr = { :value => "11.50" }
  end

  it "should create a new Response given valid attributes" do
    Response.create!(@attr)
  end

  it "should require a value" do
      no_value_response = Response.new(@attr.merge(:value => ""))
      no_value_response.should_not be_valid
    end
end
