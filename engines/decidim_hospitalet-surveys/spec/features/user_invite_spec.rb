# frozen_string_literal: true
require "spec_helper"

describe "User invite", type: :feature do
  let(:organization) { create(:organization) }
  let(:participatory_process) { create :participatory_process, organization: organization }
  let(:feature) { create(:feature, participatory_process: participatory_process) }
  let(:category) { create :category, participatory_process: participatory_process }
  let(:email) { "my_email@example.org" }
  let(:form) do
    DecidimHospitalet::Surveys::Admin::SurveyResultForm.new(params).with_context(current_feature: feature)
  end

  let(:params) do
    {
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
      categories_ids: [category],
      current_feature: feature,
      current_user: nil,
      email: email,
      scope_id: create(:scope, organization: organization).id
    }
  end
  let(:command) do
    DecidimHospitalet::Surveys::Admin::CreateSurveyResult.new(form)
  end

  before(:each) do
    expect{ command.call }.to broadcast(:ok, :user_invited)
    switch_to_host(organization.host)
  end

  describe "Accept an invitation", perform_enqueued: true do
    it "asks for a password and redirects to the organization dashboard" do
      visit Nokogiri::HTML(last_email.html_part.body.encoded).css("table.content a").last["href"]

      within ".new_user" do
        fill_in :user_password, with: "123456"
        fill_in :user_password_confirmation, with: "123456"
        find("*[type=submit]").click
      end

      expect(page).to have_content("Welcome to")
    end
  end
end
