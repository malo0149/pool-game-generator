Rails.application.routes.draw do
  get '/tournaments/games' => 'tournaments#games', defaults: { format: :json }
end
