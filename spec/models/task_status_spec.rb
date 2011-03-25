require 'spec_helper'

describe TaskStatus do
  before(:each) do
    @attr = { :name => "Deployed", :type_enum => "end"}
    @sample_type = TaskStatus.create(@attr.merge(:name => "Verified"))
  end

  describe " - task_status model - " do
    it "should create a task_status with valid values" do
      task_status = TaskStatus.create(@attr)
    end

    ########################
    # Validations
    ########################
    it "should require a type_enum" do
      task_status = TaskStatus.new(@attr.merge( :type_enum => ""))
      task_status.should_not be_valid
    end

    it "should require a name" do
      task_status = TaskStatus.new(@attr.merge(:name => ""))
      task_status.should_not be_valid
    end
    
    it "name should be less than 15 chars" do
      long_name = "a"
      15.times { long_name += "l"}
      task_status = TaskStatus.new(@attr.merge(:name => long_name))
      task_status.should_not be_valid
    end

    ## Enum
    it "should reject unknown type_enum" do
      invalid_types = ["invalid", "unknown", "newenum", "trop cool"]
      invalid_types.each do |type|
        task_status = TaskStatus.new(@attr.merge( :type_enum => type))
        task_status.should_not be_valid
      end
    end

    it "should accept all valid type_enum" do
      TaskStatus.known_types.each do |type|
        task_status = TaskStatus.new(@attr.merge( :type_enum => type))
        task_status.should be_valid
      end

    end
  end

end
