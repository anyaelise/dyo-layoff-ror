class Admin < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :first_name, presence: true
  validates :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password

  def Admin.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Admin.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def process(ulist)
    # Save file to disk and store location in DB
    @uploaded_file = Rails.root.join(ulist.original_filename)
    File.open(@uploaded_file, 'wb') do |file|
      file.write(ulist.read)
    end
    self.update_attribute(:userlist, @uploaded_file.to_s)

    # Add users to database
    File.foreach(@uploaded_file) do |line|
      attrs = line.strip.split(",")
      user = { first_name: attrs[0], last_name: attrs[1], email: attrs[2] }
      User.create(user)
    end
  end

  def send_emails
    @users = User.all
    @users.each do |user|
      LayoffMailer.layoff_email(self, user).deliver
    end
  end
    

  private
    
    def create_remember_token
      self.remember_token = Admin.encrypt(Admin.new_remember_token)
    end
end
