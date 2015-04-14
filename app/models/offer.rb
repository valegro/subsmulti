class Offer < ActiveRecord::Base
  has_and_belongs_to_many :campaigns
  accepts_nested_attributes_for :campaigns
  has_and_belongs_to_many :products
  accepts_nested_attributes_for :products
  has_and_belongs_to_many :publications
  accepts_nested_attributes_for :publications
  has_and_belongs_to_many :prices
  accepts_nested_attributes_for :prices
  validates_presence_of :name
end
