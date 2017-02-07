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
          let(:proposals_feature) { create(:proposal_feature, participatory_process: participatory_process) }
          let(:category) { create :category, participatory_process: participatory_process }
          let(:admin) { create(:user, :admin, organization: organization) }
          let(:user) { create(:user, organization: organization) }
          let(:email) { nil }
          let(:scope) { create(:scope, organization: organization) }
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
              organization: organization,
              invited_by: nil,
              roles: [],
              invitation_instructions: "invite_admin",
              proposal_title_0: "My proposal 0",
              proposal_title_1: "My proposal 1",
              proposal_title_2: nil,
              proposal_title_3: nil,
              proposal_description_0: "Awesome description 0",
              proposal_description_1: "Awesome description 1",
              proposal_description_2: nil,
              proposal_description_3: nil,
              proposal_scope_id_0: scope.id,
              proposal_scope_id_1: scope.id,
              proposal_scope_id_2: nil,
              proposal_scope_id_3: nil,
              proposals_feature: proposals_feature,
              scope: scope,
              current_user: admin
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
              expect(form).to receive(:invalid?).at_least(1).and_return(false)
            end

            it "broadcasts ok" do
              expect { subject.call }.to broadcast(:ok, :success)
            end

            it "creates a new survey result" do
              expect do
                subject.call
              end.to change { SurveyResult.count }.by(1)
            end

            it "sets the created_by_admin flag" do
              subject.call
              expect(SurveyResult.last.created_by_admin).to be_truthy
            end

            it "sets the author association to the current user" do
              subject.call
              expect(SurveyResult.last.author).to eq(admin)
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

            describe "with related proposals" do
              it { is_expected.to broadcast(:ok) }

              context "when no propsoals featuer is present" do
                let(:proposals_feature) { nil }

                it "creates the proposals" do
                  expect do
                    subject.call
                  end.not_to change(Decidim::Proposals::Proposal, :count)
                end
              end

              it "creates the proposals" do
                expect do
                  subject.call
                end.to change(Decidim::Proposals::Proposal, :count).by(2)
              end

              context "when not creating a user" do
                let(:email) { nil }

                it "creates anonymous proposals" do
                  subject.call
                  proposals = Decidim::Proposals::Proposal.all

                  expect(proposals.map(&:author)).to eq [nil, nil]
                end
              end

              context "when creating a user" do
                let(:email) { "my_email@example.com" }

                it "assigns the proposals to the user" do
                  subject.call
                  authors = Decidim::Proposals::Proposal.all.map(&:author)

                  expect(authors[0]).to eq authors[1]
                  expect(authors[0].email).to eq email
                end
              end
            end
          end
        end
      end
    end
  end
end
