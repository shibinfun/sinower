class Admin::WarrantyPdfsController < Admin::BaseController
  before_action :set_warranty_pdf, only: [:show, :edit, :update, :destroy, :download]
  
  def index
    @warranty_pdfs = WarrantyPdf.ordered
  end
  
  def show
  end
  
  def new
    @warranty_pdf = WarrantyPdf.new
  end
  
  def create
    @warranty_pdf = WarrantyPdf.new(warranty_pdf_params)
    
    if @warranty_pdf.save
      redirect_to admin_warranty_pdfs_path, notice: "PDF 已成功创建。"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    # Handle file removal if requested
    if params[:remove_file] == '1'
      @warranty_pdf.file.purge if @warranty_pdf.file.attached?
    end
    
    if @warranty_pdf.update(warranty_pdf_params)
      redirect_to admin_warranty_pdfs_path, notice: "PDF 已成功更新。"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @warranty_pdf.destroy
    redirect_to admin_warranty_pdfs_path, notice: "PDF 已成功删除。"
  end
  
  def download
    send_file @warranty_pdf.file.download, 
              filename: @warranty_pdf.file.filename.to_s,
              type: 'application/pdf',
              disposition: 'attachment'
  end
  
  private
  
  def set_warranty_pdf
    @warranty_pdf = WarrantyPdf.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_warranty_pdfs_path, alert: "PDF 未找到。"
  end
  
  def warranty_pdf_params
    params.require(:warranty_pdf).permit(:name, :pdf_type, :description, :file)
  end
end
