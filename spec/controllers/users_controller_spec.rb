require 'spec_helper'

describe UsersController do
  render_views
   
  describe "GET :show" do

     before(:each) do
       @user = Factory(:user)
       get :show, :id => @user
     end

     it "should be successful" do
       response.should be_success
     end

     it "should find the right user" do
       assigns(:user).should == @user
     end

     it "should have the right title" do
       response.should have_selector("title", :content => @user.name)
     end

     it "should include the user's name" do
       response.should have_selector("h1", :content => @user.name)
     end

     it "should have a profile image" do
       response.should have_selector("h1>img", :class => "gravatar")
     end
    
  end

  describe "GET :new" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end
    
    it "should have a name field" do
      get 'new'
      response.should have_selector("input[name='user[name]'][type='text']")
    end

    it "should have an email field" do
      get 'new'
      response.should have_selector("input[name='user[name]'][type='text']")
    end

    it "should have password and confirmation fields" do
      get 'new'
      response.should have_selector("input[name='user[password]'][type='password']")
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end

  end

  describe "POST 'create'" do

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "foobar",
	          :password_confirmation => "barfoo" }
      end

      it "should not create a user" do
        lambda do
	  post :create, :user => @attr
	end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
	response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
	response.should render_template('new')
      end

      it "should clear the password & confirmation" do
        post :create, :user => @attr
        response.should have_selector("input[name='user[password]'][type='password'][value='']")
        response.should have_selector("input[name='user[password_confirmation]'][type='password'][value='']")
      end

    end

    describe "success" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com", 
	          :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create a user" do
        lambda do
	  post :create, :user => @attr
	end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
	response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome/i
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end
end
