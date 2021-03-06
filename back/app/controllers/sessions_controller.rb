class SessionsController < ApplicationController

  skip_before_action :only_signed_in
  skip_before_action :verify_authenticity_token

  helper SessionsHelper


  def create
    user_params = params.require(:user)

    @user = User.where(username: user_params[:username], provider: nil).first

    if @user and @user.authenticate(user_params[:password])
     @session = SessionsHelper.createSession(@user)
     render json: {'status' => true, 'token' => @session.token, 'user' => User.select(:username, :email, :firstname, :lastname, :picture, :provider).find_by(id: @session.uid)}, :status=> 200
    else
      render json: {'status' => false, 'message' => t('usr_pwd_err:')}, :status=> 400
    end
  end

  def check
    if @user = current_user()
      render json: {'status' => true, 'user' => @user}
    else
      render json: {'status' => false, 'message' => t('ntoken')}
    end
  end

  def remove
    user_log = Users_log.where(uid: current_user_not_protected['id'], token: request.headers['Authorization']).first
    unless user_log
      render json: {'status' => true, 'message' => t('token_nfound')}
    else
      user_log.update_attribute(:status, false)
      user_log.save
      render json: {'status' => true, 'message' => t('logout')}
    end
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def omniauth
    if auth_hash && auth_hash['info']['email'] && auth_hash['provider']
      @user = User.where(email: auth_hash['info']['email'], provider: auth_hash['provider']).first
      if !@user
        auth_hash['info']['provider'] = auth_hash['provider']
        unless auth_hash['info']['image']
          auth_hash['info']['image'] = 'https://dcassetcdn.com/common/images/v3/no-profile-pic-tiny.png'
        end
        session[:provider] = auth_hash['info']
        redirect_to '/api/users/new/' + auth_hash.provider
      else
        @session = SessionsHelper.createSession(@user)
        unless @session
          @code = "error"
        else
          @code = @session.token
        end
        render "ominiauth"
      end
    else
      @code = "invalid_email"
      render "ominiauth"
    end
  end

  def marvin
    client = OAuth2::Client.new('aa698d1c7b888c2445f5ce20874049e095c4e0a47dfbe9125d3fc3e9debf611b', '35fb88f50dd5f08de82e0bd2298d40324d7e0ac36a6c69f045f9deba85d98683', :site => 'https://api.intra.42.fr/oauth/authorize')
    redirect_to client.auth_code.authorize_url(:redirect_uri => 'http://localhost:8999/auth/marvin/r_callback')
  end

  def r_marvin
    client = OAuth2::Client.new('aa698d1c7b888c2445f5ce20874049e095c4e0a47dfbe9125d3fc3e9debf611b', '35fb88f50dd5f08de82e0bd2298d40324d7e0ac36a6c69f045f9deba85d98683', :site => 'https://api.intra.42.fr/oauth/token')

    begin
      token = client.auth_code.get_token(params[:code], :redirect_uri => 'http://localhost:8999/auth/marvin/r_callback')

      response = token.get('/v2/me')
      if response.status == 200
        auth_hash = Hash.new()
        auth_hash['email'] = response.parsed['email']
        auth_hash['firstname'] = response.parsed['first_name']
        auth_hash['lastname'] = response.parsed['last_name']
        auth_hash['image'] = response.parsed['image_url']
        auth_hash['provider'] = 'marvin'


        @user = User.where(email: auth_hash['email'], provider: auth_hash['provider']).first
        if !@user
          session[:provider] = auth_hash
          redirect_to '/api/users/new/' + auth_hash['provider']
        else
          @session = SessionsHelper.createSession(@user)
          unless @session
            @code = "error"
          else
            @code = @session.token
          end
          render "ominiauth"
        end
      else
        @code = 'error'
        render "ominiauth"
      end
    rescue
      @code = "invalid_email"
      render "ominiauth"
    end
  end

  def auth_failure
    @code = request.env['omniauth.error.type']
    render "ominiauth"
  end
end
