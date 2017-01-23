# frozen_string_literal: true
require "spec_helper"

module DecidimHospitalet
  module Surveys
    module Admin
      describe CreateSurveyResult do
        describe "call" do
          let(:organization) { create(:organization) }
          let(:participatory_process) { create :participatory_process, organization: organization }
          let(:feature) { create(:feature, participatory_process: participatory_process) }
          let(:category) { create :category, participatory_process: participatory_process }
          let(:user) { create(:user, organization: organization) }
          let(:email) { nil }
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
              name: "My Name",
              phone: "987654321",
              categories: [category],
              current_feature: feature,
              current_user: user,
              email: email,
              scope: create(:scope, organization: organization)
            )
          end
          let(:subject) { described_class.new(form) }

          describe "when the form is not valid" do
            before do
              expect(form).to receive(:invalid?).and_return(true)
            end

            it "broadcasts invalid" do
              expect { subject.call }.to broadcast(:invalid)
            end

            it "doesn't create a survey result" do
              expect do
                subject.call
              end.to_not change { SurveyResult.count }
            end
          end

          describe "when the form is valid" do
            before do
              expect(form).to receive(:invalid?).and_return(false)
            end

            it "broadcasts ok" do
              expect { subject.call }.to broadcast(:ok, :success)
            end

            it "creates a new survey result" do
              expect do
                subject.call
              end.to change { SurveyResult.count }.by(1)
            end

            it "does not create a new user" do
              expect do
                subject.call
              end.not_to change { Decidim::User.count }
            end

            context "when the form has an email" do
              let(:email) { "my_email@example.org" }

              it "broadcasts ok" do
                expect { subject.call }.to broadcast(:ok, :user_invited)
              end

              it "invites a new user" do
                expect do
                  subject.call
                end.to change { Decidim::User.count }.by(1)
              end

              it "links the user and the survey result" do
                subject.call
                user = Decidim::User.last
                survey_result = SurveyResult.last

                expect(survey_result.user).to eq user
              end
            end
          end
        end
      end
    end
  end
end
