class Admin::SettingsController < Admin::BaseController
  def show
    @settings = {
      seo_title: Setting.get('seo_title', 'Sinower'),
      seo_description: Setting.get('seo_description', 'Sinower provides high-quality commercial refrigeration, cooking equipment, and stainless steel solutions for your business.'),
      seo_keywords: Setting.get('seo_keywords', 'commercial refrigeration, cooking equipment, stainless steel, Sinower, kitchen solutions'),
      robots_txt: Setting.get('robots_txt', "User-agent: *\nAllow: /"),
      sitemap: Setting.get('sitemap', '')
    }
  end

  def update
    settings_params.each do |key, value|
      Setting.set(key, value)
    end
    redirect_to admin_settings_path, notice: 'Settings updated successfully.'
  end

  private

  def settings_params
    params.require(:settings).permit(:seo_title, :seo_description, :seo_keywords, :robots_txt, :sitemap)
  end
end
