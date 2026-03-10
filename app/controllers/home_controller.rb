class HomeController < ApplicationController
  def index
  end

  def all_products
    @root_categories = Category.where(parent_id: nil).includes(children: { children: { children: :skus } })
  end

  def contact
    @contact_message = ContactMessage.new
  end

  def about
  end

  def create_contact
    @contact_message = ContactMessage.new(contact_params)
    if @contact_message.save
      redirect_to contact_path, notice: "消息已成功发送，我们会尽快与您联系。"
    else
      render :contact, status: :unprocessable_entity
    end
  end

  def warranty
  end

  private

  def contact_params
    params.require(:contact_message).permit(:name, :email, :subject, :message)
  end
end
