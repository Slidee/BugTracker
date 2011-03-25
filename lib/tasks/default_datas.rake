namespace :db do
  desc "Fill database with default datas"
  task :load_default_datas => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:username => "admin",
                 :email => "admin.super@free.fr",
                 :password => "adminpass",
                 :password_confirmation => "adminpass")
    admin.toggle!(:admin)

    #################
    ## TASK STATUSES
    TaskStatus.create!(:name => "Not Started", :type_enum => "start")
    TaskStatus.create!(:name => "In Progress", :type_enum => "current")
    TaskStatus.create!(:name => "In Pause", :type_enum => "current")
    TaskStatus.create!(:name => "Completed", :type_enum => "end")
    TaskStatus.create!(:name => "Verified", :type_enum => "end")
    TaskStatus.create!(:name => "Deployed", :type_enum => "end")
    TaskStatus.create!(:name => "Canceled", :type_enum => "cancel")
    TaskStatus.create!(:name => "Duplicate", :type_enum => "cancel")
    TaskStatus.create!(:name => "Will not do", :type_enum => "cancel")

    #################
    ## TASK PRIORITY
    TaskPriority.create!(:name => "Low", :position => 1)
    TaskPriority.create!(:name => "Medium", :position => 2)
    TaskPriority.create!(:name => "High", :position => 3)
    TaskPriority.create!(:name => "Critical", :position => 4)
  end

  task :load_test_datas => :environment do
    Rake::Task['db:reset'].invoke
    Rake::Task['db:load_default_datas'].invoke

    ##################
    ## Test Users
    99.times do |n|
      username  = "user-#{n+1}"
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(:username => username,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end

    1.times do |n|
      name = "Testing Project"
      description = "This #{n+1} Project is b"
      project = Project.new(:name => name, :description => description, :user_id => rand(10))
      project.save
      3.times do |m|
        project.sprints.create!(:name => "Sprint #{m+1}", :goals => "This sprint #{m+1} has no specific Goals")
      end
    end

  end
end