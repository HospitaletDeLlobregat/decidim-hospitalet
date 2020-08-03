# frozen_string_literal: true

class FixMissingAssemblyParentsPath < ActiveRecord::Migration[5.2]
  class Assembly < ApplicationRecord
    self.table_name = :decidim_assemblies
    belongs_to :parent, foreign_key: "parent_id", class_name: "Decidim::Assembly", inverse_of: :children
    has_many :children, foreign_key: "parent_id", class_name: "Decidim::Assembly", inverse_of: :parent, dependent: :destroy
  end

  def up
    Assembly.where(parents_path: nil).each do |assembly|
      assembly.update_column(:parents_path, parents_path(assembly)) if parents_path(assembly)
      assembly.children.each do |child_assembly|
        child_assembly.update_column(:parents_path, parents_path(child_assembly)) if parents_path(child_assembly)
      end
    end
  end

  def parents_path(assembly)
    [assembly.parent&.parents_path, assembly.id].select(&:present?).join(".")
  end
end
