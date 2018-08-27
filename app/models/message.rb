class Message
  include ActiveModel::Model
  attr_accessor :name, :email, :body, :nombre, :titulo, :rol
  validates :name, :email, presence: true
end
