class Pelicula < ApplicationRecord
  has_many :rols
  has_many :personajes, through: :rols
  belongs_to :fondo, optional: true

def next
  Pelicula.where("id > ?", id).order(id: :asc).limit(1).first
end

def prev
  Pelicula.where("id < ?", id).order(id: :desc).limit(1).first
end
end
