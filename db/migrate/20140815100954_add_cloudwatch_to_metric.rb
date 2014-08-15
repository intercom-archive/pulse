class AddCloudwatchToMetric < ActiveRecord::Migration
  def change
    add_column :metrics, :cloudwatch_namespace, :string
    add_column :metrics, :cloudwatch_identifier, :string
  end
end
