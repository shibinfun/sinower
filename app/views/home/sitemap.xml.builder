xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9", "xmlns:xhtml": "http://www.w3.org/1999/xhtml" do
  host = "https://sinowerus.com"
  locales = ['en', 'zh-CN']
  paths = [
    { path: "", changefreq: "daily", priority: 1.0 },
    { path: "about", changefreq: "monthly", priority: 0.5 },
    { path: "contact", changefreq: "monthly", priority: 0.5 },
    { path: "warranty", changefreq: "monthly", priority: 0.5 },
    { path: "all_products", changefreq: "daily", priority: 0.8 }
  ]

  # 静态页面
  paths.each do |p|
    locales.each do |locale|
      xml.url do
        url_path = p[:path].present? ? "/#{p[:path]}" : ""
        xml.loc "#{host}/#{locale}#{url_path}"
        locales.each do |alt_locale|
          hreflang = alt_locale == 'zh-CN' ? 'zh-Hans' : alt_locale
          xml.tag! "xhtml:link", rel: "alternate", hreflang: hreflang, href: "#{host}/#{alt_locale}#{url_path}"
        end
        xml.tag! "xhtml:link", rel: "alternate", hreflang: "x-default", href: "#{host}/en#{url_path}"
        xml.changefreq p[:changefreq]
        xml.priority p[:priority]
      end
    end
  end

  # 频道页
  ['a', 'b', 'c'].each do |kind|
    locales.each do |locale|
      xml.url do
        xml.loc "#{host}/#{locale}/#{kind}"
        locales.each do |alt_locale|
          hreflang = alt_locale == 'zh-CN' ? 'zh-Hans' : alt_locale
          xml.tag! "xhtml:link", rel: "alternate", hreflang: hreflang, href: "#{host}/#{alt_locale}/#{kind}"
        end
        xml.tag! "xhtml:link", rel: "alternate", hreflang: "x-default", href: "#{host}/en/#{kind}"
        xml.changefreq "daily"
        xml.priority "0.7"
      end
    end
  end

  # 分类页
  Category.visible.find_each do |category|
    locales.each do |locale|
      xml.url do
        xml.loc "#{host}/#{locale}/categories/#{category.slug}"
        locales.each do |alt_locale|
          hreflang = alt_locale == 'zh-CN' ? 'zh-Hans' : alt_locale
          xml.tag! "xhtml:link", rel: "alternate", hreflang: hreflang, href: "#{host}/#{alt_locale}/categories/#{category.slug}"
        end
        xml.tag! "xhtml:link", rel: "alternate", hreflang: "x-default", href: "#{host}/en/categories/#{category.slug}"
        xml.lastmod category.updated_at.strftime('%Y-%m-%d')
        xml.changefreq "weekly"
        xml.priority "0.6"
      end
    end
  end

  # SKU 详情页
  Sku.all.find_each do |sku|
    locales.each do |locale|
      xml.url do
        xml.loc "#{host}/#{locale}/skus/#{sku.slug}"
        locales.each do |alt_locale|
          hreflang = alt_locale == 'zh-CN' ? 'zh-Hans' : alt_locale
          xml.tag! "xhtml:link", rel: "alternate", hreflang: hreflang, href: "#{host}/#{alt_locale}/skus/#{sku.slug}"
        end
        xml.tag! "xhtml:link", rel: "alternate", hreflang: "x-default", href: "#{host}/en/skus/#{sku.slug}"
        xml.lastmod sku.updated_at.strftime('%Y-%m-%d')
        xml.changefreq "weekly"
        xml.priority "0.6"
      end
    end
  end
end
