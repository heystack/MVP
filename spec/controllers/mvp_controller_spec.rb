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

    it "should have a hc div" do
      get 'home'
      response.should have_selector("div",
                        :id => "hc")
    end

    it "should have a legend div" do
      get 'home'
      response.should have_selector("div",
                        :id => "legend")
    end

    it "should have a action_steps div" do
      get 'home'
      response.should have_selector("div",
                        :id => "action_steps")
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end

end
