class PagesController < ApplicationController
  helper_method :sort_column, :sort_direction

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

# jobfeed is an array of jobpost items.  
# 3/1/11: display jobposts ordered by params

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

private
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
