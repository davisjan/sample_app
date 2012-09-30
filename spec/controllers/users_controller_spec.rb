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

  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    it "should be successful" do 
      get :edit, :id => @user
      response.should be_success
    end
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit profile")
    end
    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                         :content => "change")
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
	          :password_confirmation => "" }
      end
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
	response.should render_template 'edit'
      end
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
	response.should have_selector("title", :content => "Edit profile")
      end
    end
    describe "success" do
      before(:each) do
        @attr = { :name => "New name", :email => "new@example.com",
	          :password => "newpassword",
		  :password_confirmation => "newpassword" }
      end
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
	@user.reload
	@user.name.should == @attr[:name]
	@user.email.should == @attr[:email]
      end
      it "should redirect to the user profile" do
        put :update, :id => @user, :user => @attr
	response.should redirect_to user_path(@user)
      end
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
	flash[:success].should =~ /updated/
      end
    end
  end

  describe "require authentication for edit/update pages" do
    before :each do
      @user = Factory :user 
    end
    describe "for anonymous" do
      it "should deny access to 'edit'" do
        get :edit, :id => @user
	response.should redirect_to signin_path
      end
      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
	response.should redirect_to signin_path
      end
      it "should have a flash message" do
        put :update, :id => @user, :user => {}
        flash[:notice].should =~ /sign in/
      end
    end
  end
  describe "for signed-in users" do
    before :each do
      @user = Factory(:user)
      wrong_user = Factory :user, :email => "user@example.net"
      test_sign_in(wrong_user)
    end
    it "should require matching users for 'edit'" do
      get :edit, :id => @user
      response.should redirect_to root_path
    end
    it "should require matching users for 'update'" do
      put :update, :id => @user, :user => {}
      response.should redirect_to root_path
    end
  end
end
