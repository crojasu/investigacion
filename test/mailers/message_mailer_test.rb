require 'test_helper'

class MessageMailerTest < ActionMailer::TestCase
  test "contacto" do
    message = Message.new name: 'anna',
                          email: 'anna@example.org',
                          body: 'hello, how are you doing?'

    email = MessageMailer.contacto(message)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal 'Contacto', email.subject
    assert_equal ['rojas.catalina@gmail.com'], email.to
    assert_equal ['anna@example.org'], email.from
    assert_match /hello, how are you doing?/, email.body.encoded
  end
end
