class AddEmailAndPhoneToBoutiques < ActiveRecord::Migration
  def change
    add_column(:boutiques, :email, :text)
    add_column(:boutiques, :phone, :text)
  end
end
