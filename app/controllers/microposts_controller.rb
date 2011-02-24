class MicropostsController < ApplicationController
  
  before_filter :authenticate
  
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    # don't use "micropost.new" b/c we want the new micropost to be associated to
    # a particular user.  Here, the user that is logged in is "current_user"
    if @micropost.save 
      redirect_to root_path, :flash => {:success => "Micropost created!"}
    else
      render 'pages/home'
    end
  end
  
  def destroy
  end
  
end