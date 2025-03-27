# frozen_string_literal: true
# This migration comes from decidim_meetings (originally 20250306100815)

class AddStatusToDecidimMeetingsRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_meetings_registrations, :status, :string, default: "registered", null: false
    add_index :decidim_meetings_registrations, :status
  end
end
