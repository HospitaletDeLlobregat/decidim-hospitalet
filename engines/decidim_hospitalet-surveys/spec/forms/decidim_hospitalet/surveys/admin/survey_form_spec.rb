# frozen_string_literal: true
require "spec_helper"

module DecidimHospitalet
  module Surveys
    module Admin
      describe SurveyResultForm do
        let(:feature) { create(:feature) }
        let(:user) { create(:user, organization: feature.organization) }
        let(:category) { create(:category, participatory_process: feature.participatory_process) }
        let(:scope) { create(:scope, organization: feature.organization) }
        let(:category_id) { category.try(:id) }
        let(:scope_id) { scope.try(:id) }
        let(:default_params) do
          {
            categories_ids: [category_id],
            scope_id: scope_id
          }
        end
        let(:params) { default_params }

        subject do
          described_class.from_params(params).with_context(
            current_feature: feature,
            current_user: user
          )
        end

        context "when everything is OK" do
          it { is_expected.to be_valid }
        end

        context "selected_categories" do
          context "with invalid id" do
            let(:category_id) { 987 }
            it { is_expected.not_to be_valid }
          end

          context "when no category_id" do
            let(:category_id) { nil }
            it { is_expected.not_to be_valid }
          end

          context "when selecting more than 4 valid categories" do
            let!(:categories) do
              create_list(:category, 5, participatory_process: feature.participatory_process)
            end
            let(:category_id) { categories.map(&:id) }
            it { is_expected.not_to be_valid }
          end
        end

        context "when no scope_id" do
          let(:scope_id) { nil }
          it { is_expected.not_to be_valid }
        end

        context "with invalid scope_id" do
          let(:scope_id) { 987 }
          it { is_expected.to be_invalid }
        end

        describe "categories" do
          subject do
            described_class.from_params(params)
              .with_context(current_feature: feature)
              .categories
          end

          context "when the category exists" do
            it { is_expected.to all(be_kind_of(Decidim::Category)) }
          end

          context "when the category does not exist" do
            let(:category_id) { 7654 }
            it { is_expected.to eq([]) }
          end

          context "when the category is from another process" do
            let(:category_id) { create(:category).id }
            it { is_expected.to eq([]) }
          end
        end

        describe "scope" do
          subject do
            described_class.from_params(params)
              .with_context(current_feature: feature)
              .scope
          end

          context "when the scope exists" do
            it { is_expected.to be_kind_of(Decidim::Scope) }
          end

          context "when the scope does not exist" do
            let(:scope_id) { 3456 }
            it { is_expected.to eq(nil) }
          end

          context "when the scope is from another organization" do
            let(:scope_id) { create(:scope).id }
            it { is_expected.to eq(nil) }
          end
        end

        describe "city" do
          context "when it is set" do
            context "to a blank value" do
              subject do
                described_class.from_params(params.merge(city: ""))
                  .with_context(current_feature: feature)
              end

              it { is_expected.to be_valid }
            end

            context "with a valid value" do
              subject do
                described_class.from_params(params.merge(city: "801930008"))
                  .with_context(current_feature: feature)
              end

              it { is_expected.to be_valid }
            end

            context "with an invalid value" do
              subject do
                described_class.from_params(params.merge(city: "invalid city"))
                  .with_context(current_feature: feature)
              end

              it { is_expected.not_to be_valid }
            end
          end
        end

        describe "gender" do
          context "when it is set" do
            context "to a blank value" do
              subject do
                described_class.from_params(params.merge(gender: ""))
                  .with_context(current_feature: feature)
              end

              it { is_expected.to be_valid }
            end

            context "with a valid value" do
              subject do
                described_class.from_params(params.merge(gender: "male"))
                  .with_context(current_feature: feature)
              end

              it { is_expected.to be_valid }
            end

            context "with an invalid value" do
              subject do
                described_class.from_params(params.merge(gender: "invalid gender"))
                  .with_context(current_feature: feature)
              end

              it { is_expected.not_to be_valid }
            end
          end
        end

        describe "age_group" do
          context "when it is set" do
            context "to a blank value" do
              subject do
                described_class.from_params(params.merge(age_group: ""))
                  .with_context(current_feature: feature)
              end

              it { is_expected.to be_valid }
            end

            context "with a valid value" do
              subject do
                described_class.from_params(params.merge(age_group: "65+"))
                  .with_context(current_feature: feature)
              end

              it { is_expected.to be_valid }
            end

            context "with an invalid value" do
              subject do
                described_class.from_params(params.merge(age_group: "invalid group"))
                  .with_context(current_feature: feature)
              end

              it { is_expected.not_to be_valid }
            end
          end
        end

        describe "proposal fields" do
          context "when titles and decriptions are filled equally" do
            let(:params) do
              default_params.merge(
                proposal_title_0: "Title",
                proposal_description_0: "Description"
              )
            end

            it { is_expected.to be_valid }
          end

          context "when there are more titles than descriptions" do
            let(:params) do
              default_params.merge(
                proposal_title_0: "Title",
                proposal_title_1: "Title 1",
                proposal_description_0: "Description"
              )
            end

            it { is_expected.not_to be_valid }
          end

          context "when there are more descriptions than titles" do
            let(:params) do
              default_params.merge(
                proposal_title_0: "Title",
                proposal_description_0: "Description",
                proposal_description_1: "Description 1"
              )
            end

            it { is_expected.not_to be_valid }
          end
        end

        describe "name" do
          context "exists when the email isn't present" do
            let(:params) do
              default_params.merge(
                name: "",
                email: "test@lhon-participa.cat"
              )
            end
            it { is_expected.not_to be_valid }
          end
        end
      end
    end
  end
end
