# frozen_string_literal: true
require "spec_helper"

module DecidimHospitalet
  module Surveys
    describe SurveyResult do
      subject { create(:survey_result) }

      it { is_expected.to be_valid }

      context "when the author is from another organization" do
        subject { build(:survey_result, user: create(:user))}

        it { is_expected.to be_invalid}
      end

      context "when the scope is from another organization" do
        subject { build(:survey_result, scope: create(:scope))}

        it { is_expected.to be_invalid}
      end
    end
  end
end
