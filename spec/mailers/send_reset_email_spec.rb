require './lib/send_reset_email'

describe SendResetEmail do

  let(:user) { double :user,
                password_token: '4nknkj34nkj23n4j32',
                email: "user@example.com" }
  let(:email_client) { double :email_client, post: :recovery_message }
  subject { SendResetEmail }

  it 'passes a recovery message to an email client' do
    SendResetEmail.client = email_client
    expect(subject.call(user)).to eq :recovery_message
  end
end
