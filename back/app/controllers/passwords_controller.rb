class PasswordsController < ApplicationController

  skip_before_action :only_signed_in
  skip_before_action :verify_authenticity_token

  def create

    user_params = params.require(:user)
    @user = User.where(email: user_params[:email], provider: nil).first

    if @user

      @user.update_attribute(:recover_password, SecureRandom.base58(100))
      UserMailer.password(@user).deliver_now
      render json: {'status' => true, 'message' => t('mail_sent')}, :status=> 200
    else
      render json: {'status' => false, 'message' => t('no_user')}, :status=> 202
    end
  end

  def update
    user_params = params.require(:user).permit(:password, :password_confirmation, :recover_password)

    @user = User.where(recover_password: user_params[:recover_password], provider: nil).first

    unless @user
      render json: {'status' => false, 'errors' =>  ['0': 'aucun utilisateur']}, :status=> 202
    else
      if (user_params['password_confirmation'] == user_params['password'])
        @user.assign_attributes(user_params)
        if @user.valid?
          @user.recover_password = nil
          @user.save
          render json: {'status' => true, 'message' => t('can_connect')}, :status=> 200
        else
          render json: {'status' => false, 'errors' =>  @user.errors}, :status=> 202
        end
      else
        render json: {'status' => false, 'errors' =>  ['0': 'password pas identique']}, :status=> 202
      end
    end
  end
end