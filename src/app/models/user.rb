class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :films
  has_many :user_actions_from, class_name: "UserAction", foreign_key: "from_user_id"
  has_many :user_actions_to, class_name: "UserAction", foreign_key: "to_user_id"

  attr_writer :login

  def login
    @login || self.name || self.email
  end

  def user_actions
    return self.user_actions_to + self.user_actions_from
  end
end
