class RemoveTorrentJob < ApplicationJob

  def perform
    val = Users_view.group(:torrent_id).maximum(:datetime)

    if val
      val.each do |p|

        if p[1] != nil
          if Time.parse(p[1].to_s).to_i < (Time.now.to_i - 30.days)
            @search_movie = Torrent.where(torrent_id: p[0]).first
            puts p[0] + " has deleted"
            File.delete('/tmp/hypertube/movies/' + p[0] + '.webm') if File.exist?('/tmp/hypertube/movies/' + p[0] + '.webm')
            if @search_movie
              File.delete('/tmp/hypertube/torrent-stream/' + @search_movie['path']) if File.exist?('/tmp/hypertube/torrent-stream/' + @search_movie['path'])
            end
            Torrent.where(torrent_id: p[0]).delete_all
          end
        end

      end
    end
  end
end
