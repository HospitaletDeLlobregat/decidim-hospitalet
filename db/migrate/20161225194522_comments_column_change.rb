class CommentsColumnChange < ActiveRecord::Migration[5.0]
  def change
    rename_column :decidim_comments_comments, :commentable_type, :decidim_commentable_type
    rename_column :decidim_comments_comments, :commentable_id, :decidim_commentable_id
  end
end
