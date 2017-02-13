# frozen_string_literal: true

require "spec_helper"

describe DecidimHospitalet::Surveys::Ability do
  let(:user) { build(:user, :collaborator) }

  subject { described_class.new(user, {}) }

  it { is_expected.to be_able_to(:create, DecidimHospitalet::Surveys::SurveyResult) }
  it { is_expected.to be_able_to(:preview, DecidimHospitalet::Surveys::SurveyResult) }
  it { is_expected.not_to be_able_to(:edit, DecidimHospitalet::Surveys::SurveyResult) }
  it { is_expected.not_to be_able_to(:update, DecidimHospitalet::Surveys::SurveyResult) }
  it { is_expected.not_to be_able_to(:destroy, DecidimHospitalet::Surveys::SurveyResult) }
end
