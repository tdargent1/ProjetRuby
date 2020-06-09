class Post < ApplicationRecord
    validates_presence_of :title, :content
    validates :content, length: { minimum: 10}
    validates :status, inclusion: { in: [true, false] }

    has_many :comments, dependent: :delete_all
end