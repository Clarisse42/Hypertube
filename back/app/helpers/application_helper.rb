module ApplicationHelper
  class << self
    def getLanguage
      if I18n.locale.to_s == 'en'
        return 'en-US'
      else
        return 'fr-FR'
      end
    end

  end

end
