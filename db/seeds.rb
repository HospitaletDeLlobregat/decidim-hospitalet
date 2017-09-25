# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# You can remove the 'faker' gem if you don't want Decidim seeds.
if ENV["HEROKU_APP_NAME"].present?
  ENV["DECIDIM_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"
  ENV["SEED"] = "true"
end

Decidim.seed!

organization = Decidim::Organization.first
participatory_process = Decidim::ParticipatoryProcess.published.promoted.first
password = SecureRandom.base64(16)

puts "Deleting default L'Hospitalet scopes..."
Decidim::Scope.where.not(parent_id: nil).where(organization: organization).destroy_all
organization.scopes.destroy_all

puts "Creating custom L'Hospitalet scopes..."

scopes = [
  { ca: "El Centre" },
  { ca: "Sant Josep" },
  { ca: "Sanfeliu" },
  { ca: "Collblanc" },
  { ca: "La Torrassa" },
  { ca: "Santa Eulàlia" },
  { ca: "Granvia" },
  { ca: "La Florida" },
  { ca: "Les Planes" },
  { ca: "Pubilla Cases" },
  { ca: "Can Serra" },
  { ca: "Bellvitge" },
  { ca: "El Gornal" },
].map do |scope_name|
  { name: scope_name, organization: organization, code: scope_name[:ca] }
end
scopes = Decidim::Scope.create!(scopes)

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
    Decidim::Category.create!(name: data, description: data, participatory_space: participatory_process)
  end
end

categories = Decidim::Category.where(participatory_space: participatory_process).pluck(:id)

Decidim::Feature.where(manifest_name: :hospitalet_surveys).find_each do |feature|
  3.times do
    DecidimHospitalet::Surveys::SurveyResult.create!(
      feature: feature,
      scope: scopes.sample,
      selected_categories: categories.sample(Random.new.rand(1..4))
    )
  end
end

Decidim::User.where(
    email: "enquestes@lhon-participa.cat",
    organization: organization,
  ).first || Decidim::User.create!(
  {
    name: "Enquesta / Encuesta",
    password: password,
    password_confirmation: password,
    email: "enquestes@lhon-participa.cat",
    tos_agreement: "1",
    organization: organization,
    confirmed_at: Time.current
  }
)
