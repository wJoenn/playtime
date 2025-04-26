RSpec.describe Session do
  let(:duration) { 1.hour.to_i }
  let(:game) { create(:game) }
  let(:played_at) { Time.zone.yesterday }

  describe "associations" do
    it "belongs to a Game" do
      session = create(:session)
      expect(session.game).to be_a Game
    end
  end

  describe "validations" do
    it "creates a new session with proper params" do
      session = described_class.create(active: false, duration:, game:, played_at:)
      expect(session).to be_persisted
    end

    it "defaults active to true" do
      session = described_class.create(duration:, game:, played_at:)
      expect(session).to be_active
    end

    it "validates the presence of the duration" do
      session = described_class.create(game:, played_at:)

      expect(session).not_to be_persisted
      expect(session.error_codes).to eq({ duration: %i[blank] })
    end

    it "validates the presence of the game" do
      session = described_class.create(duration:, played_at:)

      expect(session).not_to be_persisted
      expect(session.error_codes).to eq({ game: %i[blank] })
    end

    it "validates the presence of the played_at" do
      session = described_class.create(duration:, game:)

      expect(session).not_to be_persisted
      expect(session.error_codes).to eq({ played_at: %i[blank] })
    end

    it "validates that played_at is before current day" do
      session = described_class.create(duration:, game:, played_at: Time.zone.today)

      expect(session).not_to be_persisted
      expect(session.error_codes).to eq({ played_at: %i[too_recent] })
    end
  end
end
