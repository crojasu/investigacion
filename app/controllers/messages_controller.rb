class MessagesController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @message = Message.new
  end

def create
    @message = Message.new(message_params)

if @message.valid?
  MessageMailer.contacto(@message).deliver_now
      redirect_to new_message_url, notice: "Gracias, tu mensaje fue enviado con Éxito!"
    else
      render :new, notice: "Ups , intenta nuevamente !"
    end
  end

private

def message_params
    params.require(:message).permit(:name, :email, :phone_number, :body, :nombre, :titulo, :rol)
  end
end
