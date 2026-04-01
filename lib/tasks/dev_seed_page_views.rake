namespace :dev do
  desc "Generate sample page view data for testing"
  task generate_page_views: :environment do
    puts "Generating sample page views..."
    
    # 获取一些真实的 SKU 和分类
    skus = Sku.limit(10).to_a
    categories = Category.limit(5).to_a
    
    # 示例 IP 地址（模拟不同地区）
    sample_ips = [
      { ip: '203.86.241.12', city: 'Shanghai', province: 'Shanghai', country: 'China' },
      { ip: '175.178.25.93', city: 'Beijing', province: 'Beijing', country: 'China' },
      { ip: '114.242.26.45', city: 'Guangzhou', province: 'Guangdong', country: 'China' },
      { ip: '218.93.156.78', city: 'Shenzhen', province: 'Guangdong', country: 'China' },
      { ip: '180.153.89.21', city: 'Chengdu', province: 'Sichuan', country: 'China' },
      { ip: '8.8.8.8', city: 'Mountain View', province: 'California', country: 'United States' },
      { ip: '1.1.1.1', city: 'Los Angeles', province: 'California', country: 'United States' }
    ]
    
    user_agents = [
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
      'Mozilla/5.0 (Linux; Android 13; SM-G991B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0'
    ]
    
    # 生成 50 条访问记录
    50.times do |i|
      location = sample_ips.sample
      sku = skus.sample
      
      PageView.create!(
        page_type: :sku,
        page_id: sku&.id || categories.sample&.id,
        page_name: sku&.name || categories.sample&.name,
        ip: location[:ip],
        city: location[:city],
        province: location[:province],
        country: location[:country],
        user_agent: user_agents.sample,
        referer: ['https://www.google.com/', 'https://www.bing.com/', nil].sample,
        session_id: SecureRandom.uuid,
        visited_at: rand(0..7).days.ago + rand(0..24).hours.ago,
        duration: rand(5..300)
      )
      
      print '.' if i % 5 == 0
    end
    
    puts "\n✓ Generated 50 sample page views!"
    puts "Visit /admin/page_views to see the statistics."
  end
end
