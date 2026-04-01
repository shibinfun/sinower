namespace :active_storage do
  desc "Diagnose and clean up orphaned or missing ActiveStorage blobs"
  task diagnose: :environment do
    puts "=" * 60
    puts "ActiveStorage Diagnostic Report"
    puts "=" * 60
    puts
    
    # Check GCS configuration
    puts "1. Checking GCS Configuration..."
    begin
      service = ActiveStorage::Blob.service
      puts "   ✓ Service: #{service.class}"
      puts "   ✓ Bucket: #{service.bucket.name rescue 'N/A'}"
      puts "   ✓ Project: #{service.project.identifier rescue 'N/A'}"
    rescue => e
      puts "   ✗ GCS Connection Error: #{e.message}"
    end
    puts
    
    # Count total blobs
    puts "2. Blob Statistics:"
    total_blobs = ActiveStorage::Blob.count
    puts "   Total blobs in database: #{total_blobs}"
    
    used_blobs = ActiveStorage::Blob.joins(:attachments).distinct.count
    puts "   Blobs with attachments: #{used_blobs}"
    
    orphaned_blobs = total_blobs - used_blobs
    puts "   Orphaned blobs (no attachments): #{orphaned_blobs}"
    puts
    
    # Check for missing files in GCS
    puts "3. Checking for Missing Files in GCS..."
    missing_count = 0
    invalid_variant_count = 0
    
    ActiveStorage::Blob.find_each do |blob|
      begin
        # Try to access the file
        blob.download { |chunk| }
      rescue ActiveStorage::FileNotFoundError, Google::Cloud::NotFound => e
        puts "   ✗ Missing: #{blob.filename} (key: #{blob.key})"
        missing_count += 1
      rescue => e
        puts "   ✗ Error accessing #{blob.filename}: #{e.message}"
        missing_count += 1
      end
    end
    
    puts "\n   Found #{missing_count} missing blob(s) in GCS"
    puts
    
    # Check variant records
    puts "4. Checking Variant Records..."
    if defined?(ActiveStorage::VariantRecord)
      total_variants = ActiveStorage::VariantRecord.count
      puts "   Total variant records: #{total_variants}"
      
      # Find variants without parent blobs
      invalid_variants = ActiveStorage::VariantRecord.left_joins(:blob)
                                                    .where(active_storage_blobs: { id: nil })
      if invalid_variants.any?
        puts "   ⚠ #{invalid_variants.count} variant(s) reference missing blobs"
      end
    end
    puts
    
    # Recommendations
    puts "5. Recommendations:"
    if missing_count > 0
      puts "   • Run: bin/rails active_storage:cleanup_missing_blobs"
      puts "     (This will remove database records for files missing from GCS)"
    end
    
    if orphaned_blobs > 0
      puts "   • Run: bin/rails active_storage:purge_unattached"
      puts "     (This will purge blobs that have no attachments)"
    end
    
    if missing_count == 0 && orphaned_blobs == 0
      puts "   ✓ No issues found!"
    end
    
    puts
    puts "=" * 60
  end
  
  desc "Clean up database records for blobs missing from GCS"
  task cleanup_missing_blobs: :environment do
    puts "Cleaning up missing blob records from database..."
    
    cleaned_count = 0
    
    ActiveStorage::Blob.find_each do |blob|
      begin
        blob.download { |chunk| }
      rescue ActiveStorage::FileNotFoundError, Google::Cloud::NotFound => e
        puts "Removing record for missing file: #{blob.filename} (key: #{blob.key})"
        
        # Purge all associated attachments
        blob.attachments.each(&:purge)
        
        # Then purge the blob itself
        blob.purge
        
        cleaned_count += 1
      rescue => e
        puts "Error processing #{blob.filename}: #{e.message}"
      end
    end
    
    puts "\n✓ Cleaned up #{cleaned_count} missing blob record(s)"
  end
  
  desc "Upload a test image to GCS to verify configuration"
  task test_upload: :environment do
    require "stringio"
    
    puts "Testing GCS upload..."
    
    begin
      # Create a simple test image (1x1 pixel PNG)
      test_image_data = Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==")
      io = StringIO.new(test_image_data)
      io.rewind
      
      # Upload to GCS
      blob = ActiveStorage::Blob.create_and_upload!(
        io: io,
        filename: "test_#{Time.current.to_i}.png",
        content_type: "image/png"
      )
      
      puts "✓ Successfully uploaded test image to GCS!"
      puts "  Blob ID: #{blob.id}"
      puts "  Filename: #{blob.filename}"
      puts "  Key: #{blob.key}"
      
      # Verify we can download it
      downloaded = blob.download
      puts "✓ Successfully verified download (#{downloaded.bytesize} bytes)"
      
      # Clean up
      blob.purge
      puts "✓ Test file purged successfully"
      
    rescue => e
      puts "✗ Upload test failed: #{e.message}"
      puts "  Please check your GCP_CREDENTIALS_JSON and GCS_BUCKET environment variables"
    end
  end
end
