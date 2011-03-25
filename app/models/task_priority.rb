# == Schema Information
# Schema version: 20110319174252
#
# Table name: task_priorities
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class TaskPriority < ActiveRecord::Base


  validates :name, :presence => true,
                   :length       => { :within => 1..15 }

  validates :position, :presence => true,
                       :uniqueness => true
end
