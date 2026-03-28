# Google Cloud Storage Configuration Guide

## 📋 配置步骤

### 第 1 步：安装 Gem

```bash
bin/bundle install
```

### 第 2 步：配置 Rails Credentials

运行以下命令编辑 production credentials:

```bash
EDITOR="code --wait" bin/rails credentials:edit --environment production
```

添加以下内容（替换为您的实际值）:

```yaml
gcp:
  project: your-gcp-project-id
  credentials:
    type: service_account
    project_id: your-project-id
    private_key_id: your-private-key-id
    private_key: |
      -----BEGIN PRIVATE KEY-----
      MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...
      (完整的私钥内容)
      -----END PRIVATE KEY-----
    client_email: your-service-account@your-project.iam.gserviceaccount.com
    client_id: "123456789"
    auth_uri: https://accounts.google.com/o/oauth2/auth
    token_uri: https://oauth2.googleapis.com/token
    auth_provider_x509_cert_url: https://www.googleapis.com/oauth2/v1/certs
    client_x509_cert_url: https://www.googleapis.com/robot/v1/metadata/x509/...
```

### 第 3 步：设置环境变量

在 Railway (或其他部署平台) 添加环境变量:

```bash
GCS_BUCKET=sinowerbucket-production
```

### 第 4 步：部署并迁移文件

部署后运行:

```bash
bin/rails active_storage:migrate
```

这将把所有现有文件从本地存储迁移到 Google Cloud Storage。

---

## 🔑 获取服务账号密钥

1. 访问 [GCP Console](https://console.cloud.google.com/)
2. 选择您的项目
3. 前往 **IAM 和管理** → **服务账号**
4. 找到您创建的服务账号（例如 `sinower-storage`）
5. 点击 "密钥" 标签
6. 点击 "添加密钥" → "创建新密钥"
7. 选择 JSON 格式并下载
8. 打开下载的 JSON 文件，复制内容到 credentials 中

---

## ✅ 验证配置

部署后，访问:

```bash
bin/rails console --environment production
```

测试:

```ruby
ActiveStorage::Blob.first
ActiveStorage::Blob.first.url
```

如果返回有效的 GCS URL，说明配置成功。

---

## 📊 监控

- 在 GCP Console → Cloud Storage 查看存储桶使用情况
- 查看费用和配额
- 设置预算提醒

---

## 🔒 安全最佳实践

1. **不要**将 credentials 文件提交到 Git
2. 定期轮换服务账号密钥（每 90 天）
3. 使用最小权限原则（只授予必要的权限）
4. 考虑使用 Workload Identity Federation（更安全）

---

## 🆘 故障排查

### 问题：权限错误

确保服务账号有 `Storage Object Admin` 角色

### 问题：找不到存储桶

检查存储桶名称和环境变量是否匹配

### 问题：CORS 错误

运行:

```bash
gsutil cors set cors.json gs://sinowerbucket-production
```

cors.json 内容:

```json
[
  {
    "origin": ["*"],
    "method": ["GET", "PUT", "POST", "DELETE"],
    "maxAgeSeconds": 3600,
    "responseHeader": ["Content-Type", "Origin", "X-Requested-With", "Accept", "Authorization"]
  }
]
```
