require 'spec_helper'

describe Micropost do

  before(:each) do
    @user = Factory(:user)
    @attr = {:content => "lorem ipsum", :user_id => 1}
  end
  
  it "should create a new instance with valid attributes" do
    @user.microposts.create!(@attr)
    # will fail without the necessary associations
  end

  describe "user associations" do
    
    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end
    
    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end

  describe "validations" do
    it "should ..." do
      #left off at 31:13 of Lesson #11
    end
  end

end
