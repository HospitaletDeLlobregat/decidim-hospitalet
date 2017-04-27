# frozen_string_literal: true
require "spec_helper"

module DecidimHospitalet
  module Surveys
    describe CreateSurveyResult do
      describe "call" do
        let(:organization) { create(:organization) }
        let(:participatory_process) { create :participatory_process, organization: organization }
        let(:feature) { create(:feature, participatory_process: participatory_process) }
        let(:category) { create :category, participatory_process: participatory_process }
        let(:user) { create(:user, organization: organization) }
        let(:form) do
          double(
            other_priorities: "Other priorities",
            future_ideas: "Future ideas",
            gender: "female",
            age_group: "65+",
            zip_code: "00000",
            living_at_scope: true,
            working_at_scope: true,
            city: "800180001",
            categories: [category],
            scope: create(:scope, organization: organization)
          )
        end
        let(:command) { described_class.new(form, feature, user) }

        describe "when the form is not valid" do
          before do
            expect(form).to receive(:invalid?).and_return(true)
          end

          it "broadcasts invalid" do
            expect { command.call }.to broadcast(:invalid)
          end

          it "doesn't create a survey result" do
            expect do
              command.call
            end.to_not change { SurveyResult.count }
          end
        end

        describe "when the form is valid" do
          before do
            expect(form).to receive(:invalid?).and_return(false)
          end

          it "broadcasts ok" do
            expect { command.call }.to broadcast(:ok)
          end

          it "creates a new survey result" do
            expect do
              command.call
            end.to change { SurveyResult.count }.by(1)
          end

          it "sets the survey result name to user name" do
            command.call
            expect(SurveyResult.last.name).to eq(user.name)
          end
        end
      end
    end
  end
end
