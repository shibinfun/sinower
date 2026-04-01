# 测试套件运行指南

## 快速开始

### 运行所有测试
```bash
bin/rails test
```

### 运行特定测试文件
```bash
# PageView 模型测试
bin/rails test test/models/page_view_test.rb

# 控制器测试
bin/rails test test/controllers/admin/page_views_controller_test.rb

# 系统测试（需要 Chrome/ChromeDriver）
bin/rails test:system
```

### 运行单个测试
```bash
bin/rails test test/models/page_view_test.rb -n "test_should_calculate_duration_formatted"
```

---

## 测试覆盖率

### 安装 SimpleCov（可选）
```bash
bundle add simplecov --group test
```

### 生成覆盖率报告
```bash
COVERAGE=true bin/rails test
open coverage/index.html
```

---

## 测试分类

### 1. 模型测试 (Model Tests)
- ✅ `test/models/page_view_test.rb` - PageView 模型逻辑
- ✅ `test/models/sku_test.rb` - SKU 关联测试
- ✅ `test/models/category_test.rb` - Category 关联测试
- ✅ `test/models/concerns/ip_geolocation_test.rb` - IP 地理位置查询

### 2. 控制器测试 (Controller Tests)
- ✅ `test/controllers/admin/page_views_controller_test.rb` - Admin 后台统计页面
- ✅ `test/controllers/concerns/trackable_test.rb` - 访问追踪功能

### 3. 系统测试 (System Tests)
- ✅ `test/system/page_views_dashboard_test.rb` - 端到端 UI 测试

---

## 测试数据库准备

### 创建测试数据库
```bash
bin/rails db:test:prepare
```

### 加载测试数据
```bash
bin/rails fixtures:load
```

---

## CI/CD 集成

### GitHub Actions 示例
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
        ports: ['5432:5432']
    steps:
      - uses: actions/checkout@v3
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2.0
      - name: Install dependencies
        run: bundle install
      - name: Run tests
        run: bin/rails test
        env:
          DATABASE_URL: postgres://postgres:postgres@localhost:5432/test_db
          RAILS_ENV: test
```

---

## 常见问题

### Q: 测试失败提示 "Table 'page_views' doesn't exist"
```bash
bin/rails db:test:prepare
bin/rails db:migrate RAILS_ENV=test
```

### Q: 系统测试浏览器错误
```bash
# 安装 ChromeDriver
brew install chromedriver

# 或使用 Firefox
SELENIUM_WEBDRIVER=firefox bin/rails test:system
```

### Q: 如何跳过外部 API 调用测试
```bash
# Geolocation 测试会默认跳过，除非设置环境变量
TEST_GEOLOCATION=1 bin/rails test test/models/concerns/ip_geolocation_test.rb
```

---

## 测试清单

运行此命令确保所有测试通过：

```bash
#!/bin/bash
echo "Running all tests..."
bin/rails test

echo ""
echo "Running system tests..."
bin/rails test:system

echo ""
echo "All tests completed!"
```

---

## 新增测试时的注意事项

1. **命名规范**: 使用描述性的测试名称
   ```ruby
   test "should calculate duration formatted" do
   ```

2. **测试隔离**: 每个测试应该独立，不依赖其他测试的状态

3. **使用 Fixtures**: 尽量使用 fixtures 而不是硬编码数据

4. **测试边界条件**: 
   - 空值/nil
   - 极端值
   - 错误情况

5. **保持测试简洁**: 一个测试只验证一个行为

---

最后更新：April 1, 2026
