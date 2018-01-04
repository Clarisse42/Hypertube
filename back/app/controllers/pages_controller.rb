class PagesController < ApplicationController

  skip_before_action :only_signed_in
  skip_before_action :verify_authenticity_token

  def new_review
    @user = current_user
    review_params = params.require(:review).permit(:message)
    review_params[:movie_id] = params[:review][:movie_id]
    review_params[:uid] = @user[:id]
    @review = Review.new(review_params)

    if @review.valid?
      @review.save
      @getreview = Review.where(movie_id: params[:review][:movie_id]).order('id desc')
      @getuser = User.select(:username, :picture, :provider).where(id: @user.id)
      render json: {'status' => true, 'message' => t('comment_added'), 'data' => @getreview, 'user' => @getuser}, :status=> 201
    else
      render json: {'status' => false, 'message' => t('content_missing')}, :status=> 202
    end

  end

end
