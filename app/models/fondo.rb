class Fondo < ApplicationRecord
  has_many :peliculas, dependent: :destroy
end
