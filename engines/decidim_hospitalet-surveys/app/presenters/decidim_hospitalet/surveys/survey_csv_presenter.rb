# frozen_string_literal: true
require 'csv'

module DecidimHospitalet
  module Surveys
    # Presenter class to render surveys as a csv
    class SurveyCSVPresenter
      COMMON_FIELDS = [
        :other_priorities,
        :future_ideas,
        :gender,
        :age_group,
        :zip_code,
        :living_at_scope,
        :city,
        :name,
        :phone
      ]

      def initialize(surveys)
        @surveys = surveys
      end

      def to_data
        headers + fields
      end

      private

      def headers
        CSV.generate_line(
          [I18n.t("decidim_hospitalet.surveys.questions.categories")].concat(
            COMMON_FIELDS.map do |field|
              I18n.t("decidim_hospitalet.surveys.questions.#{field}")
            end
          )
        )
      end

      def fields
        @surveys.map do |survey|
          CSV.generate_line(
            [survey.categories.map {|c| c.name[I18n.locale.to_s] }.join(";")].concat(
              COMMON_FIELDS.map { |field| survey.send(field) }
            )
          )
        end.join
      end
    end
  end
end
