class LayoffMailer < ActionMailer::Base
  default from: "aem405@yahoo.com"

  def layoff_email(admin, user)
    @admin = admin
    @user = user
    mail(to: @user.email, from: @admin.email, subject: 'Fire Your Coworkers!')
  end
end
