  class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :success, :danger, :privateparams

  before_action :set_locale, :only_signed_in

  helper_method :current_user, :category

  def set_locale
    if request.headers['Language'] == "en" || request.headers['Language'] == "fr"
      I18n.locale = request.headers['Language'] || I18n.default_locale
    else
      I18n.default_locale
    end
  end

  private

  def current_user
    unless request.headers['Authorization']
      @user = false
    else
      if user_log = Users_log.find_by(token: request.headers['Authorization'], status: true)
        @user = User.select(:id, :username, :email, :firstname, :lastname, :picture, :provider, :language).find_by(id: user_log['uid'])
      else
        @user = false
      end
    end
  end

  def current_user_not_protected
    unless request.headers['Authorization']
      @user = false
    else
      if user_log = Users_log.find_by(token: request.headers['Authorization'], status: true)
        @user = User.find_by(id: user_log['uid'])
      else
        @user = false
      end
    end
  end

  protected

  def only_signed_in
    user_log = Users_log.find_by(token: request.headers['Authorization'], status: true)
    unless user_log
      render json: {'status' => false, 'message' => t('token_denied')}, :status=> 401
    end
  end
end
