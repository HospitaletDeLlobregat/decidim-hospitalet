# -*- coding: utf-8 -*-
# frozen_string_literal: true
require "spec_helper"

describe "Surveys", type: :feature do
  let(:feature) { create(:surveys_feature) }
  let(:organization) { feature.organization }
  let(:participatory_process) { feature.participatory_process }
  let!(:category) { create :category, participatory_process: participatory_process }
  let!(:scope) { create :scope, organization: organization }
  let!(:scope2) { create :scope, organization: organization }
  let!(:user) { create :user, :confirmed, organization: organization }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path

    find(".language-choose").hover
    within ".language-choose" do
      click_link "Català"
    end
  end

  context "when the user is not logged in" do
    it "is asked to sign in" do
      click_link "Processos"
      click_link translated(participatory_process.title, locale: :ca)
      click_link "Enquestes"
      click_link "Respon l'enquesta"

      expect(page).to have_content("Has d'iniciar sessió o bé registrar-te abans de continuar.")
    end
  end

  context "when the user is logged in" do
    before do
      login_as user, scope: :user
    end

    context "when the user has not submitted the survey" do
      it "creates a new survey" do
        click_link "Processos"
        click_link translated(participatory_process.title, locale: :ca)
        click_link "Enquestes"
        click_link "Respon l'enquesta"

        within ".new_survey_result" do
          select scope.name, from: :survey_result_scope_id
          check translated(category.name, locale: :ca)

          find("*[type=submit]").click
        end

        expect(page).to have_content("correctament")
      end
    end

    context "when the user has already submitted a survey" do
      it "cannot select the scope he has already selected" do
        create :survey_result, user: user, feature: feature, scope: scope
        click_link "Processos"
        click_link translated(participatory_process.title, locale: :ca)
        click_link "Enquestes"
        click_link "Respon l'enquesta"

        within ".new_survey_result" do
          expect(page).not_to have_css("option", text: scope.name)
        end
      end
    end
  end
end
