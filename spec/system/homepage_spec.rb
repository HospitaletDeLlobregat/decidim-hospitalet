# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization, default_locale: :ca, available_locales: [:ca, :es] }
  let!(:content_block) { create :content_block, organization: organization, manifest_name: :sub_hero, scope_name: :homepage }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the home page" do
    expect(page).to have_content("Inici")
    expect(page).not_to have_content("Inicio")
  end

  it "has a entities page" do
    visit entities_path
    expect(page).to have_content("Entitats de L'Hospitalet de Llobregat")
  end

  it "downloads the reglament" do
    within "main" do
      expect(page).to have_link("Reglament de Participació de L'Hospitalet de Llobregat", href: "/reglament.pdf")
    end
  end

  context "when in spanish" do
    before do
      within_language_menu do
        click_link "Castellano"
      end
    end

    it "renders the home page" do
      expect(page).to have_content("Inicio")
    end

    it "has a entities page" do
      visit entities_path
      expect(page).to have_content("Entidades de L'Hospitalet de Llobregat")
    end

    it "downloads the reglament" do
      within "main" do
        expect(page).to have_link("Reglamento de Participación de L'Hospitalet de Llobregat", href: "/reglament.pdf")
      end
    end
  end
end
