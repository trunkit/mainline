class CustomerOrder < ActiveRecord::Base

  belongs_to :boutique, class_name: "Boutique"
  has_many :items
  mount_uploader :shipping_label, ShippingLabelUploader

end
