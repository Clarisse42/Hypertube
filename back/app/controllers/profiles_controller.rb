class ProfilesController < ApplicationController

  helper_method :getMovies

  def view
    unless request.params
      render json: {'status' => false, 'message' => t('profile_nfound')}, :status=> 400
    end

    @getuser = User.find_by_username(request.params['username'])
    unless @getuser
      render json: {'status' => false, 'message' => t('profile_nfound')}, :status=> 400
    else
      @fav =  Users_favs.where(uid: @getuser['id']).order('created_at desc')
      @review = Review.where(uid: @getuser['id'])
      @viewedfilm = Users_view.where(uid: @getuser['id']).order('id desc')
      render json: {'status' => true, 'data' => @getuser, 'review' => @review, 'viewedfilm' => @viewedfilm, 'fav' => @fav}, :status=> 200
    end
  end
end

