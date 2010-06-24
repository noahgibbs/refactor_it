class User < ActiveRecord::Base
  has_many :snippets
  has_many :refactors
  has_many :votes

  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable,
	 :lockable, :timeoutable, :activatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :password,
                  :password_confirmation

  validates_uniqueness_of :email
  validates_uniqueness_of :username
  validates_format_of :email, :with => /\A[^@\s]+@[^@\s]+\Z/
  validates_format_of :username, :with => /^([a-z0-9_-]|\s)+$/i
  validates_length_of :username, :within => 2..20

  def self.find_for_authentication(conditions = {})
    conditions = ["username = ? OR email = ?", conditions[:username],
                  conditions[:username]]
    super
  end
end
