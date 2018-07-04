class Personaje < ApplicationRecord
  has_many :rols, dependent: :destroy
  has_many :peliculas, through: :rols, dependent: :destroy
end
