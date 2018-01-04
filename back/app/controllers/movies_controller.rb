class MoviesController < ApplicationController

  helper ApplicationHelper, MoviesHelper, SubtitltesHelper
  skip_before_action :only_signed_in, only: [:allMovies, :Category, :Name, :Getid, :torrent, :torrentStream]
  skip_before_action :verify_authenticity_token

  def allMovies
    if params[:type] == 'news' || params[:type] == 'top_rated'
      response = HTTParty.get(MoviesHelper.request(params[:type], '0'))
      unless response.code == 200
        render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
      else
        content = MoviesHelper.parse_yts(JSON.parse(response.body), current_user)
        if content.empty?
          render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
        else
          render json: content
        end
      end
    elsif params[:type] == 'resume' || params[:type] == 'favs'
      data = MoviesHelper.parse_resume(current_user, params[:type])
      if !current_user
        render json: [ 'status' => false], :status=> 401
      elsif !data
        render json: [ 'status' => false, 'message' => t('empty')], :status=> 204
      else
        render json: data
      end
    else
      render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
    end
  end

  def Category
    if !params[:type] == 'news' && !params[:type] == 'top_rated'
      render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
    else
      response = HTTParty.get(MoviesHelper.request(params[:type], params[:page]))
      unless response.code == 200
        render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
      else
        content = MoviesHelper.parse_yts(JSON.parse(response.body), current_user)
        if content.empty?
          render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
        else
          render json: content
        end
      end
    end
  end

  def Name
    if !params[:name]
      render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
    else
      if params[:year] != '0'
        response = HTTParty.get("https://api.themoviedb.org/3/search/movie?api_key=" + ENV['apikey_moviedb'] + "&language=" + ApplicationHelper.getLanguage + "&query=" + params[:name] + "&page=1&append_to_response=images&year=" + params[:year])
      else
        response = HTTParty.get("https://api.themoviedb.org/3/search/movie?api_key=" + ENV['apikey_moviedb'] + "&language=" + ApplicationHelper.getLanguage + "&query=" + params[:name] + "&page=1&append_to_response=images")
      end
      unless response.code == 200
        render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
      else
        content = MoviesHelper.parse_search(JSON.parse(response.body), params[:rating], params[:type], params[:year])
        if content.empty?
          render json: [ 'status' => false, 'message' => 'no result'], :status=> 204
        else
          render json: content
        end
      end
    end
  end

  def Getid
    if !params[:id]
      render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
    else
      response = HTTParty.get("https://api.themoviedb.org/3/movie/" + params[:id] + "?api_key=" + ENV['apikey_moviedb'] + "&language=" + ApplicationHelper.getLanguage)
      # https://api.themoviedb.org/3/movie/75097?api_key=9a3edbda5c6e7ffe44beb16655025820&language=en-US
      unless response.code == 200
        render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
      else
        content = MoviesHelper.parse_id(JSON.parse(response.body))

        if content.empty?
          render json: [ 'status' => false, 'message' => 'no result'], :status=> 204
        else
        render json: content
        end
      end
    end

  end

  def Movie
    unless params[:id]
      render json: ['status' => false, 'message' => t('bad_req')], :status=> 400
    else
      content =  MoviesHelper.findMovie(params[:id])
      unless content
        render json: ['status' => false, 'message' => t('bad_req')]
      else
        response = HTTParty.get("https://api.themoviedb.org/3/movie/" + content['id'].to_s + "?append_to_response=videos,credits&api_key=" + ENV['apikey_moviedb'] + "&language=" + ApplicationHelper.getLanguage + "&page=1")
        unless response.code == 200
          render json: { 'status' => false, 'message' => t('bad_req')}
        else
          @user = current_user
          result = JSON.parse(response.body)
          result['users_com'] = {}
          result['comment'] = Review.where(movie_id: params[:id]).order('id desc')
          if result['comment']
            result['comment'].each do |elem|
              # result['users_com'][elem.uid] = User.select(:username, :picture, :provider).where(id: elem.uid)
              result['users_com'][elem.uid.to_s] = User.select(:username, :picture, :provider).where(id: elem.uid)
            end
          end
          result['subtitles'] = SubtitltesHelper.searchSubtitle(params[:id])
          result['fav'] = Users_favs.where(movie_id: params[:id]).where(uid: @user[:id]).length
          render json: result
        end
      end

    end
  end


  def new_fav
    @user = current_user
    @fav = Users_favs.create(uid: @user[:id], movie_id: params[:fav][:movie_id])

    if @fav.valid?
      render json: {'status' => true, 'message' => t('fav_add')}, :status=> 201
    else
      render json: {'status' => false, 'message' => t('fav_ald')}, :status=> 204
    end
  end

  def delete_fav
    @user = current_user
    @favd = Users_favs.find_by(uid: @user[:id], movie_id: params[:fav][:movie_id])
    @favd.destroy

    if @favd.valid?
      render json: {'status' => true, 'message' => t('fav_delete')}, :status=> 201
    else
      render json: {'status' => false, 'message' => t('fav_ald')}, :status=> 204
    end

  end

  def viewedFilm
    @user = current_user
    request_params = params.require(:view).permit(:movie_id, :time, :torrent_id)

    @view = Users_view.where(uid: @user.id, torrent_id: request_params[:torrent_id], movie_id: request_params[:movie_id]).first
    unless @view
      Users_view.new(uid: @user.id, torrent_id: request_params[:torrent_id], movie_id: request_params[:movie_id], time_elapsed: request_params[:time], datetime: Time.now).save
    else
      @view.update_attribute(:time_elapsed, request_params[:time])
    end

    render json: {'status' => true}, :status=> 200
  end



  def torrent
    request_params = params.require(:token)

    torrent = Users_auth.where(token: request_params, download: 1).first
    unless torrent
      render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
    else
      # torrent.update_attribute(:active, 0)
      hash = ActiveSupport::JSON.decode(torrent.torrent_data)
      render json: {'status' => true, 'data' => hash}, :status=> 200
    end

  end

  def torrentStream
    request_params = params.require(:token)

    torrent = Users_auth.where(token: request_params, stream: 1).first
    unless torrent
      render json: [ 'status' => false, 'message' => t('bad_req')], :status=> 400
    else
      # torrent.update_attribute(:active, 0)
      hash = ActiveSupport::JSON.decode(torrent.torrent_data)
      @file = Torrent.where(torrent_id: hash['torrent_id']).first
      render json: {'status' => true, 'data' => hash, 'file' => @file}, :status=> 200
    end

  end

end