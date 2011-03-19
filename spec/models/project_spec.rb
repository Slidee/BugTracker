require 'spec_helper'

describe Project do

  before(:each) do
    @attr = { :name => "Testing Project", :user_id => 1, :logo => "", :description => "My Test Project" }
  end
  
  describe " - project model - " do
    it "should create a project with valid values" do
      @project = Project.create(@attr)
    end

    ########################
    # Slug/Name Validation
    ########################
    it "should require a name" do
      no_name_project = Project.new(@attr.merge(:name => ""))
      no_name_project.should_not be_valid
    end

    it "should reject names that are too long" do
      long_name = "a" * 21
      long_name_project = Project.new(@attr.merge(:name => long_name))
      long_name_project.should_not be_valid
    end

    it "should reject all reserved names" do
      names = ["admin", "sprint", "sprints", "project", "projects", "admins", "help", "home", "contact", "about", "report"]
      names.each do |pname|
        invalid_project = Project.new(@attr.merge(:name => pname))
        invalid_project.should_not be_valid
      end
    end

    it "should accept valid names" do
      names = ["Valid Project", "Mon Projet Préféré", "Projet-de-la-Mort!", "Le projet du sciècle"]

      names.each do |pname|
        valid_project = Project.new(@attr.merge(:name => pname))
        valid_project.should be_valid
      end
    end

    ########################
    # USER_ID Validation
    ########################
    it "should require a user_id" do
      invalid_project = Project.new(@attr.merge(:user_id => nil))
      invalid_project.should_not be_valid
    end

    ######################
    ## Later modificaitons
    ######################
    it "slug should not change if i change name" do

      @project = Project.create(@attr)
      old_slug = @project.slug
      @project.name = "Another Name"
      @project.should be_valid
      @project.save!
      @project.slug.should == old_slug
    end
  end

end
