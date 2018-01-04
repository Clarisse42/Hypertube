Rails.application.routes.draw do


  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/auth/marvin/request', to: 'sessions#marvin'
  get '/auth/marvin/r_callback', to: 'sessions#r_marvin'
  get '/users/new/:provider', to: 'users#new_provider'
  post '/users/new/:provider', to: 'users#create_provider'

  get '/rest/profile/:username', to: 'profiles#view'


  get '/rest/movies/:type', to: 'movies#allMovies'
  get '/rest/movies/:type/:page', to: 'movies#Category'
  get '/rest/movie/imdb/:id', to: 'movies#Movie'
  get '/rest/movie/torrent/:imdb_id', to: 'searchs#torrent'
  get '/rest/movie/torrent/:imdb_id/playing/:hash', to: 'searchs#playing'
  get '/rest/movie/subtitle/:imdb_id/:language', to: 'searchs#subtitle'
  get '/rest/movie_name/:name/:year/:type/:rating', to: 'movies#Name'
  get '/rest/movie_id/:id', to: 'movies#Getid'
  post '/rest/movies/viewed', to: 'movies#viewedFilm'

  post '/rest/users/create', to: 'users#create'
  post '/rest/sessions', to: 'sessions#create'
  post '/rest/sessions/reset', to: 'passwords#create'
  put '/rest/sessions/reset', to: 'passwords#update'
  get '/rest/sessions', to: 'sessions#check'
  get '/rest/sessions/remove', to: 'sessions#remove'

  put '/rest/users/picture', to: 'users#picture'
  put '/rest/users/language', to: 'users#language'
  put '/rest/users/data', to: 'users#data'
  put '/rest/users/password', to: 'users#updatepassword'

  post '/rest/review/create', to: 'pages#new_review'
  post '/rest/fav/create', to: 'movies#new_fav'
  post '/rest/fav/delete', to: 'movies#delete_fav'


  post '/torrent/data', to: 'torrents#addTorrent'


  get '/torrent/auth/download/:token', to: 'movies#torrent'
  get '/torrent/auth/stream/:token', to: 'movies#torrentStream'

end
