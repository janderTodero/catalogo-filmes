class Import < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  enum :status, { pending: 0, processing: 1, done: 2, failed: 3 }
end
