class User < ActiveRecord::Base
  # :omniauthable is also available
  devise :confirmable, :database_authenticatable, :lockable,
         :recoverable, :rememberable, :timeoutable, :trackable, :validatable

  has_many :customers
  accepts_nested_attributes_for :customers, allow_destroy: true
  validates :name, presence: true
  before_validation :generate_password, on: :create

  def generate_password
    self.password_confirmation = self.password = Devise.friendly_token if self.password.nil? or self.password.blank?
  end
end
