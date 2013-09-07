class Customer < ActiveRecord::Base
  has_many :orders
  has_many :carts

  validates :first_name, :last_name, :email, presence: true
  validates :email, format: { with: /@/ }
  attr_accessible :first_name, :last_name, :email

  def self.saveable_attributes
    [:first_name, :last_name, :email]
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    full_name
  end

end