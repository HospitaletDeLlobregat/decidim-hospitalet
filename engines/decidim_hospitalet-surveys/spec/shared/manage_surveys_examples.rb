# -*- coding: utf-8 -*-
# frozen_string_literal: true
RSpec.shared_examples "manage surveys" do
  it "updates a survey" do
    within find("tr", text: survey.scope.name) do
      click_link "Edit"
    end

    within ".edit_survey" do
      fill_in_i18n(
        :survey_name,
        "#name-tabs",
        es: "Mi nuevo título",
        ca: "El meu nou títol"
      )

      find("*[type=submit]").click
    end

    within ".flash" do
      expect(page).to have_content("correctament")
    end

    within "table" do
      expect(page).to have_content("El meu nou títol")
    end
  end

  it "creates a new survey" do
    find(".actions .new").click

    within ".new_survey" do
      fill_in_i18n(
        :survey_name,
        "#name-tabs",
        es: "Mi survey",
        ca: "El meu survey"
      )
      fill_in_i18n(
        :survey_location,
        "#location-tabs",
        es: "Location",
        ca: "Location"
      )
      fill_in_i18n(
        :survey_location_hints,
        "#location_hints-tabs",
        es: "Location hints",
        ca: "Location hints"
      )
      fill_in_i18n_editor(
        :survey_short_description,
        "#short_description-tabs",
        es: "Descripción corta",
        ca: "Descripció curta"
      )
      fill_in_i18n_editor(
        :survey_description,
        "#description-tabs",
        es: "Descripción más larga",
        ca: "Descripció més llarga"
      )

      fill_in :survey_address, with: "Address"
      fill_in :survey_start_time, with: 1.day.from_now
      fill_in :survey_end_time, with: 1.day.from_now + 2.hours

      select scope.name, from: :survey_decidim_scope_id
      select translated(category.name), from: :survey_decidim_category_id

      find("*[type=submit]").click
    end

    within ".flash" do
      expect(page).to have_content("correctament")
    end

    within "table" do
      expect(page).to have_content("El meu survey")
    end
  end

  context "deleting a survey" do
    let!(:survey2) { create(:survey_result, feature: current_feature, selected_categories: [category.id]) }

    before do
      visit current_path
    end

    it "deletes a survey" do
      within find("tr", text: survey2.scope.name) do
        click_link "Eliminar"
      end

      within ".flash" do
        expect(page).to have_content("correctament")
      end

      within "table" do
        expect(page).to_not have_content(survey2.scope.name)
      end
    end
  end
end
