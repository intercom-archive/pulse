class AddServiceIdToMetrics < ActiveRecord::Migration
  def change
    add_reference :metrics, :service, index: true
  end
end
