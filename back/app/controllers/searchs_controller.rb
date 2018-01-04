class SearchsController < ApplicationController

  helper SearchHelper, MoviesHelper, SubtitltesHelper
  skip_before_action :only_signed_in, only: [:torrent, :subtitle]
  skip_before_action :verify_authenticity_token

  def torrent
    unless params[:imdb_id]
      render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
    else
      result = SearchHelper.search(params[:imdb_id])
      unless result
        render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 204
      else
        render json: result
      end
    end
  end



  def playing
    unless params[:imdb_id] || params[:hash]
      render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
    else

      result = SearchHelper.search(params[:imdb_id])
      unless result
        render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
      else
        @movie = false
        result.each do |value|
          if params[:hash] == value['torrent_id']
            @movie = value
          end
        end

        unless @movie
          render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
        else
          data = MoviesHelper.startDownload(@movie, params[:imdb_id])
          unless data
            render json: [ 'status' => false, 'message' => 'Unable to stream'], :status=> 400
          else
            render json:data
          end
        end

      end

    end
  end


  def subtitle
    if !params[:imdb_id] || !params[:language]
      render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
    elsif params[:language] != 'fr' && params[:language] != 'en'
      render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
    elsif !subtitle = SubtitltesHelper.getLink(params[:imdb_id], params[:language])
      render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
    else

      SubtitltesHelper.startDownload(subtitle, params[:language], params[:imdb_id])

      if !File.exists?('/tmp/hypertube/subtitles/' + params[:language] + '/' + params[:imdb_id] + '.srt')
        render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
      else

        data = File.open('/tmp/hypertube/subtitles/' + params[:language] + '/' + params[:imdb_id] + '.srt', 'r').read
        File.open('/tmp/hypertube/subtitles/' + params[:language] + '/' + params[:imdb_id] + '.srt', "w+") do |f|
          f.write(data.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: ''))
        end

        begin
          WebVTT.convert_from_srt('/tmp/hypertube/subtitles/' + params[:language] + '/' + params[:imdb_id] + '.srt', '/tmp/hypertube/subtitles/' + params[:language] + '/' + params[:imdb_id] + '.vtt')

          File.delete('/tmp/hypertube/subtitles/' + params[:language] + '/' + params[:imdb_id] + '.zip') if File.exist?('/tmp/hypertube/subtitles/' + params[:language] + '/' + params[:imdb_id] + '.zip')

          render :file => '/tmp/hypertube/subtitles/' + params[:language] + '/' + params[:imdb_id] + '.vtt', :content_type => "text/vtt"
        rescue
          render json: [ 'status' => false], :status=> 204
        end
      end
    end
  end
end