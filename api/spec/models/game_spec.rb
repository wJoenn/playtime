RSpec.describe Game do
  let(:appid) { 489830 }
  let(:cover_url) { "https://steamcdn-a.akamaihd.net/steam/apps/489830/library_600x900_2x.jpg" }
  let(:name) { "The Elder Scrolls V: Skyrim Special Edition" }

  describe "associations" do
    it "has many Session" do
      game = create(:game)
      expect(game.sessions).to all be_a Session
    end

    it "destroys sessions on destroyed" do
      game = create(:game)
      create(:session, game:)

      expect { game.destroy }.to change(Session, :count).by(-1)
    end
  end

  describe "validations" do
    it "creates a new game with proper params" do
      game = described_class.create(appid:, cover_url:, name:)
      expect(game).to be_persisted
    end

    it "validates the presence of the cover_url" do
      game = described_class.create(name:)

      expect(game).not_to be_persisted
      expect(game.error_codes).to eq({ cover_url: %i[blank] })
    end

    it "validates the presence of the name" do
      game = described_class.create(cover_url:)

      expect(game).not_to be_persisted
      expect(game.error_codes).to eq({ name: %i[blank] })
    end

    it "validates uniqueness of the appid" do
      described_class.create(appid:, cover_url:, name:)
      game = described_class.create(appid:, cover_url:, name: "Another name")

      expect(game).not_to be_persisted
      expect(game.error_codes).to eq({ appid: %i[taken] })
    end

    it "validates uniqueness of the name" do
      described_class.create(appid:, cover_url:, name:)
      game = described_class.create(appid: 1, cover_url:, name:)

      expect(game).not_to be_persisted
      expect(game.error_codes).to eq({ name: %i[taken] })
    end
  end
end
