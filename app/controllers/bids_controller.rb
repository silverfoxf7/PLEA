class BidsController < ApplicationController
  before_filter :authenticate, :only => [:create, :new, :destroy, :edit, :update]
  before_filter :authorized_user, :only => :destroy

#  probably dont need an Index or Show action.  Need only create/delete bids

#  def index
#    # page to show all bids (aka BROWSE)
#    if signed_in?
#    	     @title = "All Bids"
#           @jobpost = Jobpost.find(params[:jobpost_id])
#           @bidfeed_items = @jobpost.bids.all.paginate(:per_page => 5, :page => params[:page])
#    else
#    	     @title = "All Bids"
## below-- shows all bids for Jobpost with ID from webpage
## can probably get rid of these below ... bloated code
#           @jobpost = Jobpost.find(params[:jobpost_id])
#           @bidfeed_items = @jobpost.bids.all.paginate(:per_page => 5, :page => params[:page])
#
## below-- shows all bids for User with ID 1
##           @bidindex = Bid.where("user_id = ?", 1)
##           @bidfeed_items = @bidindex.all.paginate(:per_page => 5, :page => params[:page])
#
## below-- shows all bids for all projects
##           @bidindex = Bid.find(:all)
##           @bidfeed_items = @bidindex.paginate(:per_page => 30, :page => params[:page])
#
#
#    end
#  end
#
#  def show
#    	     @title = "Bids"
#
## can probably get rid of these below ... bloated code
#           @jobpost = Jobpost.find(params[:jobpost_id])
#           @bidfeed_items = @jobpost.bids.all.paginate(:per_page => 5, :page => params[:page])
#  end
#
#  def new  # a pre-resource for creating a new Bid
#    # page to make a new project page (post_project)
#    @title = "Post a New Project"
#    if signed_in?
#          @bid = Bid.new if signed_in?
##          @bidfeed_items = current_user.jobfeed.paginate(:page => params[:page])
#          # can probably comment this out @bidfeed_items
#    end
#  end

  def create  #literally creates the bid, whereas "new" is for a new post page
    @bid = current_user.bids.build(params[:bid])
      if @bid.save
        flash[:success] = "Bid Submitted!"
        redirect_to :back
# redirects back to the project that you posted at
      else
        @bidfeed_items = []
        redirect_to :back, :alert => "Please enter an appropriate bid."
      end
  end

  def edit
    # page to edit project with params ID
  end

  def update
    # updates project with params ID
  end

  def destroy
    @bid.destroy
    redirect_back_or root_path
  end

private

  def authorized_user
    @bid = Bid.find(params[:id])
    redirect_to root_path unless current_user?(@bid.user)
  end

  def sort_column
    Bid.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
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
