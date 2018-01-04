class User < ApplicationRecord

  attr_accessor :picture_file
  has_secure_password
  has_secure_token :recover_password
  validates_strength_of :password_confirmation, if: ->(patient){patient.password_confirmation.present?}

  after_save :picture_after_upload
  before_save :picture_before_upload

  validates :username, format: {with: /\A[a-zA-Z0-9_-]{2,35}\z/, message: "Invalid username"}, uniqueness: {case_sensitive: false}
  validates :lastname, presence: true
  validates :firstname, presence: true
  validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Invalid email"}, uniqueness: {case_sensitive: false}
  validates :picture_file, file: {ext: [:jpg, :png, :jpeg]}

  def to_session
    {id: id}
  end

  def picture_before_upload
    if picture_file.respond_to? :path
      self.picture = File.join(
          'http://localhost:8999/api/Users/',
          username,
          'image.png'
      )
    end
  end

  def picture_after_upload
    path = File.join(
        Rails.public_path,
        self.class.name.pluralize,
        username,
        'image.png'
    )

    if picture_file.respond_to? :path
      dir = File.dirname(path)
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      FileUtils.cp(picture_file.path, path)
    end
  end
end
