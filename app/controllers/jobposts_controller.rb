class JobpostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  def create  #literally creates the post, whereas "new" is for a new post
    @jobpost = current_user.jobposts.build(params[:jobpost])
      if @jobpost.save
        flash[:success] = "Project Created!"
        redirect_to projects_path
      else
        @jobfeed_items = []
        render 'pages/post_project'
        # perhaps using render (rather than redirect_to) because this way
        # we can see the errors that are being shown in FLASH msg.
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
