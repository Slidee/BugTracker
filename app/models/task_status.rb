# == Schema Information
# Schema version: 20110319174252
#
# Table name: task_statuses
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  type_enum  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class TaskStatus < ActiveRecord::Base
  @@known_types = ["start","current","cancel", "end"]
  def self.known_types
    return @@known_types
  end


  #######################
  ## Validations
  validates :name, :presence => true,
                   :length       => { :within => 1..15 }

  validates :type_enum, :presence => true

  validate :type_enum, :verify_known_type

  def verify_known_type
    if !@@known_types.include? self.type_enum
      errors.add(:type_enum, "Unknown TaskStatus type, please choose a valid one")
      return false
    end
    return true
  end
end
