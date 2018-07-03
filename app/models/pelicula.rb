class Pelicula < ApplicationRecord
def next
  Pelicula.where("id > ?", id).order(id: :asc).limit(1).first
end

def prev
  Pelicula.where("id < ?", id).order(id: :desc).limit(1).first
end
end
