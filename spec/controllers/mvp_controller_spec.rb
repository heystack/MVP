require 'spec_helper'

describe MvpController do
  render_views

  before(:each) do
    @attr = { :value => "11.50" }
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
                        :content => "Simple, Purposeful Comparisons")
    end

    it "should have all the right divs" do
      get 'home'
      response.should have_selector("div",  :id => "hc")
      response.should have_selector("div",  :id => "legend")
      response.should have_selector("div",  :id => "action_steps")
    end
  end

end
