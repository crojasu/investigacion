class MessageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.contacto.subject
  #
  def contacto(message)
    @body = message.body
    mg_client = Mailgun::Client.new ENV['mailgun_secret_api_key']
    message_params = {:from => message.email,
                      :to => "ucronia.investiga.actua@gmail.com",
                      :subject => 'Contacto',
                      :text => message.body}
    mg_client.send_message ENV['mailgun_domain'], message_params
  end
end
