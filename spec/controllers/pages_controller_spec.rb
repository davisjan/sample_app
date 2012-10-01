require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
    it "should have the right title" do
      get 'home'
      response.should have_selector("title", 
                                    :content => @base_title + " | Home")
      response.should have_selector("title", :content => "Home")
    end
    it "should not show the sign-up link for signed-in users" do
      user = Factory :user
      test_sign_in user
      get 'home'
      response.should_not have_selector("a", :href => signup_path)
    end
    it "should show the microposts form for singed-in users" do
      user = Factory :user
      test_sign_in user
      get 'home'
      response.should have_selector("form", :action => '/microposts')
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title", :content => "Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    it "should have the right title" do
      get 'about'
      response.should have_selector("title", :content => "About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end
    it "should have the right title" do
      get 'help'
      response.should have_selector("title", 
                                    :content => @base_title + " | Help")
    end
  end

end
