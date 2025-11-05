require 'sinatra/base'
require 'slim'
require 'sass'
require 'webrick'
require_relative 'lib/movie_genre_list'

class RugbyApp < Sinatra::Base
  # Configuration
  set :public_folder, File.join(File.dirname(__FILE__), 'public')
  set :views, File.join(File.dirname(__FILE__), 'views')

  # Routes
  get '/' do
    @tags = ["Rugby", "Sports", "League", "Union", "World Cup", "Six Nations", "Super Rugby", "Premiership"]
    slim :index
  end

  # Start the server if this file is executed directly
  run! if __FILE__ == $0
end

server.mount_proc '/genres' do |req, res|
  begin
    genres_data = MovieGenreList.fetch_genres
    res['Content-Type'] = 'application/json'
    res.body = JSON.generate(genres_data)
  rescue StandardError => e
    res['Content-Type'] = 'application/json'
    res.status = 500
    res.body = JSON.generate({ error: e.message })
  end
end

server.mount_proc '/genres/view' do |req, res|
  res['Content-Type'] = 'text/html'
  res.body = <<~HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Movie Genres</title>
      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }
        
        body {
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          min-height: 100vh;
          padding: 40px 20px;
        }
        
        .container {
          max-width: 1200px;
          margin: 0 auto;
        }
        
        h1 {
          color: white;
          text-align: center;
          font-size: 3rem;
          margin-bottom: 40px;
          text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        .genres-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
          gap: 20px;
        }
        
        .genre-card {
          background: white;
          border-radius: 12px;
          padding: 24px;
          box-shadow: 0 4px 6px rgba(0,0,0,0.1);
          transition: transform 0.3s, box-shadow 0.3s;
          cursor: pointer;
        }
        
        .genre-card:hover {
          transform: translateY(-5px);
          box-shadow: 0 8px 12px rgba(0,0,0,0.2);
        }
        
        .genre-name {
          font-size: 1.25rem;
          font-weight: 600;
          color: #333;
          text-align: center;
        }
        
        .genre-id {
          font-size: 0.875rem;
          color: #666;
          text-align: center;
          margin-top: 8px;
        }
        
        .loading {
          text-align: center;
          color: white;
          font-size: 1.5rem;
          margin-top: 50px;
        }
        
        .error {
          background: #ff4444;
          color: white;
          padding: 20px;
          border-radius: 8px;
          text-align: center;
          margin: 20px auto;
          max-width: 600px;
        }
        
        .api-link {
          text-align: center;
          margin-top: 40px;
        }
        
        .api-link a {
          color: white;
          text-decoration: none;
          background: rgba(255,255,255,0.2);
          padding: 12px 24px;
          border-radius: 8px;
          display: inline-block;
          transition: background 0.3s;
        }
        
        .api-link a:hover {
          background: rgba(255,255,255,0.3);
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>🎬 Movie Genres</h1>
        <div id="genres-container" class="loading">Loading genres...</div>
        <div class="api-link">
          <a href="/genres" target="_blank">View Raw JSON API</a>
        </div>
      </div>
      
      <script>
        async function loadGenres() {
          const container = document.getElementById('genres-container');
          
          try {
            const response = await fetch('/genres');
            const data = await response.json();
            
            if (data.error) {
              container.innerHTML = '<div class="error">Error: ' + data.error + '</div>';
              return;
            }
            
            if (data.genres && data.genres.length > 0) {
              container.className = 'genres-grid';
              container.innerHTML = data.genres.map(genre => `
                <div class="genre-card">
                  <div class="genre-name">${genre.name}</div>
                  <div class="genre-id">ID: ${genre.id}</div>
                </div>
              `).join('');
            } else {
              container.innerHTML = '<div class="error">No genres found</div>';
            }
          } catch (error) {
            container.innerHTML = '<div class="error">Failed to load genres: ' + error.message + '</div>';
          }
        }
        
        loadGenres();
      </script>
    </body>
    </html>
  HTML
end

trap('INT') { server.shutdown }

server.start
