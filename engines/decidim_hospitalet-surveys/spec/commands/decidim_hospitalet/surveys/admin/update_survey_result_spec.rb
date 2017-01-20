# frozen_string_literal: true
require "spec_helper"

module DecidimHospitalet
  module Surveys
    module Admin
      describe UpdateSurveyResult do
        describe "call" do
          let(:organization) { create(:organization) }
          let(:participatory_process) { create :participatory_process, organization: organization }
          let(:feature) { create(:feature, participatory_process: participatory_process) }
          let(:category) { create :category, participatory_process: participatory_process }
          let(:user) { create(:user, organization: organization) }
          let(:scope) { create(:scope, organization: organization) }
          let(:form) do
            double(
              other_priorities: "Other priorities",
              future_ideas: "New future ideas",
              gender: "female",
              age_group: "65+",
              zip_code: "00000",
              living_at_scope: true,
              working_at_scope: true,
              city: "800180001",
              name: "My Name",
              phone: "987654321",
              categories: [category],
              current_feature: feature,
              current_user: user,
              scope: create(:scope, organization: organization)
            )
          end
          let(:survey_result) { create :survey_result, scope: scope, feature: feature, selected_categories: [category.id], user: user, future_ideas: "Future ideas" }
          let(:command) { described_class.new(form, survey_result) }

          describe "when the form is not valid" do
            before do
              expect(form).to receive(:invalid?).and_return(true)
            end

            it "broadcasts invalid" do
              expect { command.call }.to broadcast(:invalid)
            end

            it "updates the survey result" do
              command.call
              survey_result.reload
              expect(survey_result.future_ideas).to eq "Future ideas"
            end
          end

          describe "when the form is valid" do
            before do
              expect(form).to receive(:invalid?).and_return(false)
            end

            it "broadcasts ok" do
              expect { command.call }.to broadcast(:ok)
            end

            it "updates the survey result" do
              command.call
              survey_result.reload
              expect(survey_result.future_ideas).to eq "New future ideas"
            end
          end
        end
      end
    end
  end
end
