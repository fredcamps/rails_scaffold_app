class CreateJoinTableHostnamesIps < ActiveRecord::Migration[6.0]
  def change
    create_join_table :ips, :hostnames do |t|
      t.index [:ip_id, :hostname_id], unique: true
      t.index [:hostname_id, :ip_id], unique: true
    end
  end
end
