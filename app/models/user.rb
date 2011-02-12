# == Schema Information
# Schema version: 20110210115839
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :name, :email, :password, :password_confirmation  
  #allows users to enter/change their name & email, pswd

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length   => { :maximum => 50 } 
  validates :email, :presence => true, 
                    :format => { :with => email_regex },     
                    :uniqueness => { :case_sensitive => false }
  # must follow format validation
  # must follow unique validation
  
  validates :password,  :presence => true, 
                        :confirmation => true,
                        :length   => { :within => 6..40 } 

  # we want to create the encrypted password before the user gets saved to the DB 
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    # compare submtted password with the encrypted password.
    # this is for the sign-in; user enters a pw; must compare 
    # it to the stored encrypted_password for that user. This method 
    # returns "true" if the passwords match.
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)  #can also be User.authenticate; we're using self because it's a valid class "self" reference
     user = User.find_by_email(email)
     # inside a self class method you can omit the "User." prefix.  It's implicit.
     return nil  if  user.nil?
     return user if user.has_password?(submitted_password) #returns true if submitted pw == encrypted pw
     
     # This method handles two cases (1. invalid email and 2. a successful match) with explicit 
     # return keywords, and handles the third case (password mismatch) implicitly, 
     # since in that case we reach the end of the method, which automatically returns nil.   
  # ------------------------------------------------------------------------
  # ------------------------------------------------------------------------
  # BELOW -- additions for authenticating sign-in users from Lesson #9

  def authenticate_with_salt(id, cookie_salt)
     user = find_by_id(id)
     (user && user.salt == cookie_salt) ? user : nil
     # IF (boolean AND boolean)? return value for TRUE : return value for FALSE
     
  end #authenticate_with_salt
  
  
  end
  
  private
    def encrypt_password
        self.salt = make_salt if new_record?  # make a salt only if it's a new record
        self.encrypted_password = encrypt(self.password)
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
        
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
end








