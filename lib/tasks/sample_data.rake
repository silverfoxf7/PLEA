

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
      var_work_type   = (1 + rand(3))   # 1 refers to doc review
      work_type = case var_work_type
        when 1 then "Document Review"
        when 2 then "Legal Research"
        else "Drafting Patent"
      end
      max_budget  = (1 + rand(100))  # generate random number between $1-100
      duration   = (1 + rand(100))  # generates 1-100 day projects
      var_skills      = (1 + rand(4))
      skills = case var_skills
        when 1 then "Spanish"
        when 2 then "Japanese"
        when 3 then "Patent"
        else ""
      end
      start_date          = rand_time(5.days.from_now, 5.weeks.from_now)
      overtime            = [true,false][rand(2)]
      work_intensity      = (1 + rand(100))
      user.jobposts.create!(
                  :title       => title,
                  :location    => location,
                  :poster      => poster,
                  :description => description,
                  :work_type   => work_type,
                  :max_budget  => max_budget,
                  :duration   => duration,
                  :skills      => skills,
                  :start_date  => start_date,
                  :overtime    => overtime,
                  :work_intensity => work_intensity)
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

def rand_int(from, to)
  rand_in_range(from, to).to_i
end

def rand_price(from, to)
  rand_in_range(from, to).round(2)
end

def rand_time(from, to)
  Time.at(rand_in_range(from.to_f, to.to_f))
end

def rand_in_range(from, to)
  rand * (to - from) + from
end