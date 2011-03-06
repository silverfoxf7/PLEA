# == Schema Information
# Schema version: 20110226200446
#
# Table name: jobposts
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  location    :string(255)
#  poster      :string(255)
#  description :text
#  work_type   :integer
#  max_budget  :float
#  timeframe   :datetime
#  skills      :integer
#  expiretime  :datetime   
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  start_date  :datetime
#  overtime    :boolean
#  work_intensity :integer
#
#  object.strftime("Printed on %m/%d/%Y")   #=> "Printed on 11/19/2007"
#  add an expected start_date
#  need to add boolean for "overtime" boolean
#  need to add work_intensity as expected hours/wk

class Jobpost < ActiveRecord::Base
  
#  default_scope :order => 'jobposts.created_at DESC'
# I removed the default_scope command so that I could implement the 
# Jobpost.order(params[:sort]) command within the _jobfeed_items partial.

  attr_accessible :title, :location, :poster, :description, :work_type, 
                  :max_budget, :duration, :skills, :start_date, :overtime,
                  :work_intensity
  
  belongs_to :user

  validates :start_date, :presence => true
  validates :location, :presence => true, :length => { :maximum => 100 }
  validates :poster, :presence => true, :length => { :maximum => 100 }
  validates :description, :presence => true, :length => { :maximum => 1000 }
  validates :title, :presence => true, :length => { :maximum => 100 }
  
#  validates_numericality_of :work_type, :only_integer => true,
#                                        :message => "Can only be whole number."
#  validates_inclusion_of :work_type, :in => 1..3,
#                                     :message => "Can only be a number between 1 and 3."

  validates :work_type, :presence => true,  :length => { :maximum => 100 }

#  validates :skills, :presence => true,     :length => { :maximum => 100 }
  
#  validates_numericality_of :skills, :only_integer => true,
#                                         :message => "Can only be whole number."

  validates_numericality_of :work_intensity, :only_integer => true,
          :message => "must be the number of work hours per week."

#  validates_inclusion_of :skills, :in => 1..3,
#                                      :message => "Can only be a number between 1 and 3."
  # this RSPEC isn't testing properly.  Why?  Only works if I test validates 1-by-1.
  
   # need to validate 
          #  max_budget  :float
         #  timeframe   :datetime
  
  validates :user_id, :presence => true

  # perform search functionality without meta_search
#def self.search(search)
#  if search
#    # you may want to use a full-text engine here instead of where(...)
#    # try thinking sphinx.  for a "keyword" search ala Trulia
## ----------------------------------------------------
#
##   where('title LIKE ?',  "%#{search}%")
#      # this older method uses the Rails default search
#    where({:title.matches => "%#{search}%"} |
#          {:location.matches => "%#{search}%"})
#    # this method uses the meta_where method.  They are identical.
#  else
## the find(:all) may phase out with later versions of Rails. instead we use
## "scoped" so we don't actually hit the database for info.
#    scoped
#     #
#  end
#end

  # performs search using meta_where
  # currently un-used
#def self.keyword_search(search)
#  if search
#    where({:title.matches => "%#{search}%"} |
#          {:location.matches => "%#{search}%"} |
#          {:poster.matches => "%#{search}%"} |
#          {:work_type.matches => "%#{search}%"} |
#          {:max_budget.matches => "%#{search}%"} |
#          {:timeframe.matches => "%#{search}%"} |
#          {:poster.matches => "%#{search}%"} |
#          {:skills.matches => "%#{search}%"} |
#          {:description.matches => "%#{search}%"})
#  else
#    scoped
#  end
#end
  
end