

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    
    Rake::Task['db:reset'].invoke
    make_users
    make_jobposts
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(:name => "Example User",
                       :email => "example@railstutorial.org",
                       :password => "foobar",
                       :password_confirmation => "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_jobposts
  User.all(:limit => 30).each do |user|
    2.times do
      title       = Faker::Lorem.sentence(1) # => "Big Document Review Project",
      location    = Faker::Lorem.sentence(1) #=> "New York, NY",
      poster      = user.name #=> the name of the user with user_id,
      description = Faker::Lorem.paragraph(5) #=> "This is a document review project.",
      work_type   = (1 + rand(3))   # 1 refers to doc review
      max_budget  = (1 + rand(100))  # generate random number between $1-100
      timeframe   = Time.now
      skills      = (1 + rand(3))    
      user.jobposts.create!(
                  :title       => title,
                  :location    => location,
                  :poster      => poster,
                  :description => description,
                  :work_type   => work_type,
                  :max_budget  => max_budget,
                  :timeframe   => timeframe,
                  :skills      => skills)
    end
  end
end

def make_microposts
  User.all(:limit => 6).each do |user|
    50.times do
      content = Faker::Lorem.sentence(5)
      user.microposts.create!(:content => content)
    end
  end
end

def make_relationships
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end