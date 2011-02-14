module SessionsHelper
  # this will be the source of the signin function in sessions_controller.rb
  # but remember that HELPERS are not usually available in the controllers; they're
  # available by default in the VIEWS html.erb.  We need to include it in
  # the Applications Controller so that it gets inherited to every other controller. 

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    # cookies.permanent is putting a permanent, encrypted cookie "remember_token" 
    # on the user's browser
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
    # AKA setter method
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !current_user.nil?       
  end
    
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def deny_access
    redirect_to signin_path, :notice => "Please sign in to access this page." 
  end
  
  #---------  
  private 
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
      # the * operator "unwraps" a set of array brackets
    end #user_from_remember_token
    
    def remember_token 
      cookies.signed[:remember_token] || [nil, nil]
    end #remember_token
  
  
end
