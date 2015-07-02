require 'mailgun'

class SendResetEmail

  CLIENT = RestClient

  def self.call user
    CLIENT.post "https://api:#{ENV['mailgun_api']}"\
    "@api.mailgun.net/v3/sandbox8a194822b88f467e809f01cbd74859f3.mailgun.org/messages", email_contents(user)
  end

  private

  def self.email_contents user
    {from:   "Mailgun Sandbox <postmaster@sandbox8a194822b88f467e809f01cbd74859f3.mailgun.org>",
    to:      user.email,
    subject: "Bookmark Manager password reset",
    text:    "You have requested a password reset. Follow this link to continue:
      http://www.bookmarkmanager.com/password_reset/#{user.password_token}"}
  end

end

# email_client = Mailgun::Client.new ENV["mailgun_api"]
# email_client.send_message "@api.mailgun.net/v3/sandbox8a194822b88f467e809f01cbd74859f3.mailgun.org/messages", email_contents
