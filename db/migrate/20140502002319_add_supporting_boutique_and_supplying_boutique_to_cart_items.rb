class AddSupportingBoutiqueAndSupplyingBoutiqueToCartItems < ActiveRecord::Migration
  def change
    add_reference :cart_items, :supporting_boutique, index: true
    add_reference :cart_items, :supplying_boutique, index: true
  end
end
