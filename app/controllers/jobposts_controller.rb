class JobpostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :new, :destroy, :edit, :update]
  before_filter :authorized_user, :only => :destroy

  def index
    # page to show all projects (aka BROWSE)
    if signed_in?
           # abv:  performing search through Jobpost model
     	     @title = "Projects"
     	     @jobpost = Jobpost.new
           @search = Jobpost.search(params[:search])
           # stores all of the search results
     	     @jobfeed_items = @search.
             order(sort_column + ' ' + sort_direction).
             paginate(:per_page => 5, :page => params[:page])
    else
    	     @title = "Projects"
     	     @jobpost = Jobpost.new
           @search = Jobpost.search(params[:search])
           # stores all of the search results
     	     @jobfeed_items = @search.
             paginate(:per_page => 5, :page => params[:page])
    end
  end

  def show
    # page to show individual projects by ID
     	     @bid = Bid.new if signed_in?
           @title = "Projects"
     	     #@jobpost = Jobpost.new
           @job = Jobpost.find(params[:id]) 
           # id = show;  not right.  need it to pass id for a particular project
           # stores all of the search results
     	     @jobfeed_items = @job
           @bidfeed_items = @job.bids.all.paginate(:per_page => 30, :page => params[:page])
  end

  def new
    # page to make a new project page (post_project)
    @title = "Post a New Project"
    if signed_in?
          @jobpost = Jobpost.new if signed_in?
          @jobfeed_items = current_user.jobfeed.paginate(:page => params[:page])
          # can probably comment this out @jobfeed_items
    end
  end

  def create  #literally creates the post, whereas "new" is for a new post
    @jobpost = current_user.jobposts.build(params[:jobpost])
      if @jobpost.save
        flash[:success] = "Project Created!"
        redirect_to projects_path  # re-directing to projects#index
      else
        @jobfeed_items = []
        render 'jobposts/post_project'
        # perhaps using render (rather than redirect_to) because this way
        # we can see the errors that are being shown in FLASH msg.
      end
  end

  def edit
    # page to edit project with params ID

  end

  def update
    # updates project with params ID
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

  def sort_column
    Jobpost.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    # says: if Jobpost model has a column based on params:sort, then use
        # that content to sort the column, otherwise use "title" as default
    # might want to change the default parameter "title" to "expires in"
    # once that feature is implemented
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
    # made "desc" the default so we can see recently posted projects first.
  end

end
