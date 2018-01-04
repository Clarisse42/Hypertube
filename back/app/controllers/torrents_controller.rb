class TorrentsController < ApplicationController

  skip_before_action :only_signed_in
  skip_before_action :verify_authenticity_token

  def addTorrent
    token = params.require(:token)
    filesize = params.require(:filesize)
    path = params.require(:path)
    completed = params.require(:completed)

    torrent = Users_auth.where(token: token, stream: 1).first
    unless torrent
      render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
    else

      data = JSON.parse(torrent.torrent_data)

      @result = Torrent.find_or_create_by(torrent_id: data['torrent_id'])
      @result.update_attribute(:filesize, filesize)
      @result.update_attribute(:path, path)
      @result.update_attribute(:completed, completed)
      unless @result.datetime
        @result.update_attribute(:datetime, Time.now)
      end
      @result.save
      render json: {'status' => true, 'data' => data['torrent_id']}, :status=> 200
    end

  end

end