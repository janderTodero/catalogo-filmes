class Comment < ApplicationRecord
  belongs_to :movie
  belongs_to :user, optional: true

  validates :content, presence: true
  validates :author_name, presence: true

  default_scope { order(created_at: :desc) }
end
