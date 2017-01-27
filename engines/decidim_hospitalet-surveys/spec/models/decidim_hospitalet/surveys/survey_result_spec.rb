# frozen_string_literal: true
require "spec_helper"

module DecidimHospitalet
  module Surveys
    describe SurveyResult do
      subject { create(:survey_result) }

      it { is_expected.to be_valid }

      context "when the user is missing" do
        subject { build(:survey_result, user: nil) }

        it { is_expected.to be_valid }

        it "allows multiple anonymous surveys" do
          subject.save
          new_survey = build(:survey_result, scope: subject.scope, feature: subject.feature)

          expect(new_survey).to be_valid
        end
      end

      context "when the scope is missing" do
        subject { build(:survey_result, scope: nil) }

        it { is_expected.to be_invalid }
      end

      context "when the feature is missing" do
        let(:scope) { create :scope }
        let(:participatory_process) { create :participatory_process, organization: scope.organization }
        let(:category) { create :category, participatory_process: participatory_process }
        subject do
          build(
            :survey_result,
            feature: nil,
            scope: scope,
            selected_categories: [category.id],
            user: create(:user, organization: scope.organization)
          )
        end

        it { is_expected.to be_invalid }
      end

      context "when the author is from another organization" do
        subject { build(:survey_result, user: create(:user)) }

        it { is_expected.to be_invalid }
      end

      context "when the scope is from another organization" do
        subject { build(:survey_result, scope: create(:scope)) }

        it { is_expected.to be_invalid }
      end

      context "when the user/scope/feature combination already exists" do
        subject { build(:survey_result) }

        before do
          create(:survey_result, scope: subject.scope, user: subject.user, feature: subject.feature)
        end

        it { is_expected.not_to be_valid }
      end
    end
  end
end
