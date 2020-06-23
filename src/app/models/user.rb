class User < ApplicationRecord
  rolify

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :films
  has_many :user_actions_from, class_name: "UserAction", foreign_key: "from_user_id"
  has_many :user_actions_to, class_name: "UserAction", foreign_key: "to_user_id"

  # Will return an array of follows for the given user instance
  has_many :received_follows, foreign_key: :followee_id, class_name: "Following"
  # returns an array of follows a user gave to someone else
  has_many :given_follows, foreign_key: :follower_id, class_name: "Following"

  # Will return an array of users who follow the user instance
  has_many :followers, through: :received_follows, source: :follower
  # returns an array of other users who the user has followed
  has_many :followings, through: :given_follows, source: :followed_user

  attr_writer :login

  def login
    @login || self.name || self.email
  end

  def user_actions
    return (self.user_actions_to + self.user_actions_from).uniq
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      # when allowing distinct User records with, e.g., "username" and "UserName"...
      where(conditions).where(["name = :value OR lower(email) = lower(:value)", { :value => login }]).first
    elsif conditions.has_key?(:name) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
