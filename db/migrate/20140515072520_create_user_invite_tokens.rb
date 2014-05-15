class CreateUserInviteTokens < ActiveRecord::Migration
  def change
    create_table :user_invite_tokens do |t|
      t.references :parent, polymorphic: true

      t.text     :code
      t.datetime :expires_at

      t.timestamps
    end
  end
end
