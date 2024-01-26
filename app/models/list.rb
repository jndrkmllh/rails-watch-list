class List < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :movies, through: :bookmarks
  has_one_attached :photo

  validates :name, presence: true, uniqueness: true
  regex_for_url = /(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z0-9]{2,}(\.[a-zA-Z0-9]{2,})(\.[a-zA-Z0-9]{2,})?/
  validates :image_url, format: { with: regex_for_url }, if: :is_filled?

  def is_filled?
    self.image_url.present? # self.image_url is the value entered in the field
    # method returns true, if something is entered in the field
    # raise
  end
end
