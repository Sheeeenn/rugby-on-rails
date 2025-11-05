require 'net/http'
require 'json'
require 'dotenv/load'

module MovieGenreList
  def self.fetch_genres
    api_key = ENV['TMDB_key']
    raise 'TMDB_key not found in environment variables' if api_key.nil? || api_key.empty?

    url = "https://api.themoviedb.org/3/genre/movie/list?api_key=#{api_key}"
    uri = URI(url)

    begin
      response = Net::HTTP.get_response(uri)
      
      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)
      else
        { error: "API request failed with status #{response.code}" }
      end
    rescue StandardError => e
      { error: "Failed to fetch genres: #{e.message}" }
    end
  end
end
