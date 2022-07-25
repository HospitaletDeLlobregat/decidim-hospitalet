# frozen_string_literal: true

Decidim::Calendar.configure do |config|
  config.calendar_options = {
    firstDay: 1,
    defaultView: "dayGridMonth",
    hour12: false,
    views: "dayGridMonth,dayGridWeek,dayGridDay,listMonth"
  }
end