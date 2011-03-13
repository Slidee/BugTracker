require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :username => "sampleuser",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  describe "User model" do
    it "should create a new instance given valid attributes" do
      User.create!(@attr)
    end

    ########################
    #Username validation
    ########################
    it "should require a username" do
      no_name_user = User.new(@attr.merge(:username => ""))
      no_name_user.should_not be_valid
    end

    it "should reject usernames that are too long" do
      long_name = "a" * 21
      long_name_user = User.new(@attr.merge(:username => long_name))
      long_name_user.should_not be_valid
    end

    it "should reject invalid usernames" do
      usernames = ["Not Valid", "InvŽalid", "Žvidement!", "inv"]
      usernames.each do |uname|
        invalid_user = User.new(@attr.merge(:username => uname))
        invalid_user.should_not be_valid
      end
    end

    it "should accept valid usernames" do
      usernames = %w(valid.user user-named the_user)
      usernames.each do |uname|
        valid_user = User.new(@attr.merge(:username => uname))
        valid_user.should be_valid
      end
    end
    
    it "should reject duplicate usernames" do
      # Put a user with given email address into the database.
      User.create!(@attr)
      user_with_duplicate_name = User.new(@attr)
      user_with_duplicate_name.should_not be_valid
    end

    ########################
    #Email validation
    ########################
    it "should require an email address" do
      no_email_user = User.new(@attr.merge(:email => ""))
      no_email_user.should_not be_valid
    end

    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should be_valid
      end
    end

    it "should not accept invalid email addresses" do
      addresses = %w[@foo.com.me me.domaine.be @foo.b@]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should_not be_valid
      end
    end

    it "should reject duplicate email addresses" do
      # Put a user with given email address into the database.
      User.create!(@attr)
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end

    it "should reject email addresses identical up to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "check_password? method" do

      it "should be true if the passwords match" do
        @user.check_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.check_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do

      it "should return nil on username/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:username], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an username with no user" do
        nonexistent_user = User.authenticate("nouser", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on username/password match" do
        matching_user = User.authenticate(@attr[:username], @attr[:password])
        matching_user.should == @user
      end
    end
  end

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
end
