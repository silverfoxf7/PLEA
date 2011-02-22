# == Schema Information
# Schema version: 20110222131910
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  attr_accessible :content  
  # users can only change the "content" of a post
  
  belongs_to :user
  
  default_scope :order => 'microposts.created_at DESC'
  # sets the order;  here, descending order of when created, 
  # pass columnn and direction of order
  
end
