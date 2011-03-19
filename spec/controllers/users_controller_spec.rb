require 'spec_helper'

describe UsersController do
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

        second = Factory(:user, :username => "billou", :email => "another@example.com")
        third  = Factory(:user, :username => "boubou", :email => "another@example.net")

        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email), :username => Factory.next(:username))
        end
      end

      it 'should respond success' do
        get :index
        response.should be_success
      end

      it 'should have proper title'do
        get :index
        response.should have_selector("title",:content => "Users list")
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("span", :content => user.username)
        end
      end
    end
  end






  describe "GET 'show'" do
    before(:each) do
        @user = Factory(:user)
    end

    describe "for non-connected users" do
      it "should respond failur" do
        get :show, :id => @user
        response.should_not be_success
      end
      it "should redirect to signin " do
        get :show, :id => @user
        response.should redirect_to(signin_path)
        flash[:notice] =~ /sign in/i
      end
    end

    describe "for connected non-admin users different from the one to see" do
      before(:each) do
        test_sign_in(@user)
        @to_see_user = Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email))
      end

      it "should respond failure" do
        get :show, :id => @to_see_user
        response.should_not be_success
      end
      it "should redirect to home (not allowed)" do
        get :show, :id => @to_see_user
        response.should redirect_to(root_path)
        flash[:notice] =~ /not allowed/i
      end
    end

    describe "for connected non-admin users same as the one to show" do
      before(:each) do
        test_sign_in(@user)
      end

      it "should respond success" do
        get :show, :id => @user
        response.should be_success
      end
      it "should have proper title" do
        get :show, :id => @user
        response.should have_selector("title", :content => "User "+@user.username)
      end
      it "should find the right user" do
        get :show, :id => @user
        assigns(:user).should == @user
      end
      it "should include the user's name" do
        get :show, :id => @user
        response.should have_selector("h1", :content => @user.username)
      end
    end

    describe "for connected admin users" do
      before(:each) do
        @admin = Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email))
        @admin.toggle(:admin)
        @admin.save!
        test_sign_in(@admin)
      end
      
      it "should respond success" do
        get :show, :id => @user
        response.should be_success
      end
      it "should have proper title" do
        get :show, :id => @user
        response.should have_selector("title", :content => "User "+@user.username)
      end
      it "should find the right user" do
        get :show, :id => @user
        assigns(:user).should == @user
      end
      it "should include the user's name" do
        get :show, :id => @user
        response.should have_selector("h1", :content => @user.username)
      end

    end
  end






  describe "GET 'new'" do

    describe "for non-connected users" do
      it "should respond failure" do
        get :new
        response.should_not be_success
      end
      it "should redirect to signin" do
        get :new
        response.should redirect_to(signin_path)
        flash[:notice] =~ /sign in/i
      end
    end

    describe "for connected non-admin users" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should respond failure" do
        get :new
        response.should_not be_success
      end
      it "should redirect to home (not allowed)" do
        get :new
        response.should redirect_to(root_path)
        flash[:notice] =~ /not allowed/i
      end
    end

    describe "for connected admin users" do
      before(:each) do
        @admin = Factory(:user)
        @admin.toggle(:admin)
        @admin.save!
        test_sign_in(@admin)
      end

      it "should respond success" do
        get :new
        response.should be_success
      end
      it "should have proper title" do
        get :new
        response.should have_selector("title", :content => "New user")
      end

      it "should have a username field" do
        get :new
        response.should have_selector("input[name='user[username]'][type='text']")
      end

      it "should have an email field" do
        get :new
        response.should have_selector("input[name='user[email]'][type='text']")
      end

      it "should have a password field" do
        get :new
        response.should have_selector("input[name='user[password]'][type='password']")
      end

      it "should have a password confirmation field" do
        get :new
        response.should have_selector("input[name='user[password_confirmation]'][type='password']")
      end
    end
  end






  describe "POST 'create'" do

    describe "as a logged-in admin user" do
      before(:each) do
        @admin = Factory(:user, :username => "adminuser", :email => "admin@user.org")
        @admin.toggle(:admin)
        @admin.save!
        test_sign_in(@admin)
      end

      describe "failure" do

        before(:each) do
          @attr = { :username => "", :email => "", :password => "",
                    :password_confirmation => "" }
        end

        it "should not create a user" do
          lambda do
            post :create, :user => @attr
          end.should_not change(User, :count)
        end

        it "should have the right title" do
          post :create, :user => @attr
          response.should have_selector("title", :content => "New user")
        end

        it "should render the 'new' page" do
          post :create, :user => @attr
          response.should render_template('new')
        end
      end

      describe "success" do

        before(:each) do
          @attr = { :username => "newusername", :email => "new-user@example.com",
                    :password => "foobar", :password_confirmation => "foobar" }
        end

        it "should create a user" do
          lambda do
            post :create, :user => @attr
          end.should change(User, :count).by(1)
        end

        it "should redirect to the user show page" do
          post :create, :user => @attr
          response.should redirect_to(user_path(assigns(:user)))
        end
      end
    end

    describe "as a non-admin signed-in-user" do

      before(:each) do
        @user = Factory(:user)
      end

      it "should deny access" do
        test_sign_in(@user)
        post :create, :user => @attr
        response.should redirect_to(root_path)
      end
    end

    describe "as a not signed-in user" do
      it "should deny access" do
        post :create, :user => @attr
        response.should redirect_to(signin_path)
      end
    end
  end




  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "as a not signed-in user" do
      it "should deny access" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin signed-in user, the one to edit" do
      before(:each) do
        test_sign_in(@user)
      end

      it "should be successful" do
        get :edit, :id => @user
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector("title", :content => "Edit user")
      end



    end
    describe "as a non-admin signed-in user, another one than the one to edit" do
      before(:each) do
        @other_user = Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email))
        test_sign_in(@other_user)
      end
      it "should deny access" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
    end



    describe "as an admin signed-in user" do

      before(:each) do
        @admin = Factory(:user, :username => "adminsuperuser" , :email => "admin@super.org")
        @admin.toggle(:admin)
        @admin.save!
        test_sign_in(@admin)
      end

      it "should be successful" do
        get :edit, :id => @user
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector("title", :content => "Edit user")
      end
    end
  end







  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      #test_sign_in(@user)
    end

    describe "as a logged-in admin user" do
      before(:each) do
        @admin = Factory(:user, :username => "adminuser2", :email => "admin2@user.org")
        @admin.toggle(:admin)
        @admin.save!
        test_sign_in(@admin)
      end

      describe "failure" do

        before(:each) do
          @attr = { :email => "", :username => "", :password => "",
                    :password_confirmation => "" }
        end

        it "should render the 'edit' page" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "Edit user")
        end
      end

      describe "success" do

        before(:each) do
          @attr = { :username => "editusername", :email => "user@example.org",
                    :password => "barbaz", :password_confirmation => "barbaz" }
        end

        it "should change the user's attributes" do
          put :update, :id => @user, :user => @attr
          @user.reload
          @user.username.should  == @attr[:username]
          @user.email.should == @attr[:email]
        end

        it "should redirect to the user show page" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(@user)
        end

        it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/
        end
      end
    end
  end




  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        @admin = Factory(:user, :username => "adminuser3", :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end

      describe "different from the one to delete" do

        it "should destroy the user" do
          lambda do
            delete :destroy, :id => @user
          end.should change(User, :count).by(-1)
        end

        it "should redirect to the users page" do
          delete :destroy, :id => @user
          response.should redirect_to(users_path)
        end

      end


      describe "the same as the one to delete" do

        it "should not destroy the user" do
          lambda do
            delete :destroy, :id => @admin
          end.should_not change(User, :count)
        end

        it "should redirect to the main page" do
          delete :destroy, :id => @admin
          response.should redirect_to(root_path)
        end

      end
    end
  end


end
