class DealerApplication < ApplicationRecord
  has_one_attached :resale_certificate

  serialize :product_categories, coder: JSON

  BUSINESS_TYPES = [
    "Restaurant Equipment Dealer",
    "Wholesale Distributor",
    "E-commerce Retailer",
    "Other"
  ].freeze

  ANNUAL_PURCHASE_VOLUMES = [
    "Under $50,000",
    "$50,000–$100,000",
    "$100,000–$250,000",
    "Over $250,000"
  ].freeze

  PRODUCT_CATEGORIES = [
    "Commercial Refrigeration",
    "Commercial Cooking Equipment",
    "Stainless Steel Equipment",
    "Other"
  ].freeze

  validates :company_name, presence: true
  validates :contact_person, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :address, presence: true
  validates :business_type, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def product_categories_list
    Array(product_categories).reject(&:blank?)
  end
end
