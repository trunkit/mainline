class SetupHstore < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up   { enable_extension("hstore")  }
      dir.down { disable_extension("hstore") }
    end
  end
end
