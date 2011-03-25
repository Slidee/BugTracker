require 'spec_helper'

describe ConfigController do
  render_views

  describe "GET 'index'" do

    describe "for non-connected users" do

      it 'should respond failure' do
        get :index
        response.should_not be_success
      end

      it 'should have redirect to signin page'do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice] =~ /sign in/i
      end
    end

    describe "for connected but non-admin users" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
      end

      it 'should respond failure' do
        get :index
        response.should_not be_success
      end

      it 'should have redirect to root page'do
        get :index
        response.should redirect_to(root_path)
        flash[:notice] =~ /not allowed/i
      end

    end

    describe "for connected admin users" do
      before(:each) do
        @user = Factory(:user)
        @user.toggle(:admin)
        @user.save!
        test_sign_in(@user)

        @task_priorities = []
        30.times do |n|
          @task_priorities << TaskPriority.create!(:name => "P#{n}", :position => n+1 )
        end

        @status_1 = TaskStatus.create!(:name => "NotStarted", :type_enum => "start")
        @status_2 = TaskStatus.create!(:name => "In Progress", :type_enum => "current")
        @status_3 = TaskStatus.create!(:name => "Finished", :type_enum => "end")
        @status_4 = TaskStatus.create!(:name => "Canceled", :type_enum => "cancel")

        @task_statuses = [@status_1, @status_2, @status_3, @status_4]
      end

      it 'should respond success' do
        get :index
        response.should be_success
      end

      it 'should have proper title'do
        get :index
        response.should have_selector("title",:content => "Tracker Config")
      end

      it "should have an element for each taskpriority" do
        get :index
        @task_priorities.each do |task_priority|
          response.should have_selector("span", :content => task_priority.name)
        end
      end

      it "should have an element for each taskstatus" do
        get :index
        @task_statuses.each do |task_status|
          response.should have_selector("span", :content => task_status.name)
        end
      end
    end
  end
end
