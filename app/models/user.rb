class User < ActiveRecord::Base
  before_save {self.email = email.downcase }
  before_create :create_secret_key
  validates :first_name, presence: true
  validates :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
              uniqueness: { case_sensitive: false }

  def User.new_secret_key
    SecureRandom.urlsafe_base64
  end


  private

    def create_secret_key
      self.secret_key = User.new_secret_key
    end
end
