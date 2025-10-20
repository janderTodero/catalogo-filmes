class Movie < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :synopsis, presence: true
  validates :release_year, presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 1888,
                            less_than_or_equal_to: Date.current.year + 5 }
  validates :duration, presence: true,
            numericality: { only_integer: true, greater_than: 0 }
  validates :director, presence: true

  default_scope { order(created_at: :desc) }
end
