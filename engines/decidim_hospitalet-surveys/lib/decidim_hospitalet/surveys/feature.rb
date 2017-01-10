# frozen_string_literal: true

require_dependency "decidim/features/namer"

Decidim.register_feature(:hospitalet_surveys) do |feature|
  feature.engine = DecidimHospitalet::Surveys::Engine
  feature.admin_engine = DecidimHospitalet::Surveys::AdminEngine
  feature.icon = "decidim_hospitalet/surveys/icon.svg"

  feature.on(:before_destroy) do |instance|
  end

  feature.seeds do
    Decidim::ParticipatoryProcess.all.each do |process|
      next unless process.steps.any?

      Decidim::Feature.create!(
        name: { es: "Encuestas", ca: "Enquestes" },
        manifest_name: :hospitalet_surveys,
        participatory_process: process
      )
    end
  end
end
