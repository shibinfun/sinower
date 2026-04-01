class WarrantyPdf < ApplicationRecord
  has_one_attached :file
  
  validates :name, presence: true
  validates :pdf_type, presence: true, uniqueness: true
  validates :pdf_type, inclusion: { 
    in: %w[refrigeration cooking stainless claim_form spare_parts],
    message: "%{value} is not a valid PDF type"
  }
  
  # Validate that file is attached and is a PDF
  validate :validate_file_attachment
  
  def validate_file_attachment
    if file.attached? && !file.blob.content_type.in?(%w[application/pdf])
      errors.add(:file, "must be a PDF file")
    end
  end
  
  # Helper methods to get PDFs by type
  scope :ordered, -> { order(:name) }
  
  def self.refrigeration
    find_by(pdf_type: 'refrigeration')
  end

  def self.cooking
    find_by(pdf_type: 'cooking')
  end

  def self.stainless
    find_by(pdf_type: 'stainless')
  end

  def self.claim_form
    find_by(pdf_type: 'claim_form')
  end

  def self.spare_parts
    find_by(pdf_type: 'spare_parts')
  end

  def refrigeration?
    pdf_type == 'refrigeration'
  end
  
  def cooking?
    pdf_type == 'cooking'
  end
  
  def stainless?
    pdf_type == 'stainless'
  end
  
  def claim_form?
    pdf_type == 'claim_form'
  end
  
  def spare_parts?
    pdf_type == 'spare_parts'
  end
  
  # Get display name based on type
  def display_name
    case pdf_type
    when 'refrigeration'
      'Commercial Refrigeration Warranty PDF'
    when 'cooking'
      'Cooking Equipment Warranty PDF'
    when 'stainless'
      'Stainless Steel Equipment Warranty PDF'
    when 'claim_form'
      'Submit Warranty Claim Form'
    when 'spare_parts'
      'Request Spare Parts Form'
    else
      name
    end
  end
end
