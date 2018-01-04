class UsersController < ApplicationController

  skip_before_action :only_signed_in, only: [:new, :new_provider, :create_provider, :create, :generate_username, :from_omniauth]
  skip_before_action :verify_authenticity_token

  helper SessionsHelper

  def new_provider
    @user = nil
    if !session[:provider] || !(session[:provider]['provider'] == 'github' || session[:provider]['provider'] == 'facebook' || session[:provider]['provider'] == 'twitch' || session[:provider]['provider'] == 'amazon' || session[:provider]['provider'] == 'marvin' || session[:provider]['provider'] == 'google_oauth2')
      redirect_to new_session_path, danger: 'Unknown provider'
    else
      @user = User.new(email: session[:provider]['email'])
    end
  end

  def create_provider
    if !session[:provider] || !(session[:provider]['provider'] == 'github' || session[:provider]['provider'] == 'facebook' || session[:provider]['provider'] == 'twitch' || session[:provider]['provider'] == 'amazon' || session[:provider]['provider'] == 'marvin' || session[:provider]['provider'] == 'google_oauth2')
      @code = "unknown_provider"
      render "sessions_controller/ominiauth"
    end
    uniq_pass = SecureRandom.hex(20)
    user_params = params.require(:user).permit(:firstname, :lastname)
    user_params[:email] = session[:provider]['email']
    user_params[:username] = SessionsHelper.generate_username(request.params['user'])
    user_params[:picture] = session['provider']['image'] + '?type=large'
    user_params[:provider] = session[:provider]['provider']
    user_params[:password] = uniq_pass
    user_params[:password_confirmation] = uniq_pass
    @user = User.new(user_params)
    @user.recover_password = nil
    if @user.valid?
      # @user.save
      @session = SessionsHelper.createSession(@user)
      unless @session
        @code = "error"
      else
        @code = @session.token
      end
      render "sessions/ominiauth"
    else
      render 'new_provider'
    end
  end

  def create
    user_params = params.permit(:username, :email, :firstname, :lastname, :password, :password_confirmation, :picture_file)

    @user = User.new(user_params)
    unless user_params[:picture_file]
      render json: {'status' => false, 'errors' =>  ['0': 'wrong image']}, :status=> 202
    else
      @user.recover_password = nil
        if @user.valid?
          @user.save
          UserMailer.confirm(@user).deliver_now
          render json: {'status' => true, 'message' => t('signup_ok')}, :status=> 201
        else
          render json: {'status' => false, 'errors' =>  @user.errors}, :status=> 202
        end
    end
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def picture
    @user = current_user_not_protected

    user_params = params.require(:picture_file)

    if @user.update_attribute(:picture_file, user_params)
      if @user.valid? (:picture_file)
        @user.save
        render json: {'status' => true, 'message' => t('user.picture.updated')}, :status=> 200
      else
        render json: {'status' => false, 'errors' =>  @user.errors}, :status=> 202
      end
    else
      render json: {'status' => false, 'message' => t('err')}, :status=> 400
    end
  end

  def data
    @user = current_user_not_protected

    user_params = params.require(:user).permit(:email, :lastname, :firstname)

    if @user.update(user_params)
      if @user.valid? :email
        @user.save
        render json: {'status' => true, 'message' => t('updt'), 'user' => current_user}, :status=> 200
      else
        render json: {'status' => false, 'message' => t('err'), 'errors' =>  @user.errors}, :status=> 202
      end
    else
      render json: {'status' => false, 'message' => t('err'), 'errors' =>  @user.errors, 'user' => current_user}, :status=> 202
    end
  end

  def language
    @user = current_user_not_protected
    if @user
      user_params = params.require(:user).permit(:language)
      if user_params[:language] == 'fr' || user_params[:language] == 'en'
        @user.update_attribute(:language, user_params[:language])
        @user.save
        render json: {'status' => false, 'message' => t('lang_saved')}, :status=> 200
      else
        render json: {'status' => false, 'message' => t('wrong_language')}, :status=> 400
      end
    else
      render json: {'status' => false, 'message' => t('user_nfound')}, :status=> 400
    end
  end

  def updatepassword
    @user = current_user_not_protected

    user_params = params.require(:user).permit(:password, :password_confirmation)
    user_password = params.require(:user).permit(:current_password)

    unless @user.try(:authenticate, user_password[:current_password])
      render json: {'status' => false, 'message' => t('err'), 'errors' =>  ['0': 'wrong password1']}, :status=> 202
    else
      if user_params['password'].length == 0 || user_params['password_confirmation'].length == 0
        render json: {'status' => false, 'message' => t('err'), 'errors' =>  ['0': 'wrong password2']}, :status=> 202
      else
        if @user.update(user_params)
          render json: {'status' => true, 'message' => t('updt')}, :status=> 200
        else
          render json: {'status' => false, 'message' => t('err'), 'errors' =>  @user.errors}, :status=> 202
        end
      end
    end
  end

end