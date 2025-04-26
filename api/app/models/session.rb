class Session < ApplicationRecord
  belongs_to :game

  validates :duration, :played_at, presence: true
  validate :played_at_before_today, if: :played_at?

  private

  def played_at_before_today
    errors.add(:played_at, :too_recent) if played_at >= Time.zone.today
  end
end
