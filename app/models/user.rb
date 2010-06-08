class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable
  devise :registerable, :authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable,
	 :lockable, :timeoutable, :activatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation
end
