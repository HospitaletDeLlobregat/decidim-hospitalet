# frozen_string_literal: true
require "spec_helper"

module DecidimHospitalet
  module Surveys

    describe SurveyCSVPresenter do
      let(:current_feature) { create :surveys_feature }
      let(:surveys) { create_list(:survey_result, 3, feature: current_feature) }

      subject { described_class.new(surveys) }

      context "#to_data" do
        let(:data) { subject.to_data }
        let(:headers) { data.split("\n").first }

        it "includes the headers" do
          expect(headers).to include("Selecciona els 4 temes que trobis que són prioritaris en el teu barri per als propers 10 anys:")
        end

        it "includes the surveys data" do
          surveys[0].user = nil

          surveys.each do |survey|
            expect(data).to include("#{survey.categories.map { |c| c.name["ca"] }.join(';')}")
            expect(data).to include("#{survey.user&.email}")
          end
        end
      end
    end
  end
end
