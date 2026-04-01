class WarrantyInquiry < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :product_type, presence: true
  validates :model_number, presence: true
  validates :subject, presence: true
  validates :description, presence: true
end
