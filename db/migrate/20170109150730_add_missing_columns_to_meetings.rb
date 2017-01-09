class AddMissingColumnsToMeetings < ActiveRecord::Migration[5.0]
  def change
    change_table :decidim_meetings_meetings do |t|
      t.references :decidim_scope, index: true
      t.references :decidim_category, index: true
    end
  end
end
