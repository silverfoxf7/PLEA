class JobpostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  def create
    @jobpost = current_user.jobposts.build(params[:jobpost])
      if @jobpost.save
        flash[:success] = "Project Created!"
        redirect_to root_path
      else
        @jobfeed_items = []
        render 'pages/home'
      end
  end

  def destroy
    @jobpost.destroy
    redirect_back_or root_path
  end

private

  def authorized_user
    @jobpost = Jobpost.find(params[:id])
    redirect_to root_path unless current_user?(@jobpost.user)
  end

end
