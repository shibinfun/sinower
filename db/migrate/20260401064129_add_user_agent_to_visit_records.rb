class AddUserAgentToVisitRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :visit_records, :user_agent, :text
  end
end
