class Address < ActiveRecord::Base
	belongs_to :parent, polymorhpic: true
end
