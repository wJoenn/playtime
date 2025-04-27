RSpec.describe Steam::Client do
  let(:games) { [{ appid: 1 }, { appid: 2 }] }

  describe "::cover_url" do
    it "generates a cover_url from a appid" do
      cover_url = described_class.cover_url(1)
      expect(cover_url).to eq "https://steamcdn-a.akamaihd.net/steam/apps/1/library_600x900_2x.jpg"
    end
  end

  describe "::owned_games" do
    before do
      stub_request(:get, /GetOwnedGames/).to_return(
        body: { response: { games_count: 0, games: } }.to_json,
        headers: { content_type: "application/json" }
      )
    end

    it "makes a GET request to Steam's API" do
      allow(HTTParty).to receive(:get).and_call_original
      described_class.owned_games

      url = "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1"
      key, steamid = Rails.application.credentials.steam.values_at(:key, :id)
      expect(HTTParty).to have_received(:get).with("#{url}?include_appinfo=1&key=#{key}&steamid=#{steamid}")
    end

    it "returns an array of owned steam games" do
      owned_games = described_class.owned_games
      expect(owned_games).to eq games
    end
  end
end
