require './lib/send_reset_email'

describe SendResetEmail do

  let(:user)         { double :user, password_token: '4nknkj34nkj23n4j32', email:
                 "user@example.com" }
  let(:email_client) { double :email_client, post: :sausage }
  subject { SendResetEmail }

  it 'passes a recovery message to an email client' do
    SendResetEmail::CLIENT = email_client
    expect(subject.call(user)).to eq :sausage
  end
end
