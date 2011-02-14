class UsersController < ApplicationController

  before_filter :authenticate, :only => [:edit, :update]
  # used to effectuate a redirect to signin if trying to access unauth pages
  # but need an options hash to limit only some pages
  

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  
  def new
    @user = User.new
    @title = "Sign Up"
  end

  def create
    #raise params[:user].inspect
    
    @user = User.new(params[:user])
    if @user.save
      # handle a successful save.
      sign_in @user
      
      redirect_to user_path(@user), :flash => { :success => "Welcome to KIUBO!" }
  
      # this also works:
      # flash[:success] = "Welcome to KIUBO!"
      # redirect_to user_path(@user)
      
    else
      @title = "Sign Up"
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Edit User"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Profile updated." }
    else
     @title = "Edit User"
     render 'edit'
    end
  end
#---------------------------------
  private
    def authenticate
      deny_access unless signed_in?
      # deny_access is located in the sessions_helper for refactoring purposes
    end
    
  
end
