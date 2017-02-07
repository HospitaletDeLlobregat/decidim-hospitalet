# frozen_string_literal: true

require_dependency "decidim/features/namer"

Decidim.register_feature(:hospitalet_surveys) do |feature|
  feature.engine = DecidimHospitalet::Surveys::Engine
  feature.admin_engine = DecidimHospitalet::Surveys::AdminEngine
  feature.icon = "decidim_hospitalet/surveys/icon.svg"

  feature.on(:before_destroy) do |instance|
    if DecidimHospitalet::Surveys::SurveyResult.where(feature: instance).any?
      raise "Can't destroy this feature when there are survey submissions"
    end
  end

  feature.seeds do
    Decidim::ParticipatoryProcess.all.each do |process|
      next unless process.steps.any?

      Decidim::Feature.create!(
        name: { es: "Encuestas", ca: "Enquestes" },
        manifest_name: :hospitalet_surveys,
        published_at: Time.current,
        participatory_process: process
      )
    end
  end
end
