class Product < ActiveRecord::Base
  has_many :offer_products
  accepts_nested_attributes_for :offer_products
  has_many :offers, through: :offer_products
  accepts_nested_attributes_for :offers
  has_many :product_orders
  validates :name, presence: true, uniqueness: true
  has_attached_file :image, styles: { large: '1020x768>', thumb: '100x100#' },
    convert_options: { thumb: '-strip -quality 75' }
    validates_attachment_content_type :image, content_type: %r{\Aimage/}
    
end
