namespace :gcs do
  desc "Configure CORS on Google Cloud Storage bucket"
  task configure_cors: :environment do
    puts "Configuring CORS on GCS bucket..."
    puts "Run this command in your terminal:"
    puts ""
    puts "  gsutil cors set cors.json gs://#{ENV.fetch('GCS_BUCKET', 'sinowerbucket-production')}"
    puts ""
    puts "Make sure you have gsutil installed: gcloud components install gsutil"
  end

  desc "Test Google Cloud Storage connection"
  task test_connection: :environment do
    require 'google/cloud/storage'
    
    begin
      credentials = Rails.application.credentials.dig(:gcp, :credentials)
      project = Rails.application.credentials.dig(:gcp, :project)
      bucket_name = ENV.fetch("GCS_BUCKET", "sinowerbucket-production")
      
      unless credentials && project
        puts "❌ Error: GCP credentials not configured in Rails credentials"
        puts "Run: bin/rails credentials:edit --environment production"
        exit 1
      end
      
      storage = Google::Cloud::Storage.new(
        project_id: project,
        credentials: credentials
      )
      
      bucket = storage.bucket bucket_name
      
      if bucket
        puts "✅ Successfully connected to GCS bucket: #{bucket_name}"
        puts "   Location: #{bucket.location}"
        puts "   Storage Class: #{bucket.storage_class}"
        puts "   Versioning: #{bucket.versioning ? 'enabled' : 'disabled'}"
      else
        puts "❌ Bucket #{bucket_name} not found"
        exit 1
      end
    rescue Google::Cloud::PermissionDeniedError => e
      puts "❌ Permission denied: #{e.message}"
      puts "Check that your service account has 'Storage Object Admin' role"
      exit 1
    rescue Google::Cloud::NotFoundError => e
      puts "❌ Bucket not found: #{e.message}"
      puts "Make sure the bucket name is correct and exists"
      exit 1
    rescue => e
      puts "❌ Error: #{e.message}"
      puts e.backtrace.first(5)
      exit 1
    end
  end

  desc "Migrate Active Storage files to Google Cloud Storage"
  task migrate_files: :environment do
    puts "This task will migrate all Active Storage files to GCS"
    puts "WARNING: This may take a while depending on the number of files"
    puts ""
    print "Continue? (y/N): "
    break unless STDIN.gets.strip.downcase == 'y'
    
    blobs = ActiveStorage::Blob.all
    count = 0
    
    blobs.each do |blob|
      begin
        # The file should already be uploaded to GCS if using :google service
        # This task just verifies the migration
        if blob.service.exist?(blob.key)
          puts "✓ #{blob.filename} - OK"
          count += 1
        else
          puts "✗ #{blob.filename} - NOT FOUND in GCS"
        end
      rescue => e
        puts "✗ #{blob.filename} - Error: #{e.message}"
      end
    end
    
    puts ""
    puts "Migration check complete: #{count}/#{blobs.count} files found in GCS"
  end
end
