class Shirt < ActiveRecord::Base
  has_one :product, as: :content
  has_many :color_shirts
  has_many :shirt_sizes
  has_many :shirt_colors, through: :color_shirts
  has_many :text_colors, through: :color_shirts
  has_many :sizes, through: :shirt_sizes

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  attr_accessible :price, :stock, :name, :design, :delete_fl

  has_attached_file :design,
    storage: :dropbox,
    styles: { order: '303x145>', admin: '345x150>', large: '500x500>' },
    default_url: nil,
    dropbox_credentials: "#{Rails.root}/config/dropbox.yml",
    dropbox_options: { path: proc { |style| "bodyfuel/#{Rails.env}/designs/#{style}/#{id}/#{design.original_filename}"} }

  validates_attachment :design, content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] }

  def self.not_deleted
    where delete_fl: false
  end

  def self.most_recent
    order 'created_at desc'
  end

  def soft_delete
    update_attributes delete_fl: true
  end

  def deleted?
    delete_fl
  end
end