# frozen_string_literal: true

require "spec_helper"

describe DecidimHospitalet::Surveys::Abilities::ParticipatoryProcessCollaboratorAbility do
  let(:organization) { create(:organization) }
  let(:user) { build(:user, organization: organization) }
  let(:participatory_process) { create(:participatory_process, organization: organization) }
  let(:feature) { create(:surveys_feature, participatory_space: participatory_process) }

  before do
    create(:participatory_process_user_role, user: user, participatory_process: participatory_process, role: :collaborator)
  end

  subject do
    described_class.new(user, {
      current_participatory_process: participatory_process
    })
  end

  it { is_expected.to be_able_to(:create, DecidimHospitalet::Surveys::SurveyResult) }
  it { is_expected.to be_able_to(:preview, DecidimHospitalet::Surveys::SurveyResult) }
  it { is_expected.not_to be_able_to(:edit, DecidimHospitalet::Surveys::SurveyResult) }
  it { is_expected.not_to be_able_to(:update, DecidimHospitalet::Surveys::SurveyResult) }
  it { is_expected.not_to be_able_to(:destroy, DecidimHospitalet::Surveys::SurveyResult) }
end
