class FixAuthor < ActiveRecord::Migration[5.0]
  def change
    rename_column :decidim_comments_comments, :author_id, :decidim_author_id
  end
end
