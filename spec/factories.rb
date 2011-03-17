# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.username              "sample_user"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :project do |project|
  project.name              "My Sample Project"
  project.description       "My Project Description, So fun developing with Ruby !!"
  project.logo              "/uploads/logos/sample_logo.png"
  project.user_id           1
end




Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :username do |n|
  "testxxxx-#{n}"
end

Factory.sequence :name do |n|
  "My XX Named #{n}"
end
