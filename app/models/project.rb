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

  def generate_slug_from_name
    if !self.new_record? #Si ce n'est pas
      return true
    end
    
    if self.name.empty? || self.name.nil?
      return false
    end
    
    slug_generated = self.name.downcase
    #slug_generated.strip
    slug_generated.gsub(/[^a-z0-9\s-]/, '') # Remove non-word characters
    slug_generated.gsub(/\s+/, '-')     # Convert whitespaces to dashes
    slug_generated.gsub(/-\z/, '')      # Remove trailing dashes
    slug_generated.gsub(/-+/, '-')      # get rid of double-dashes

    slug_num = slug_number(slug_generated)
    if slug_num == false
      self.slug = slug_generated
    else
      self.slug = slug_generated+"-"+slug_num
    end
    
    return true
  end

  def slug_number(slug_to_test)
    slug_like_objects  = Project.select("slug").
                                  where("slug LIKE ?",slug_to_test+"%").
                                  all()

    if !slug_like_objects.include?(slug_to_test)
      return false
    else
      counter = 1
      slug_found= false
      while !slug_found && counter < 999 do
        if(!slug_like_objects.include?(slug_to_test+"-"+counter))
          slug_found = true
          return counter
        end
      end
      return counter # au cas ou
    end

  end
end
