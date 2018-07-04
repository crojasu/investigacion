class Personaje < ApplicationRecord
  has_many :rols
  has_many :peliculas, through: :rols
end
