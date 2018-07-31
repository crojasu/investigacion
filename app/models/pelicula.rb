class Pelicula < ApplicationRecord
  has_many :rols, dependent: :destroy
  has_many :personajes, through: :rols, dependent: :destroy
  belongs_to :fondo, optional: true
  has_many :fondos, dependent: :destroy
  store_accessor :sexos

def next
  Pelicula.where("id > ?", id).order(id: :asc).limit(1).first
end

def prev
  Pelicula.where("id < ?", id).order(id: :desc).limit(1).first
end
end
