module Steam
  class Client
    STEAM_URL = "https://api.steampowered.com/"

    class << self
      def cover_url(appid)
        "https://steamcdn-a.akamaihd.net/steam/apps/#{appid}/library_600x900_2x.jpg"
      end

      def owned_games
        data = get_steam("IPlayerService/GetOwnedGames/v1", include_appinfo: 1)
        data[:response][:games]
      end

      private

      def get_steam(endpoint, **params)
        Rails.application.credentials.steam => { key:, id: steamid }
        query = URI.encode_www_form(**params, key:, steamid:)
        response = HTTParty.get("#{STEAM_URL}#{endpoint}?#{query}")
        response.parsed_response.deep_symbolize_keys
      rescue NoMethodError => error
        raise error unless error.message == "undefined method 'deep_symbolize_keys' for an instance of String"

        message = error.message
        message += "\nResponse Status Code: #{response.code}"
        message += "\nResponse Parsed Body: #{response.parsed_response[0..499]}"

        raise NoMethodError, message
      end
    end
  end
end
