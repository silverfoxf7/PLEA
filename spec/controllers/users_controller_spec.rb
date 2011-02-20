require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do
    describe "for non-signed-in users" do
      it "should deny access to 'index'" do
        get :index
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in-users" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        Factory(:user, :email => "another@example.com")
        Factory(:user, :email => "another@example.net")
        # now to test pagination... need 30 more users
        30.times do
          Factory(:user, :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :index 
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector('title', :content => "All Users")
      end
      
      it "should have an element for each user" do
        get :index
        User.paginate(:page => 1).each do |user|
          response.should have_selector('li', :content => user.name)
        end
      end
      
      it "should paginate users" do
        get :index
        response.should have_selector('div.pagination')
        response.should have_selector('span.disabled', :content => "Previous")
        response.should have_selector('a', :href => "/users?page=2", :content => "2")
        response.should have_selector('a', :href => "/users?page=2", :content => "Next")
        # these tests were obtained by looking at the HTML in the sample_app
      end
    end
  end
  


  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end
        
    it "should be successful" do
#     get :show  would be broken because there is no user; need to pass :id
#     here, we're using Factories gem to define user in tests.
      get :show, :id => @user.id  # rails is permissive; dont need .id at the end
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end    

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector('title', :content => @user.name)
    end
    
    it "should have the user's name" do
      get :show, :id => @user
      response.should have_selector('h1', :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector('h1>img', :class => "gravatar")
    end

    it "should have the right URL" do
      get :show, :id => @user
      response.should have_selector('td>a', :content => user_path(@user), 
                                            :href    => user_path(@user))
    end

  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    
    
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Sign Up")
    end
  end
  
  describe "POST 'create'" do
  
    describe "failure" do
        before(:each) do
          @attr = { :name => "", :email => "", :password => "", 
                                 :password_confirmation => ""}
        end
    
        it "should have the right title" do
          post :create, :user => @attr
          response.should have_selector('title', :content => "Sign Up")
        end
        
        it "should render the 'new' page" do
          post :create, :user => @attr
          response.should render_template('new')
        end
        
        it "should not create a user" do 
          lambda do
            post :create, :key => @attr
          end.should_not change(User, :count)
          # change( X, :Y ) takes the object X and appends .Y, then checks to see if it changed
          # useful to see if passing invalid @attr (empties) changed the number of users in database
        end    
    end
    
    describe "success" do
      before(:each) do
        @attr = {:name => "New User", :email => "user@example.com", 
                  :password => "foobar",  :password_confirmation => "foobar"}
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        # response.should redirect_to(user_path(@user))  <-- no good b/c test page can't access @user directly; ned to use "assigns"
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to KIUBO!/i
        # =~ is a "match" command
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
      response.should have_selector('title', :content => "Edit User")
    end
    
    it "should have a link to change the gravatar" do
      get :edit, :id => @user
      response.should have_selector('a', :href => 'http://gravatar.com/emails', 
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
                               :password_confirmation => ""}
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      
      it "should hvae the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector('title', :content => "Edit User")
      end
    end
    
    describe "success" do
      before(:each) do 
        @attr = {:name => "New Name", :email => "user@example.org", 
                 :password => "barbaz", :password_confirmation => "barbaz"}
        end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        user = assigns(:user)
        @user.reload
        @user.name.should == user.name
        @user.email.should == user.email
        @user.encrypted_password.should == user.encrypted_password
      end
      
      it "should have an update flash msg" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end 
    end  
  end
  
  describe "authentication of edit/update actions" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    
      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end    
    end
    
    describe "for signed-in users" do
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end      
      
    end
      # left off at 1:01:19 of Ch. 10
  end
  
end







