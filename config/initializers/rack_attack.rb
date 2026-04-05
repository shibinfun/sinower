# Rack::Attack 配置 - IP级别速率限制
# 防止暴力破解、爬虫、DDoS攻击

class Rack::Attack
  # 缓存存储（使用Rails.cache）
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  ### Throttle 1: 登录接口限制 ###
  # 同一IP每分钟最多5次登录尝试（防止暴力破解）
  throttle('logins/ip', limit: 5, period: 1.minute) do |req|
    req.ip if req.path == '/users/sign_in' && req.post?
  end

  # 同一邮箱每小时最多3次登录尝试（防止针对特定账户的攻击）
  throttle('logins/email', limit: 3, period: 1.hour) do |req|
    if req.path == '/users/sign_in' && req.post?
      # 从POST参数中提取邮箱
      begin
        req.params['user']&.dig('email')&.downcase
      rescue
        nil
      end
    end
  end

  ### Throttle 2: 密码重置限制 ###
  # 同一IP每小时最多3次密码重置请求
  throttle('password_resets/ip', limit: 3, period: 1.hour) do |req|
    req.ip if req.path == '/users/password' && req.post?
  end

  # 同一邮箱每天最多3次密码重置
  throttle('password_resets/email', limit: 3, period: 1.day) do |req|
    if req.path == '/users/password' && req.post?
      begin
        req.params['user']&.dig('email')&.downcase
      rescue
        nil
      end
    end
  end

  ### Throttle 3: 联系表单限制 ###
  # 同一IP每小时最多10次联系表单提交
  throttle('contact/ip', limit: 10, period: 1.hour) do |req|
    req.ip if req.path == '/contact' && req.post?
  end

  ### Throttle 4: 保修表单限制 ###
  # 同一IP每小时最多10次保修表单提交
  throttle('warranty/ip', limit: 10, period: 1.hour) do |req|
    req.ip if req.path == '/warranty_inquiry' && req.post?
  end

  ### Throttle 5: 全站通用限制 ###
  # 同一IP每分钟最多60次请求（防止爬虫/DDoS）
  throttle('general/ip', limit: 60, period: 1.minute) do |req|
    req.ip unless req.path.start_with?('/assets/', '/up')
  end

  ### Throttle 6: API/导出接口限制 ###
  # 同一IP每小时最多5次CSV导出
  throttle('exports/ip', limit: 5, period: 1.hour) do |req|
    req.ip if req.path =~ %r{/admin/skus/(export|import)}
  end

  ### 自定义响应 ###
  # 当被限流时返回429状态码
  self.throttled_responder = lambda do |env|
    now = Time.now.utc
    match_data = env['rack.attack.match_data']
    
    headers = {
      'RateLimit-Limit' => match_data[:limit].to_s,
      'RateLimit-Remaining' => '0',
      'RateLimit-Reset' => (now + (match_data[:period] - now.to_i % match_data[:period])).to_s,
      'Content-Type' => 'text/html',
    }

    # 根据路径返回不同的提示消息
    path = env['PATH_INFO']
    message = if path == '/users/sign_in'
      '登录尝试过于频繁，请稍后再试。Too many login attempts, please try again later.'
    elsif path == '/users/password'
      '密码重置请求过于频繁，请稍后再试。Too many password reset requests, please try again later.'
    elsif path == '/contact' || path == '/warranty_inquiry'
      '提交过于频繁，请稍后再试。Too many submissions, please try again later.'
    else
      '请求过于频繁，请稍后再试。Too many requests, please try again later.'
    end

    [429, headers, [message]]
  end
end
