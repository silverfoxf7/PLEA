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
#

class Jobpost < ActiveRecord::Base
  
  default_scope :order => 'jobposts.created_at DESC'
  
  attr_accessible :title, :location, :poster, :description, :work_type, 
                  :max_budget, :timeframe, :skills 
  
  belongs_to :user
  
  validates :location, :presence => true, :length => { :maximum => 100 }
  validates :poster, :presence => true, :length => { :maximum => 100 }
  validates :description, :presence => true, :length => { :maximum => 1000 }
  validates :title, :presence => true, :length => { :maximum => 100 }
  
  validates_numericality_of :work_type, :only_integer => true, 
                                        :message => "Can only be whole number."
  validates_inclusion_of :work_type, :in => 1..3, 
                                     :message => "Can only be a number between 1 and 3."
  
   validates_numericality_of :skills, :only_integer => true, 
                                         :message => "Can only be whole number."
   validates_inclusion_of :skills, :in => 1..3, 
                                      :message => "Can only be a number between 1 and 3."  
  # this RSPEC isn't testing properly.  Why?  Only works if I test validates 1-by-1.
  
   # need to validate 
          #  max_budget  :float
         #  timeframe   :datetime
  
  validates :user_id, :presence => true
  


  
  
end
