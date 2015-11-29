class UserMailer < ApplicationMailer
  default from: "admin@rottenmangoes.com"

  def delete_user(user)
    @user = user
    mail(to: @user.email, subject: 'Your account has been removed from our website.')
  end

end
