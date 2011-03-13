# == Schema Information
# Schema version: 20110313115615
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  username           :string(255)
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#  created_at         :datetime
#  updated_at         :datetime
#

class User < ActiveRecord::Base
  #####################
  #Attributes
  #####################
  attr_accessor :password
  attr_accessible :username, :email, :password, :password_confirmation

  #####################
  #Validations
  #####################
  username_regex = /^[a-z0-9\_\-\.]{5,20}$/
  validates :username, :presence => true,
                    :format => {:with => username_regex},
                    :uniqueness => {:case_sensitive => false}

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,
                    :format => {:with => email_regex},
                    :uniqueness => {:case_sensitive => false}
                  
  validates :password, :presence => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  #####################
  #Hooks
  #####################
  before_save :encrypt_password

  #####################
  #functions
  #####################
  def check_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(submitted_username, submitted_password)
    user = find_by_username(submitted_username)
    return nil  if user.nil?
    return user if user.check_password?(submitted_password)
  end

  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
       secure_hash "#{salt}--#{string}"
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
