# == Schema Information
# Schema version: 20110315204512
#
# Table name: projects
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  slug        :string(255)
#  logo        :string(255)
#  description :text
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Project < ActiveRecord::Base
  include SlugHelper

  @@reserved_names = [
    "admin",
    "admins",
    "projects",
    "project",
    "sprints",
    "sprint",
    "about",
    "contact",
    "help",
    "home",
    "report",
    ]
    
  before_validation :generate_slug_from_name
  validates :name, :presence => true

  project_slug_regex = /^.{1,20}$/
  validates :slug, :presence => true,
                    :format => {:with => project_slug_regex},
                    :uniqueness => {:case_sensitive => false}

  #error must be on name because slug field is never shown
  validate :name , :validate_slug

  validates :user_id, :presence => true

  
  def validate_slug
    if @@reserved_names.include? self.slug
      errors.add(:name, "This Name is reserved please choose another one")
      return false
    end
    return true
  end

end
