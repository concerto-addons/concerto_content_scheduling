class AddScheduleToContents < ActiveRecord::Migration
  def change
    add_column :contents, :schedule, :text
  end
end
