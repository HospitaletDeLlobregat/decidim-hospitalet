Decidim.menu :menu do |menu|
  page = Decidim::StaticPage.find_by(slug: 'entitats')
  return unless page

  menu.item I18n.t("menu.entities", scope: "decidim"),
            page_path(page.slug),
            position: 3,
            active: :inclusive
end
