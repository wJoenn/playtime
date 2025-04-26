class Game < ApplicationRecord
  validates :cover_url, :name, presence: true
  validates :appid, :name, uniqueness: true
end
