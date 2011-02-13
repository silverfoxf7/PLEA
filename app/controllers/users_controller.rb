class UsersController < ApplicationController

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
  
end
