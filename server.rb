require 'sinatra/base'
require 'slim'
require 'sass'

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
