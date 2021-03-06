require 'spec_helper'

describe UsersController do
  render_views

  describe "GET :index" do
    describe "for anonymous" do
      it "should deny access" do
        get :index
	response.should redirect_to signin_path
	flash[:notice].should =~ /sign in/i
      end
    end
    describe "for signed in users" do
      before :each do
        @user = test_sign_in Factory :user
	second = Factory(:user, :email => "another@example.com")
	third = Factory(:user, :email => "another@example.net")
	@users = [@user,second,third]
      end
      it "should be successful" do
        get :index
	response.should be_success
      end
      it "should have the right title" do
        get :index
	response.should have_selector("title", :content => "All users")
      end
      it "should list all the users" do
        get :index
	@users.each do |user|
	  response.should have_selector "li", :content => user.name
	end
      end
      it "should allow admin users to delete" do
        @user.toggle! :admin
        get :index
	@users.each do |user|
	  if user != @user
  	    response.should have_selector("a", :href => user_path(user),
	                                       'data-method' => "delete")
          end
	end
      end
      it "should not show a delete link for the signed-in admin user" do
        @user.toggle! :admin
        get :index
  	response.should_not have_selector("a", :href => user_path(@user),
	                                       'data-method' => "delete")
      end
      it "should not allow non-admin users to delete" do
        get :index
	@users.each do |user|
	  response.should_not have_selector("a", :href => user_path(user),
	                                         'data-method' => "delete")
	end
      end
      it "should paginate" do
	30.times do 
	  @users << Factory(:user, :email => Factory.next(:email))
	end
        get :index
	response.should have_selector "div.pagination"
	response.should have_selector "span.disabled", :content => "Previous"
	response.should have_selector "a", :href => "/users?page=2",
	                                   :content => "2"
	response.should have_selector "a", :href => "/users?page=2",
	                                   :content => "Next"
      end
    end
  end
   
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

     it "should show a user's microposts" do
       mp1 = Factory :micropost, :user => @user, :content => "First post"
       mp2 = Factory :micropost, :user => @user, :content => "Second post"
       get :show, :id => @user
       response.should have_selector "span", :class => 'content',
                                             :content => mp1.content
       response.should have_selector "span", :class => 'content',
                                             :content => mp2.content
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

    it "should not be allowed for signed-in users" do
      user = Factory :user
      test_sign_in user
      get :new
      response.should redirect_to root_path
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

    it "should not be allowed for signed-in users" do
      user = Factory :user
      test_sign_in user
      post 'create', :user => @attr
      response.should redirect_to root_path
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

  describe "DELETE 'destroy'" do
    before :each do
      @user = Factory :user
    end
    describe "as anonymous" do
      it "should deny access" do
        delete :destroy, :id => @user
	response.should redirect_to signin_path
      end
    end
    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in @user
        delete :destroy, :id => @user
	response.should redirect_to root_path
      end
    end
    describe "as an admin user" do
      before :each do
        @admin = Factory :user, :email => "admin@example.com", 
	                        :admin => true
        test_sign_in @admin
      end
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
	end.should change(User, :count).by(-1)
      end
      it "should redirect to the users page" do
        delete :destroy, :id => @user
	response.should redirect_to users_path
      end
      it "should not allow the admin user to destroy themself" do
        lambda do
	  delete :destroy, :id => @admin
	  response.should redirect_to users_path
	  flash[:notice].should =~ /not permitted/i
	end.should_not change(User, :count)
      end
    end
  end

  describe "follow pages" do
    describe "when not signed in" do 
      it "should protect 'following'" do
        get :following, :id => 1
        response.should redirect_to signin_path
      end
      it "should protect 'followers'" do
        get :followers, :id => 1
        response.should redirect_to signin_path
      end
    end
    describe "when signed in" do
      before :each do
        @user = test_sign_in Factory(:user)
	@other_user = Factory(:user, :email => Factory.next(:email))
	@user.follow! @other_user
      end
      it "should show user following" do
        get :following, :id => @user
	response.should have_selector('a',
	                              :href => user_path(@other_user),
				      :content => @other_user.name)
      end
      it "should show user followers" do
        get :followers, :id => @other_user
	response.should have_selector('a',
	                              :href => user_path(@user),
				      :content => @user.name)
      end
    end
  end

end
