class SendResetEmail

  def initialize user:, client:
    @user = user
    @email_client = client
  end

  def call
    @email_client.send_message(email_contents)
  end

  private

  def email_contents
    {to:      @user.email,
    message: "You have requested a password reset. Follow this link to continue:
      http://www.bookmarkmanager.com/password_reset/#{@user.password_token}"}
  end

end
