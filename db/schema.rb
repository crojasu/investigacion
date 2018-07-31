# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_31_111834) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "fondos", force: :cascade do |t|
    t.string "tipo"
    t.integer "monto"
    t.bigint "pelicula_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "agno"
    t.string "sexo"
    t.index ["pelicula_id"], name: "index_fondos_on_pelicula_id"
  end

  create_table "peliculas", force: :cascade do |t|
    t.string "titulo"
    t.string "responsable"
    t.integer "agno"
    t.string "imbd"
    t.integer "idcinechile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contacto"
    t.string "tipo"
    t.integer "salas"
    t.integer "copias"
    t.integer "publico"
    t.hstore "sexos"
    t.index ["sexos"], name: "index_peliculas_on_sexos", using: :gin
  end

  create_table "personajes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "genero", default: "Hombre"
  end

  create_table "rols", force: :cascade do |t|
    t.string "name"
    t.bigint "personaje_id"
    t.bigint "pelicula_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sexo"
    t.string "ano"
    t.index ["pelicula_id"], name: "index_rols_on_pelicula_id"
    t.index ["personaje_id"], name: "index_rols_on_personaje_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "fondos", "peliculas"
  add_foreign_key "rols", "peliculas"
  add_foreign_key "rols", "personajes"
end
