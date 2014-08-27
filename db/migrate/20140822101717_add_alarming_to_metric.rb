class AddAlarmingToMetric < ActiveRecord::Migration
  def change
    add_column :metrics, :alarm_warning, :float
    add_column :metrics, :alarm_error, :float
    add_column :metrics, :negative_alarming, :boolean, default: false, null: false
  end
end
