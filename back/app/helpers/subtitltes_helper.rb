module SubtitltesHelper

  class << self

    def parse(data)
      data.each do |value|
      end
    end

    def xmlSearch(imdb)
      server = XMLRPC::Client.new2("http://api.opensubtitles.org/xml-rpc")
      if server
        unless result = server.call("LogIn", "hypertube422017", "geguno", "eng", "TemporaryUserAgent")
          return false
        end
        resultfilm = Hash.new()
        resultfilm['en'] = server.call("SearchSubtitles", result['token'], ['imdbid' => imdb, 'sublanguageid' => 'eng'], 'limit' => 1)
        resultfilm['fr'] = server.call("SearchSubtitles", result['token'], ['imdbid' => imdb, 'sublanguageid' => 'fre'], 'limit' => 1)

        return resultfilm
      else
        return false
      end
    end

    def searchSubtitle(imdb)
      imdb = imdb[2, 10]
      result = xmlSearch(imdb)

      unless result
        return false
      end

      lang = Array.new

      # //result['en']['data'][0]['ZipDownloadLink']
      if result['en'] && result['en']['data'] && !result['en']['data'].empty?
        if startDownload(result['en']['data'][0]['ZipDownloadLink'], 'en', 'tt' + imdb)
         lang << {lang: 'en', 'url': '/api/rest/movie/subtitle/tt' + imdb + '/en', language: 'English'}
        end

      end

      if result['fr'] && result['fr']['data'] && !result['fr']['data'].empty?
        if startDownload(result['fr']['data'][0]['ZipDownloadLink'], 'fr', 'tt' + imdb)
         lang << {lang: 'fr', 'url': '/api/rest/movie/subtitle/tt' + imdb + '/fr',  language: 'Français'}
        end
      end

      return lang
    end

    def getLink(imdb, language)
      imdb = imdb[2, 10]
      result = xmlSearch(imdb)

      unless result
        return false
      end

      lang = false

      if language == 'en' && result['en'] && result['en']['data'] && !result['en']['data'].empty?
        lang = result['en']['data'][0]['ZipDownloadLink']
      end

      if language == 'fr' && result['fr'] && result['fr']['data'] && !result['fr']['data'].empty?
        lang = result['fr']['data'][0]['ZipDownloadLink']
      end

      return lang
    end


    def startDownload(url, language, imdb)

      if url
        download = open(url)
      end

      Dir.mkdir("/tmp/hypertube/") unless File.exists?("/tmp/hypertube/")
      Dir.mkdir("/tmp/hypertube/subtitles/") unless File.exists?("/tmp/hypertube/subtitles/")
      Dir.mkdir("/tmp/hypertube/subtitles/fr") unless File.exists?("/tmp/hypertube/subtitles/fr")
      Dir.mkdir("/tmp/hypertube/subtitles/en") unless File.exists?("/tmp/hypertube/subtitles/en")

      if url && download && !File.exist?('/tmp/hypertube/subtitles/' + language + '/' + imdb + '.zip')
        IO.copy_stream(download, '/tmp/hypertube/subtitles/' + language + '/' + imdb + '.zip')
        Zip::File.open('/tmp/hypertube/subtitles/' + language + '/' + imdb + '.zip')do |zipfile|
          zipfile.each do |file|
            if File.extname(file.to_s) == '.srt'
              zipfile.extract(file, '/tmp/hypertube/subtitles/' + language + '/' + imdb + '.srt') unless File.exists?('/tmp/hypertube/subtitles/' + language + '/' + imdb + '.srt')
            end
          end
        end
      end

      if File.exists?('/tmp/hypertube/subtitles/' + language + '/' + imdb + '.srt')
        return true
      else
        return false
      end

    end
  end
end
