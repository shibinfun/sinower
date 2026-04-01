class CreateVisitLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :visit_logs do |t|
      t.string :ip
      t.string :remote_ip
      t.string :path
      t.string :controller_name
      t.string :action_name
      t.string :user_agent
      t.string :referrer

      t.timestamps
    end
  end
end
