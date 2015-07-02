require './lib/send_reset_email'

describe SendResetEmail do

  let(:user)         { double :user, password_token: '4nknkj34nkj23n4j32', email:
                 "user@example.com" }
  let(:email_client) { double :email_client }
  subject { SendResetEmail.new(user: user, client: email_client) }

  it 'passes a recovery message to an email client' do
    expect(email_client).to receive(:send_message).with(
      to:      user.email,
      message: "You have requested a password reset. Follow this link to continue:
      http://www.bookmarkmanager.com/password_reset/#{user.password_token}"
    ) # of course we are referencing a domain here that doesn't exist... but we
      # would have something like this in our production environment.

    subject.call
  end
end
