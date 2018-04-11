Decidim.menu :menu do |menu|
  menu.item I18n.t("menu.entities", scope: "decidim"),
            Rails.application.routes.url_helpers.entities_path,
            position: 3,
            active: :inclusive
end