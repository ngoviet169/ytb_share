class CreateVideoReacts < ActiveRecord::Migration[7.0]
  def change
    create_table :video_reacts do |t|
      t.integer :video_id, null: false
      t.integer :user_id, null: false
      t.boolean :react, null:false, default: false

      t.timestamps
    end
  end
end
