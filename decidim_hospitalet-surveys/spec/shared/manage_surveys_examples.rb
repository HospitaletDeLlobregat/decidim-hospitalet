# -*- coding: utf-8 -*-
# frozen_string_literal: true
RSpec.shared_examples "manage surveys" do
  context "exporting the survey results" do
    let!(:surveys) { create_list(:survey_result, 3, feature: current_feature) }

    it "downloads a csv file with the data" do
      visit current_path

      within ".card-title" do
        page.find('.button--title--export').click
      end

      expect(page.response_headers["Content-Disposition"]).to match(/filename=\"survey_results([^.]*).csv\"/)
    end
  end
end
