require "test_helper"

class SkuSeoTest < ActionDispatch::IntegrationTest
  setup do
    @sku = skus(:one)
    @sku.update!(
      seo_title: "Custom SEO Title EN",
      seo_title_zh: "自定义 SEO 标题 CN",
      seo_keywords: "keyword1, keyword2",
      seo_keywords_zh: "关键词1, 关键词2",
      seo_description: "Custom SEO Description EN",
      seo_description_zh: "自定义 SEO 描述 CN"
    )
  end

  test "should render custom SEO tags in English locale" do
    get sku_url(id: @sku.id, locale: 'en')
    assert_response :success
    
    assert_select "title", text: /Custom SEO Title EN/
    assert_select "meta[name='description'][content='Custom SEO Description EN']"
    assert_select "meta[name='keywords'][content='keyword1, keyword2']"
  end

  test "should render custom SEO tags in Chinese locale" do
    get sku_url(id: @sku.id, locale: 'zh-CN')
    assert_response :success
    
    assert_select "title", text: /自定义 SEO 标题 CN/
    assert_select "meta[name='description'][content='自定义 SEO 描述 CN']"
    assert_select "meta[name='keywords'][content='关键词1, 关键词2']"
  end

  test "should fallback to English SEO tags in Chinese locale if Chinese tags are missing" do
    @sku.update!(seo_title_zh: nil, seo_description_zh: nil, seo_keywords_zh: nil)
    
    get sku_url(id: @sku.id, locale: 'zh-CN')
    assert_response :success
    
    assert_select "title", text: /Custom SEO Title EN/
    assert_select "meta[name='description'][content='Custom SEO Description EN']"
    assert_select "meta[name='keywords'][content='keyword1, keyword2']"
  end

  test "should fallback to default SEO tags if all SEO fields are missing" do
    @sku.update!(
      seo_title: nil, seo_title_zh: nil, 
      seo_description: nil, seo_description_zh: nil, 
      seo_keywords: nil, seo_keywords_zh: nil
    )
    
    get sku_url(id: @sku.id, locale: 'en')
    assert_response :success
    
    # Check if it falls back to the default title pattern defined in the view
    assert_select "title", text: /#{@sku.name}/
  end
end
