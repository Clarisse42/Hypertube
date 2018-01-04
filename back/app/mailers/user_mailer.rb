class UserMailer < ActionMailer::Base
  default :from => 'contact@antoinevideau.pro'

def confirm(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to Hypertube / Bienvenue sur Hypertube')
  end

  def password(user)
    @user = user
    mail(to: user.email, subject: 'Your new password / Votre nouveau mot de passe')
  end
end
