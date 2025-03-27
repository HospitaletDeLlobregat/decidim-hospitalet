# frozen_string_literal: true
# This migration comes from decidim_meetings (originally 20250213114031)

class AddReminderCustomizationToDecidimMeetings < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_meetings_meetings, :reminder_enabled, :boolean
    add_column :decidim_meetings_meetings, :send_reminders_before_hours, :integer
    add_column :decidim_meetings_meetings, :reminder_message_custom_content, :jsonb
  end
end
