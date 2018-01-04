module MoviesHelper

  class << self

    def parse_yts(data, current_user = false)
      unless data['status'] == "ok"
        return false
      end
      if !data['data'] || data['data']['movie_count'] <= 0
        return false
      end

      new_array = []

      data['data']['movies'].each do |value|
        if value['state'] == "ok"
          arr = Hash.new(6)
          arr['imdb_id'] = value['imdb_code']
          arr['title'] = value['title']
          arr['cover'] = value['large_cover_image']
          arr['rating'] = value['rating']
          arr['runtime'] = value['runtime']
          arr['year'] = value['year']
          if current_user
            view = Users_view.where(movie_id: value['imdb_code'], uid: current_user.id).order('time_elapsed desc').first
            if view
              if view['time_elapsed'] == 0
                arr['userviewed?'] = 1
              else
                arr['userviewed?'] = view['time_elapsed']
              end
            else
              arr['userviewed?'] = 0
            end
          else
            arr['userviewed?'] = 0
          end

          new_array << arr
        end
      end

      return new_array
    end

    def parse_search(data, rating, type, year)
      unless data['total_pages'] > 0
        return false
      end

      new_array = []
      data['results'].each do |value|
        if (year == '0' || value['release_date'].split('-')[0] == year) && value['vote_average'].to_i >= rating.to_i && ((value['genre_ids'].index type.to_i) || type.to_i == 0) && value['release_date']!= ''
          arr = Hash.new(6)
          arr['id'] = value['id']
          arr['title'] = value['title']
          if value['poster_path']
            arr['poster'] = value['poster_path']
          else
            arr['poster'] = ''
          end
          arr['rating'] = value['vote_average']
          arr['release_date'] = value['release_date']
          new_array << arr
        end
      end
      return new_array
    end

    def parse_id(data)
      new_array = []
      arr = Hash.new(2)
      arr['id'] = data['imdb_id']
      new_array << arr
      return new_array
    end

    def request(type, page)
      if type == "news"
        return "https://yts.ag/api/v2/list_movies.json?limit=30&page=" + page
      elsif type == "top_rated"
        return "https://yts.ag/api/v2/list_movies.json?limit=30&minimum_rating=8&page=" + page
      end
    end


    def findMovie(imdb_code)
      response = HTTParty.get("https://api.themoviedb.org/3/find/" + imdb_code + "?api_key=" + ENV['apikey_moviedb'] + "&append_to_response=videos&external_source=imdb_id&language=" + ApplicationHelper.getLanguage)

      unless response.code == 200
        return false
      else
        data = JSON.parse(response.body)['movie_results'][0]
        if !data || data.empty?
          return false
        else
          return data
        end
      end
    end

    def parse_resume(current_user, cat)
      unless current_user
        return false
      else

        if cat == 'resume'
          @userview = Users_view.where(uid: current_user.id).group(:movie_id).limit(15)
        else
          @userview = Users_favs.where(uid: current_user.id).group(:movie_id).limit(30)
        end

        new_array = []
        @userview.each do |value|
          result = findMovie(value['movie_id'])

          arr = Hash.new(6)
          arr['imdb_id'] = value['movie_id']

          arr['title'] = result['title']
          arr['cover'] = ENV['moviedb_image_endpoint'] + result['poster_path']
          arr['rating'] = result['vote_average']
          arr['runtime'] = 0
          arr['year'] = result['release_date'];
          new_array << arr
        end
        return new_array
      end
    end

    def startDownload(movie, imdb_code)
      response = Hash.new()

      Dir.mkdir("/tmp/hypertube/") unless File.exists?("/tmp/hypertube/")
      Dir.mkdir("/tmp/hypertube/torrents") unless File.exists?("/tmp/hypertube/torrents")
      Dir.mkdir("/tmp/hypertube/movies") unless File.exists?("/tmp/hypertube/movies")


      if (movie['source'] == 'yts' || movie['source'] == 'popcorntime') && !movie['magnet']
        download = open('https://yts.am/torrent/download/' + movie['torrent_id'])
        IO.copy_stream(download, '/tmp/hypertube/torrents/' + movie['torrent_id'] + '.torrent')
      end

      token = SecureRandom.base58(100)
      Users_auth.new(token: token, torrent_data: ActiveSupport::JSON.encode(movie), stream: true, download: true).save

      response['streamUrl'] = 'http://localhost:8080/stream/' + token
      response['downloadUrl'] = 'http://localhost:8080/download/' + token

      begin
        response['subtitles'] = SubtitltesHelper.searchSubtitle(imdb_code)
        return response
      rescue
        return false
      end
    end

  end

end
