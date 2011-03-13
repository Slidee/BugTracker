require 'faker'

namespace :db do
  desc "Fill database with default datas"
  task :load_default_datas => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:username => "admin",
                 :email => "admin.super@free.fr",
                 :password => "admin",
                 :password_confirmation => "admin")
    admin.toggle!(:admin)
  end

  task :load_test_datas => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:username => "admin",
                 :email => "admin.super@free.fr",
                 :password => "admin",
                 :password_confirmation => "admin")
    admin.toggle!(:admin)

    99.times do |n|
      username  = "user-#{n+1}"
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(:username => username,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end

  end
end