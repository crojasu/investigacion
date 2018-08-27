class MessagesController < ApplicationController
  def new
    @message = Message.new
  end
def create
    @message = Message.new message_params
if @message.valid?
      MessageMailer.contact(@message).deliver_now
      redirect_to new_message_url
      flash[:notice] = "Gracias, hemos recibido tu mensaje y agregaremos la información!"
    else
      flash[:notice] = "Hubo un error enviando el mensaje.Por favor intenta nuevamente"
      render :new
    end
  end
private
def message_params
    params.require(:message).permit(:name, :email, :phone_number, :body)
  end
end
