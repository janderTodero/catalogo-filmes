class Movie < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments, dependent: :destroy

  acts_as_taggable_on :tags
  has_one_attached :cover_image

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

  scope :by_category, ->(category_name) {
  joins(:categories).where("categories.name ILIKE ?", category_name) if category_name.present?
}

  scope :by_year, ->(year) {
    where(release_year: year) if year.present?
  }

  scope :by_director, ->(director_name) {
    where("director ILIKE ?", "%#{director_name}%") if director_name.present?
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[id title director release_year duration synopsis user_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[categories user]
  end
end
