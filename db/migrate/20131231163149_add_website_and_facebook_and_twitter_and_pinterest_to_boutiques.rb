class AddWebsiteAndFacebookAndTwitterAndPinterestToBoutiques < ActiveRecord::Migration
  def change
    add_column :boutiques, :website, :string
    add_column :boutiques, :facebook, :string
    add_column :boutiques, :twitter, :string
    add_column :boutiques, :pinterest, :string
  end
end
