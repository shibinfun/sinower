# ActiveStorage GCS 问题排查与修复指南

## 问题描述

在 Railway production 环境中出现 `ActiveStorage::FileNotFoundError` 错误，原因是：
- ActiveStorage 尝试从 Google Cloud Storage (GCS) 下载不存在的文件
- 通常发生在生成图片变体（variant）时
- 数据库中有文件记录，但实际文件在 GCS 中不存在

## 可能的原因

1. **本地上传后未同步到 GCS** - 开发环境使用本地存储，production 使用 GCS
2. **GCS 凭证配置错误** - 环境变量缺失或不正确
3. **手动删除了 GCS 文件** - 数据库中仍有记录
4. **迁移过程中文件丢失** - 数据迁移时未正确复制文件

## 快速诊断步骤

### 1. 运行诊断工具

```bash
# SSH into Railway shell 或在本地执行
bin/rails active_storage:diagnose
```

这将检查：
- GCS 连接状态
- Blob 统计信息
- 缺失的文件
- 无效的变体记录

### 2. 检查环境变量

确认以下环境变量在 Railway 中已正确设置：

```bash
# Railway Dashboard → Environment Variables
GCP_PROJECT_ID=your-project-id
GCP_CREDENTIALS_JSON={"type":"service_account",...}
GCS_BUCKET=sinowerbucket
```

### 3. 测试 GCS 连接

```bash
bin/rails active_storage:test_upload
```

如果失败，请检查：
- GCP 服务账号是否有 Storage Admin 权限
- 凭证 JSON 格式是否正确
- Bucket 是否存在且可访问

## 解决方案

### 方案 1: 清理缺失的文件记录（推荐）

如果文件确实在 GCS 中不存在，清理数据库引用：

```bash
bin/rails active_storage:cleanup_missing_blobs
```

这会：
- 检测 GCS 中缺失的文件
- 删除相关的附件记录
- 清除孤立的 blob 记录

### 方案 2: 重新上传缺失的文件

如果有备份，可以重新上传缺失的文件到 GCS。

### 方案 3: 切换到临时存储（紧急情况下）

暂时切换回本地存储以恢复服务：

```ruby
# config/environments/production.rb
config.active_storage.service = :local  # 临时改回本地
```

⚠️ **注意**: Railway 是 ephemeral 文件系统，重启后文件会丢失，这只是临时方案。

## 预防措施

### 1. 使用镜像存储

配置主备双存储：

```yaml
# config/storage.yml
mirror:
  service: Mirror
  primary: google
  mirrors: [ local ]
```

这样即使 GCS 不可用，还有本地副本。

### 2. 添加错误处理

所有图片展示的地方都应该有异常捕获：

```erb
<% begin %>
  <%= image_tag image.variant(resize_to_limit: [100, 100]) %>
<% rescue ArgumentError, ActiveStorage::FileNotFoundError, ActiveStorage::InvariableError %>
  <div class="placeholder">无法预览</div>
<% end %>
```

### 3. 定期维护

每周运行一次检查和清理：

```bash
# 添加到 recurring.yml 或 cron
bin/rails active_storage:diagnose
bin/rails active_storage:purge_unattached
```

### 4. 监控告警

在 Railway 中添加日志监控，当出现以下错误时告警：
- `ActiveStorage::FileNotFoundError`
- `Google::Cloud::NotFound`
- `ActiveStorage::VariantNotFoundError`

## 验证修复

1. 访问之前报错的页面
2. 检查 Rails logs 是否还有错误
3. 确认图片正常显示或有占位符

## 联系支持

如果问题持续，请收集以下信息：

```bash
# 完整诊断报告
bin/rails active_storage:diagnose > storage_diagnosis.txt

# 最近的错误日志
heroku logs --tail | grep -i "activestorage"
```

---

最后更新：April 1, 2026
