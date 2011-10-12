require 'spec_helper'

describe ResponsesController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :value => "" }
      end

      it "should not create a response" do
        lambda do
          post :create, :value => @attr
        end.should_not change(Response, :count)
      end

      it "should render the 'new' page" do
        post :create, :response => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do

      before(:each) do
        @attr = { :value => "15" }
      end

      it "should create a Response" do
        lambda do
          post :create, :response => @attr
        end.should change(Response, :count).by(1)
      end

      it "should redirect to the Response show page" do
        post :create, :response => @attr
        response.should redirect_to(root_path)
      end
      
      # it "should have a success message" do
      #   post :create, :response => @attr
      #   flash[:success].should =~ /response saved/i
      # end
    end
  end
end
