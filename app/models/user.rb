class User < ApplicationRecord
  acts_as_token_authenticatable	

  serialize :preferences

  has_many :surveys
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def generate_new_authentication_token
  	token = User.generate_unique_secure_token
  	update authentication_token: token
  end       
end
