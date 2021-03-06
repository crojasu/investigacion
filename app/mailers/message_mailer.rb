class MessageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.contacto.subject
  #
  def contacto(message)
    @body = message.body
    @titulo = message.titulo
    @nombre = message.nombre
    @rol = message.rol

    mail to: "ucronia.investiga.actua@gmail.com", from: message.email
  end
end
