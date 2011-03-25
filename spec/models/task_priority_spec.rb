require 'spec_helper'

describe TaskPriority do
  before(:each) do
    @attr = { :name => "P1", :position => 1}
  end

  describe " - task_priority model - " do
    it "should create a task_priority with valid values" do
      task_prior = TaskPriority.create(@attr)
    end

    ########################
    # Validations
    ########################
    it "should require a position" do
      task_prior = TaskPriority.new(@attr.merge( :position => ""))
      task_prior.should_not be_valid
    end

    it "should require a name" do
      task_prior = TaskPriority.new(@attr.merge(:name => ""))
      task_prior.should_not be_valid
    end

    it "name should be less than 15 chars" do
      long_name = "a"
      15.times { long_name += "l"}
      task_prior = TaskPriority.new(@attr.merge(:name => long_name))
      task_prior.should_not be_valid
    end

    it "should require position uniqueness" do
      task_prior = TaskPriority.create!(@attr)
      task_prior_copy = TaskPriority.new(@attr)
      task_prior_copy.should_not be_valid
    end
    
  end
end
