# Local PostgreSQL Setup Guide

## Current Status

✅ **Configuration Files Ready:**
- `config/database.yml` - Configured for PostgreSQL (development & test)
- `.env` - Environment variables template created
- `.env.example` - Template for team members
- `Gemfile` - dotenv-rails gem installed

⚠️ **PostgreSQL Installation Required**

Local PostgreSQL server needs to be installed before the application can run.

## Installation Options

### Option 1: Homebrew (Recommended for macOS)

```bash
# Install PostgreSQL
brew install postgresql@18

# Start PostgreSQL service
brew services start postgresql@18

# Verify installation
psql --version
```

**If you encounter SSL/network errors with Homebrew:**
- Check your internet connection
- Try running from a different network
- Contact your IT department if behind corporate proxy

### Option 2: Postgres.app (Alternative for macOS)

1. Download from https://postgresapp.com/
2. Drag to Applications folder
3. Open Postgres.app and click "Initialize"
4. Add to PATH in your shell profile:
   ```bash
   echo 'export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

### Option 3: Docker (Cross-platform)

```bash
# Run PostgreSQL in Docker container
docker run --name sinower-postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=your_password_here \
  -e POSTGRES_DB=sinower_development \
  -p 5432:5432 \
  -d postgres:14

# Update .env file with credentials
# POSTGRES_USER=postgres
# POSTGRES_PASSWORD=your_password_here
```

## Configuration Steps

### 1. Update `.env` File

Edit `/Users/shibin/sinower/.env` with your PostgreSQL credentials:

```env
# Local PostgreSQL Configuration
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_actual_password_here
```

**Note:** If using default PostgreSQL installation without password, leave `POSTGRES_PASSWORD` empty.

### 2. Create Databases

Once PostgreSQL is installed and running:

```bash
cd /Users/shibin/sinower

# Create development and test databases
bin/rails db:create

# Expected output:
# Created database 'sinower_development'
# Created database 'sinower_test'
```

### 3. Run Migrations

```bash
bin/rails db:migrate
```

This will create all tables including the new `page_views` table in PostgreSQL.

### 4. (Optional) Seed Test Data

Generate sample page view data for testing:

```bash
bin/rails dev:generate_page_views
```

### 5. Start the Application

```bash
bin/rails server
```

Visit: http://localhost:3000/admin/page_views

## Troubleshooting

### Connection Refused Error

**Problem:** `ActiveRecord::ConnectionNotEstablished: connection refused`

**Solution:** Make sure PostgreSQL service is running:
```bash
# For Homebrew installation
brew services list
brew services start postgresql@18
```

### Authentication Failed

**Problem:** `FATAL: password authentication failed for user "postgres"`

**Solution:** 
1. Check your `.env` file has correct credentials
2. Try connecting directly: `psql -U postgres`
3. Reset password if needed: `ALTER USER postgres WITH PASSWORD 'new_password';`

### Database Does Not Exist

**Problem:** `ActiveRecord::NoDatabaseError: database "sinower_development" does not exist`

**Solution:** Run `bin/rails db:create` to create the databases.

### Gem Not Found (dotenv-rails)

**Problem:** `.env` variables not loading

**Solution:** Ensure dotenv-rails is in Gemfile:
```ruby
group :development, :test do
  gem 'dotenv-rails'
end
```
Then run: `bundle install`

## Verifying Success

After setup, verify everything works:

```bash
# Check database connection
bin/rails runner "puts ActiveRecord::Base.connection.execute('SELECT version()').first['version']"

# Should output PostgreSQL version string
```

## Why PostgreSQL Locally?

Using PostgreSQL for development (matching production) provides:

1. **SQL Compatibility** - Catches PostgreSQL-specific errors early (e.g., GROUP BY rules)
2. **Feature Parity** - Tests database features available in production
3. **No Surprises** - Eliminates "works on my machine" issues
4. **Better Testing** - More accurate representation of production behavior

## Rollback to SQLite (Temporary)

If you need to quickly switch back to SQLite while setting up PostgreSQL:

1. Edit `config/database.yml`:
   ```yaml
   development:
     adapter: sqlite3
     database: db/development.sqlite3
   ```

2. Comment out dotenv-rails in Gemfile (optional):
   ```ruby
   # gem 'dotenv-rails'
   ```

3. Run migrations:
   ```bash
   bin/rails db:migrate
   ```

**Note:** This is temporary. Switch back to PostgreSQL as soon as possible to catch compatibility issues early.

## Next Steps After Installation

1. ✅ Install PostgreSQL (see options above)
2. ✅ Configure `.env` with credentials
3. ✅ Run `bin/rails db:create`
4. ✅ Run `bin/rails db:migrate`
5. ✅ Test: `bin/rails server`
6. ✅ Visit: http://localhost:3000/admin/page_views
7. ✅ Generate test data: `bin/rails dev:generate_page_views`

---

**Questions?** Refer to:
- Rails Guides: https://guides.rubyonrails.org/configuring.html#configuring-a-database
- PostgreSQL Docs: https://www.postgresql.org/docs/
- Project README.md for additional setup instructions
