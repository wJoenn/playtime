RSpec.describe Steam::SyncJob do
  let(:appid) { 1 }
  let(:name) { "Foo" }
  let(:games) { [{ appid:, name:, playtime_forever: 60, rtime_last_played: 2.days.ago.to_i }] }

  before do
    allow(Steam::Client).to receive_messages(owned_games: games)
  end

  describe "#perform" do
    it "creates new Game for missing steam games" do
      expect { described_class.perform_now }.to change(Game, :count).by 1

      game = Game.find_by({ appid: 1 })
      expect(game).to be_present
    end

    it "does not duplicate existing Game" do
      create(:game, appid:, name:)
      expect { described_class.perform_now }.not_to change(Game, :count)
    end

    it "creates new Session for Game with playtime_forever bigger than playtime" do
      expect { described_class.perform_now }.to change(Session, :count).by 1
      game = Game.find_by({ appid: 1 })
      expect(game.playtime).to be 1.hour.to_i
    end

    it "sets the the session activeness to whether the game was last played yesterday" do
      described_class.perform_now
      expect(Session.last).not_to be_active

      games = [{ appid:, name:, playtime_forever: 90, rtime_last_played: 1.day.ago.to_i }]
      allow(Steam::Client).to receive_messages(owned_games: games)
      described_class.perform_now

      expect(Session.last).to be_active
    end
  end
end
