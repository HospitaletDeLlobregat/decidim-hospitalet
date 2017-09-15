# frozen_string_literal: true
require "spec_helper"

module DecidimHospitalet
  module Surveys

    describe SurveyCSVPresenter do
      let(:current_feature) { create :surveys_feature }
      let(:surveys) { create_list(:survey_result, 3, feature: current_feature) }

      subject { described_class.new(surveys) }

      describe "#to_data" do
        let(:data) { subject.to_data }
        let(:headers) { data.split("\n").first }

        it "includes the headers" do
          expect(headers).to include("Selecciona els 4 temes que trobis que són prioritaris en el teu barri per als propers 10 anys:")
        end

        it "includes survey categories" do
          surveys.each do |survey|
            expect(data).to include("#{survey.categories.map { |c| c.name[I18n.locale.to_s] }.join(';')}")
          end
        end

        it "includes user id" do
          surveys.each do |survey|
              expect(data).to include("#{survey.user.id}")
          end
        end

        it "includes user emails" do
          surveys.each do |survey|
              expect(data).to include("#{survey.user.email}")
          end
        end

        context "when a survey doesn't have a user" do
          before do
            surveys.last.update_attribute(:user, nil)
          end

          it "works without user email" do
            expect(data.split("\n").length).to eq(4)
          end
        end
      end
    end
  end
end
