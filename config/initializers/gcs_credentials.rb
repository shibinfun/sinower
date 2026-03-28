# GCS Credentials Helper
# Converts Rails encrypted credentials to a format usable by google-cloud-storage gem

module GcsConfig
  def self.credentials_hash
    # Try to get credentials from Rails encrypted credentials
    creds = Rails.application.credentials.dig(:gcp, :credentials)
    
    # Convert ActiveSupport::OrderedOptions to regular Hash
    if creds.is_a?(ActiveSupport::OrderedOptions) || creds.is_a?(ActiveSupport::HashWithIndifferentAccess)
      return deep_stringify_keys(creds.to_h)
    elsif creds.is_a?(Hash)
      return deep_stringify_keys(creds)
    end
    
    creds
  end
  
  def self.project_id
    Rails.application.credentials.dig(:gcp, :project)
  end
  
  private
  
  def self.deep_stringify_keys(hash)
    return hash unless hash.is_a?(Hash)
    
    hash.transform_keys(&:to_s).transform_values do |v|
      v.is_a?(Hash) ? deep_stringify_keys(v) : v
    end
  end
end
