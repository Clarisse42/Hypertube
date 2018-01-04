module SearchHelper

  class << self

    def search(imdb_id)
      unless imdb_id
        return false
      end

      response = HTTParty.get(ENV['yts_url'] + '?query_term=' + imdb_id + '&limit=5&sort_by=seeds')
      response_popcorntime = HTTParty.get('https://tv-v2.api-fetch.website/movie/' + imdb_id)
      if response.code != 200 && response_popcorntime != 200
        return false
      end


      if !response.body.empty?
        s1 = parse_yts(JSON.parse(response.body))
      end

      if !response_popcorntime.body.empty?
        s2 = parse_popcorntime(JSON.parse(response_popcorntime.body))
      end



      if s1 && s2
        return s1.concat s2
      elsif s1 && !s2
        return s1
      elsif !s1 && s2
        return s2
      else
        return false
      end
    end


    private

    def parse_popcorntime(data)
      if !data || data['torrents'].empty?
        return false
      end

      new_array = []
      data['torrents'].each do |key, value|
        if key == 'en' || key == 'fr'
          value.each do |ktorent, torrent|
            arr = Hash.new(5)
            arr['torrent_id'] = parse_magnet(torrent['url'])
            arr['quality'] = ktorent
            arr['seeds'] = torrent['seed']
            arr['timestamp'] = Time.at(data['released'])
            arr['source'] = 'popcorntime'
            arr['magnet'] = torrent['url']
            arr['language'] = (key == 'en') ? 'English' : 'French'
            if torrent['seed'] > 5 && ktorent != '3D'
              new_array << arr
            end
          end
        end
      end

      return new_array

    end

    def parse_magnet(magnet)
      url = Rack::Utils.parse_nested_query(magnet).first[1]
      url = url[9..-1]
      return url
    end

    def parse_yts(data)
      unless data['status'] == "ok"
        return false
      end
      if !data['data'] || data['data']['movie_count'] <= 0
        return false
      end

      new_array = []

      data['data']['movies'].each do |value|
        if value['state'] == 'ok'
          value['torrents'].each do |torrent|
            arr = Hash.new(5)
            arr['torrent_id'] = torrent['hash']
            arr['quality'] = torrent['quality']
            arr['seeds'] = torrent['seeds']
            arr['timestamp'] = torrent['date_uploaded']
            arr['source'] = 'yts'
            arr['language'] = value['language']
            if torrent['seeds'] > 5 && torrent['quality'] != '3D'
              new_array << arr
            end
          end
        end
      end

      return new_array
    end



  end

end
