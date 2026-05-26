# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://sinowerus.com'

SitemapGenerator::Sitemap.create do
  # 首页和 sitemap 索引文件会自动添加

  # 静态页面
  ['en', 'zh-CN'].each do |locale|
    add about_path(locale: locale), priority: 0.5, changefreq: 'monthly'
    add contact_path(locale: locale), priority: 0.5, changefreq: 'monthly'
    add warranty_path(locale: locale), priority: 0.5, changefreq: 'monthly'
    add all_products_path(locale: locale), priority: 0.8, changefreq: 'daily'

    # 分类页面
    Category.visible.find_each do |category|
      add category_path(category, locale: locale), lastmod: category.updated_at, priority: 0.7, changefreq: 'weekly'
    end

    # SKU 详情页面
    Sku.find_each do |sku|
      add sku_path(sku, locale: locale), lastmod: sku.updated_at, priority: 0.6, changefreq: 'weekly'
    end

    # 频道页面 (a, b, c)
    %w[a b c].each do |kind|
      add send("#{kind}_channel_path", locale: locale), priority: 0.7, changefreq: 'daily'
    end
  end
end
