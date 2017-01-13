# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# You can remove the 'faker' gem if you don't want Decidim seeds.
raise if Rails.env.production?

Decidim.seed!

organization = Decidim::Organization.first
participatory_process = Decidim::ParticipatoryProcess.published.promoted.first

puts "Deleting default L'Hospitalet scopes..."
organization.scopes.destroy_all

puts "Creating custom L'Hospitalet scopes..."

scopes = [
  "El Centre",
  "Sant Josep",
  "Sanfeliu",
  "Collblanc",
  "La Torrassa",
  "Santa Eulàlia",
  "Granvia",
  "La Florida",
  "Les Planes",
  "Pubilla Cases",
  "Can Serra",
  "Bellvitge",
  "El Gornal"
].map do |scope_name|
  { name: scope_name, organization: organization }
end
Decidim::Scope.create!(scopes)

puts "Deleting default L'Hospitalet categories..."
participatory_process.categories.destroy_all

puts "Creating custom L'Hospitalet categories..."

categories = [
  { ca: "Urbanisme i espai públic: estat dels carrers, parcs, places, etc.", es: "Urbanismo y espacio público: estado de las calles, parques, plazas, etc" },
  { ca: "Activitat econòmica i ocupació: activitat comercial, promoció econòmica, noves activitats econòmiques, etc.", es: "Actividad económica y ocupación: actividad comercial, promoción económica, nuevas actividades económicas, etc." },
  { ca: "Transport públic", es: "Transporte público" },
  { ca: "Equipaments i serveis públics: biblioteques, centres culturals, centres esportius, serveis socials, etc.", es: "Equipamientos y servicios públicos: bibliotecas, centros cívicos, centros deportivos, servicios sociales, etc." },
  { ca: "Neteja", es: "Limpieza" },
  { ca: "Activitats d’oci, culturals i de lleure", es: "Actividades de ocio, culturales y de tiempo libre" },
  { ca: "Habitatge", es: "Vivienda" },
  { ca: "Educació i formació", es: "Educación y formación" },
  { ca: "Convivència i civisme", es: "Convivencia y civismo" },
  { ca: "Medi ambient i sostenibilitat", es: "Medio Ambiente y Sostenibilidad" },
  { ca: "Sanitat i salut", es: "Sanidad y salud" }
]

Decidim::Category.transaction do
  categories.each do |data|
    Decidim::Category.create!(name: data, description: data, participatory_process: participatory_process)
  end
end
