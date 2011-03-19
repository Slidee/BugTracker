# == Schema Information
# Schema version: 20110318195832
#
# Table name: sprints
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  goals      :text
#  start_date :date
#  end_date   :date
#  created_at :datetime
#  updated_at :datetime
#  project_id :integer
#

class Sprint < ActiveRecord::Base
  include SlugHelper

  ##################
  ##### Relations
  belongs_to :project


  ##################
  ##### Validations
  before_validation :generate_slug_from_name
  @@reserved_names = [
    "sprints",
    "sprint",
  ]
  validates :name, :presence => true
  project_slug_regex = /^[a-z0-9\_\-]{1,20}$/
  validates :slug, :presence => true,
                    :format => {:with => project_slug_regex},
                    :uniqueness => {:case_sensitive => false}

  validates :project_id, :presence => true
  
  validate :name , :validate_slug

  def validate_slug
    if @@reserved_names.include? self.slug
      errors.add(:name, "This Name is reserved please choose another one")
      return false
    end
    return true
  end

end
