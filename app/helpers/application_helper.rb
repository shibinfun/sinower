module ApplicationHelper
  def categories_for_kind(kind)
    Category.where(category_kind: kind, parent_id: nil).includes(children: { children: { children: { children: :children } } })
  end
  
  # Helper to get warranty PDF by type
  def get_warranty_pdf(type)
    WarrantyPdf.find_by(pdf_type: type)
  end
  
  # Check if a warranty PDF has a file attached
  def warranty_pdf_available?(type)
    pdf = get_warranty_pdf(type)
    pdf&.file&.attached?
  end
  
  # Get download URL for warranty PDF
  def warranty_pdf_url(type)
    pdf = get_warranty_pdf(type)
    return nil unless pdf&.file&.attached?
    
    rails_blob_path(pdf.file, disposition: "attachment")
  end
end
