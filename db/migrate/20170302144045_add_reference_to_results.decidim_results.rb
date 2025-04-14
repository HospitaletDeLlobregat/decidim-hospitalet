# This migration comes from decidim_results (originally 20170215132624)
class AddReferenceToResults < ActiveRecord::Migration[5.0]
  class Result < ApplicationRecord
    self.table_name = :decidim_results_results
  end

  def change
    add_column :decidim_results_results, :reference, :string
    Result.find_each(&:save)
    change_column_null :decidim_results_results, :reference, false
  end
end
