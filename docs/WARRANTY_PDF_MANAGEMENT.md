# Warranty PDF 管理功能

## 功能概述

在 Admin 后台添加了"Warranty PDF 管理"功能，用于管理保修页面上的 4 个 PDF 文件：

1. **Commercial Refrigeration Warranty PDF** - 商业制冷设备保修 PDF
2. **Cooking Equipment Warranty PDF** - 烹饪设备保修 PDF  
3. **Stainless Steel Equipment Warranty PDF** - 不锈钢设备保修 PDF
4. **Submit Warranty Claim Form** - 保修索赔申请表

## 访问路径

- Admin 后台 → 左侧菜单 → "Warranty PDF 管理"
- 或直接访问：`/admin/warranty_pdfs`

## 功能特性

### 1. PDF 列表页面
- 显示所有已上传的 PDF 文件
- 显示 PDF 类型、描述、文件大小、更新时间
- 快速访问查看、编辑、删除功能

### 2. 上传新 PDF
- 点击"上传新 PDF"按钮
- 填写信息：
  - **PDF 名称**: 自定义文件名称
  - **PDF 类型**: 选择对应的产品类型（4 种）
  - **描述**: 可选，描述此 PDF 的内容或版本
  - **PDF 文件**: 上传 PDF 文件（最大 10MB）
- 支持拖放上传

### 3. 编辑 PDF
- 可以更新 PDF 文件
- 可以修改名称和描述
- 可以选择删除当前文件并上传新文件

### 4. 查看 PDF 详情
- 查看完整的 PDF 信息
- 下载 PDF 文件
- 查看文件大小、内容类型、上传时间等详细信息

### 5. 删除 PDF
- 删除 PDF 记录（包括附件）
- 删除前有确认提示

## 前台显示

### Warranty 页面自动同步

保修页面 (`/warranty`) 会自动从数据库加载最新的 PDF 文件：

- **View Details 部分**: 显示 3 个产品类型的保修 PDF
  - Commercial Refrigeration
  - Cooking Equipment
  - Stainless Steel Equipment

- **How Warranty Service Works 部分**: 显示索赔申请表 PDF

### 未上传文件的处理

如果某个 PDF 暂未上传，前台会显示灰色提示框：
- "PDF 暂未上传" 或 "索赔表单 PDF 暂未上传"

## 数据库结构

```ruby
create_table :warranty_pdfs do |t|
  t.string :name, null: false
  t.string :pdf_type, null: false  # refrigeration, cooking, stainless, claim_form
  t.string :description
  t.timestamps
end
```

## Active Storage 集成

PDF 文件通过 Rails Active Storage 管理，支持：
- 本地存储（开发环境）
- Google Cloud Storage（生产环境，需配置）
- 其他云存储服务（S3、Azure 等）

## 生产环境配置

如果使用 Google Cloud Storage，需要：

1. 在 `config/storage.yml` 中配置 GCS
2. 在 `config/environments/production.rb` 中设置：
   ```ruby
   config.active_storage.service = :google
   ```
3. 上传服务账号密钥文件
4. 运行迁移和种子数据

## 常见问题

### Q: 如何替换现有的 PDF 文件？
A: 在编辑页面，勾选"删除当前文件并上传新文件"，然后上传新文件。

### Q: 上传后前台没有立即更新？
A: 可能是缓存问题。尝试清除浏览器缓存或等待 CDN 缓存过期。

### Q: 支持哪些文件格式？
A: 仅支持 PDF 格式。上传其他格式会被验证拒绝。

### Q: 文件大小有限制吗？
A: 建议不超过 10MB。如需调整，修改控制器中的验证逻辑。

## 开发者注意事项

1. **不要硬编码 PDF 路径** - 始终从数据库动态加载
2. **检查文件是否存在** - 使用 `warranty_pdf_available?` helper
3. **使用正确的下载链接** - 使用 `rails_blob_path` 生成
4. **生产环境测试** - 确保 GCS 配置正确后再部署

## 相关文件

- Model: `app/models/warranty_pdf.rb`
- Controller: `app/controllers/admin/warranty_pdfs_controller.rb`
- Views: `app/views/admin/warranty_pdfs/`
- Migration: `db/migrate/20260328000000_create_warranty_pdfs.rb`
- Seeds: `db/seeds.rb`
- Routes: `config/routes.rb`
- Sidebar: `app/views/admin/shared/_sidebar.html.erb`
- Frontend: `app/views/home/warranty.html.erb`
