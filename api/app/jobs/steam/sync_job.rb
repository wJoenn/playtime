module Steam
  class SyncJob < ApplicationJob
    def perform
      Steam::Client.owned_games.each do |steam_game|
        steam_game => { appid:, name:, playtime_forever:, rtime_last_played: }
        game = Game.find_by(appid:) || Game.create!(appid:, cover_url: Steam::Client.cover_url(appid), name:)

        duration = (playtime_forever * 60) - game.playtime
        if duration.positive?
          played_at = [Time.zone.at(rtime_last_played).to_date, Time.zone.yesterday].min
          Session.create!(active: played_at == Time.zone.yesterday, duration:, game:, played_at:)
        end
      end
    end
  end
end
