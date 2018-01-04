class FileValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)

    if value
      if value.respond_to? :path
        type =  MimeMagic.by_magic(File.open(value.path)).type
        unless type == 'image/png' || type == 'image/jpg' || type == 'image/jpeg'
          record.errors[attribute] << "extension error"
        end
        unless options[:ext].include? File.extname(value.path).delete('.').to_sym
          record.errors[attribute] << "extension error"
        end
      else
        record.errors[attribute] << "profile picture missing"
      end
    end
  end
end