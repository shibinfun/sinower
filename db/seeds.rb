# This file should ensure the existence of records required to run the application
# in every environment in which it's expected to run.
#
# This is especially important for records that other records depend on,
# records that serve as defaults, or records that must always exist for
# the application to function properly.
#
# To run this file, execute:
#
#   bin/rails db:seed
#

puts "Seeding warranty PDFs..."

# Create default warranty PDF records
WarrantyPdf.find_or_create_by!(pdf_type: 'refrigeration') do |pdf|
  pdf.name = "Commercial Refrigeration Warranty PDF"
  pdf.description = "保修文件 - 商业制冷设备"
end

WarrantyPdf.find_or_create_by!(pdf_type: 'cooking') do |pdf|
  pdf.name = "Cooking Equipment Warranty PDF"
  pdf.description = "保修文件 - 烹饪设备"
end

WarrantyPdf.find_or_create_by!(pdf_type: 'stainless') do |pdf|
  pdf.name = "Stainless Steel Equipment Warranty PDF"
  pdf.description = "保修文件 - 不锈钢设备"
end

WarrantyPdf.find_or_create_by!(pdf_type: 'claim_form') do |pdf|
  pdf.name = "Submit Warranty Claim Form"
  pdf.description = "保修索赔申请表"
end

WarrantyPdf.find_or_create_by!(pdf_type: 'spare_parts') do |pdf|
  pdf.name = "Request Spare Parts Form"
  pdf.description = "备件申请表"
end

puts "✓ Created 5 warranty PDF records"
puts "Done seeding!"
