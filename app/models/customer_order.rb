class CustomerOrder < ActiveRecord::Base

  belongs_to :boutique, class_name: "Boutique"
  belongs_to :item, class_name: "Item"
  mount_uploader :shipping_label, ShippingLabelUploader

end
