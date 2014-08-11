class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :title
      t.string :datapoint_source
      t.string :datapoint_name
      t.text :summary
      t.string :mitigation_steps
      t.string :contact

      t.timestamps
    end
  end
end
