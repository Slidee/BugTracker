require 'spec_helper'

describe ProjectsController do
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
        @project = Factory(:project)
        second = Factory(:project, :name => "billou")
        third  = Factory(:project, :name => "boubou")

        @projects = [@project, second, third]
        30.times do
          @projects << Factory(:project, :name => Factory.next(:name))
        end
      end

      it 'should respond success' do
        get :index
        response.should be_success
      end

      it 'should have proper title'do
        get :index
        response.should have_selector("title",:content => "Projects list")
      end

      it "should have an element for each project" do
        get :index
        @projects[0..2].each do |project|
          response.should have_selector("td", :content => project.name)
        end
      end
    end
  end






  describe "GET 'show'" do
    before(:each) do
        @project = Factory(:project)
    end

    describe "for non-connected users" do
      it "should respond failure" do
        get :show, :project_slug => @project.slug
        response.should_not be_success
      end
      it "should redirect to signin " do
        get :show, :project_slug => @project.slug
        response.should redirect_to(signin_path)
        flash[:notice] =~ /sign in/i
      end
    end

    describe "for connected admin userss" do
      before(:each) do
        @admin = Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email))
        @admin.toggle(:admin)
        @admin.save!
        test_sign_in(@admin)
      end

      it "should respond success" do
        get :show, :project_slug => @project.slug
        response.should be_success
      end
      it "should have proper title" do
        get :show, :project_slug => @project.slug
        response.should have_selector("title", :content => @project.name)
      end
      it "should find the right project" do
        get :show, :project_slug => @project.slug
        assigns(:project).should == @project
      end
      it "should include the project's name" do
        get :show, :project_slug => @project.slug
        response.should have_selector("h1", :content => @project.name)
      end

    end

#    describe "for non-admin users (signed-in)" do
#
#      before(:each) do
#        @user = Factory(:user)
#        test_sign_in(@user)
#      end
#
#      it "should respond failure" do
#        get :show, :project_slug => @project.slug
#        response.should_not be_success
#      end
#
#      it "should deny access" do
#        get :show, :project_slug => @project.slug
#        response.should redirect_to(root_path)
#      end
#    end
  end



  describe "POST 'create'" do

    describe "as a logged-in admin user" do
      before(:each) do
        @admin = Factory(:user, :username => "adminuser", :email => "admin@project.org")
        @admin.toggle(:admin)
        @admin.save!
        test_sign_in(@admin)
      end

      describe "failure" do

        before(:each) do
          @attr = { :name => "", :logo => "", :description => "Mon Projet à moi", :user_id => 3}
        end

        it "should not create a project" do
          lambda do
            post :create, :project => @attr
          end.should_not change(Project, :count)
        end
      end

      describe "success" do

        before(:each) do
         @attr = { :name => "Mon projet top", :logo => "/uploads/logo-de-la-mort", :description => "Mon Projet à moi", :user_id => 3}
        end

        it "should create a project" do
          lambda do
            post :create, :project => @attr
          end.should change(Project, :count).by(1)
        end
      end
    end

    describe "as a non-admin signed-in-user" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should be failure" do
        post :create, :project => @attr
        response.should_not be_success
      end
      it "should deny access" do
        post :create, :project => @attr
        response.should redirect_to(root_path)
      end
    end

    describe "as a not signed-in user" do
      it "should be failure" do
        post :create, :project => @attr
        response.should_not be_success
      end
      it "should deny access" do
        post :create, :project => @attr
        response.should redirect_to(signin_path)
      end
    end
  end


  describe "DELETE 'destroy'" do

    before(:each) do
      @project = Factory(:project)
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should be failure" do
        delete :destroy, :project_slug => @project.slug
        response.should_not be_success
      end
      it "should deny access" do
        delete :destroy, :project_slug => @project.slug
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do

      before(:each) do
        test_sign_in(@user)
      end
      
      it "should be failure" do
        delete :destroy, :project_slug => @project.slug
        response.should_not be_success
      end
      it "should protect the page" do
        
        delete :destroy, :project_slug => @project.slug
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        @admin = Factory(:user, :username => "adminproject3", :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end

      it "should destroy the project" do
        lambda do
          delete :destroy, :project_slug => @project.slug
        end.should change(Project, :count).by(-1)
      end

      it "should redirect to the projects page" do
        delete :destroy, :project_slug => @project.slug
        response.should redirect_to(projects_path)
      end

    end
  end
end
