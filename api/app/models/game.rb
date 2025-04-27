class Game < ApplicationRecord
  has_many :sessions, dependent: :destroy

  validates :cover_url, :name, presence: true
  validates :appid, :name, uniqueness: true

  def playtime
    sessions.sum(:duration)
  end
end
