module SessionsHelper

  class << self

    def createSession(user)
      unless user
        return false
      end
      user.update_attribute(:last_connection, Time.zone.now)
      user.update_attribute(:language, I18n.locale)
      I18n.locale = user.language
      session = Users_log.new(uid: user.id, date: Time.now, token: SecureRandom.base58(250))
      session.save

      return session
    end

    def generate_username (data)
      return data['firstname'][0..10].downcase + data['lastname'].downcase[0..10] + '-' +rand(36**9).to_s(36) if data['firstname'] && data['lastname']
      return nil
    end

  end
end
