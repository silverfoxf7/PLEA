class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in?
      @micropost = Micropost.new
      @jobpost = Jobpost.new if signed_in?
      @feed_items = current_user.feed.paginate(:page => params[:page])
      @jobfeed_items = current_user.jobfeed.paginate(:page => params[:page])
    end
  end

  def projects
     if signed_in?
     	     @title = "Projects"
     	     @jobpost = Jobpost.new
     	     @jobfeed_items = Jobpost.all.paginate(:page => params[:page])
     	     # @jobfeed_items = current_user.jobfeed.paginate(:page => params[:page])
     	     # if signed-in, then the commented line shows only signed-in-user's 
     	     # projects at the Browse Projects page.  
     	     # Now, with the runtime line, we show all projects.
     else
     	     @title = "Projects"
     	     @jobpost = Jobpost.new
     	     @jobfeed_items = Jobpost.all.paginate(:page => params[:page])
     	     # jobfeed is an array of jobpost items.  
     	     # for now, display ALL jobposts if NOT signed in
     end 
  end

  def post_project
  	  @title = "Post a New Project"
    if signed_in?
          @jobpost = Jobpost.new if signed_in?
          @jobfeed_items = current_user.jobfeed.paginate(:page => params[:page])
    end
  end  
  
  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end


end
