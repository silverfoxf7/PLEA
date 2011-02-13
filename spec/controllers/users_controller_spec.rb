require 'spec_helper'

describe UsersController do
  render_views

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
  
end
