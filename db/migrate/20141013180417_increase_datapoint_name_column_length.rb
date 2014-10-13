class IncreaseDatapointNameColumnLength < ActiveRecord::Migration
  def change
    change_column :metrics, :datapoint_name, :text
  end
end
