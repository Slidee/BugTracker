require 'spec_helper'

describe Sprint do
  
  before(:each) do
    @project = Factory(:project)
    
    @attr = { :name => "Test sprint", :goals => "My Test sprint", :start_date => "2010-03-14", :end_date => "2010-03-30" }
  end
  
  describe " - sprint model - " do
    it "should create a sprint with valid values" do
      @sprint = @project.sprints.create(@attr)
    end

    ########################
    # Validations
    ########################
    it "should require a project id" do
      Sprint.new(@attr).should_not be_valid
    end
    
    it "should require a name" do
      no_name_sprint = @project.sprints.new(@attr.merge(:name => ""))
      no_name_sprint.should_not be_valid
    end

    it "should reject names that are too long" do
      long_name = "a" * 21
      long_name_sprint = @project.sprints.new(@attr.merge(:name => long_name))
      long_name_sprint.should_not be_valid
    end

    it "should reject all reserved names" do
      names = ["sprints", "sprint"]
      names.each do |pname|
        invalid_sprint = @project.sprints.new(@attr.merge(:name => pname))
        invalid_sprint.should_not be_valid
      end
    end

    it "should accept valid names" do
      names = ["Valid sprint", "Mon Sprint Préféré", "Sprint-de-la-Mort!", "Le sprint du sciècle"]

      names.each do |pname|
        valid_sprint = @project.sprints.new(@attr.merge(:name => pname))
        valid_sprint.should be_valid
      end
    end

    ######################
    ## Later modificaitons
    ######################
    it "slug should not change if i change name" do

      @sprint = @project.sprints.create(@attr)
      old_slug = @sprint.slug
      @sprint.name = "Another Name"
      @sprint.should be_valid
      @sprint.save!
      @sprint.slug.should == old_slug
      
    end

    ###########################
    ##### Relations
    ###########################
    describe "project associations" do

      before(:each) do
        @sprint = @project.sprints.create(@attr)
      end

      it "should have a project attribute" do
        @sprint.should respond_to(:project)
      end

      it "should have the right associated project" do
        @sprint.project_id.should == @project.id
        @sprint.project.should == @project
      end
    end
  end


end
