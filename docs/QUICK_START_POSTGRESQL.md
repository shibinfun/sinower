# Quick Start: PostgreSQL Local Setup

## ⚡ Fast Track (Choose One Method)

### Method A: Homebrew (If Network Allows)
```bash
brew install postgresql@18
brew services start postgresql@18
```

### Method B: Postgres.app (GUI Alternative)
1. Download: https://postgresapp.com/
2. Install and initialize
3. Add to PATH: `export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"`

### Method C: Skip for Now (Use SQLite Temporarily)
See rollback instructions in `docs/LOCAL_POSTGRESQL_SETUP.md`

---

## 📝 Configuration (Required)

Edit `.env` file with your PostgreSQL credentials:
```bash
# Open .env file
nano .env  # or use your preferred editor

# Update with your password:
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password_here
```

**Default installations often have no password** - try leaving it empty first.

---

## 🚀 Database Setup Commands

Once PostgreSQL is installed:

```bash
# 1. Create databases
bin/rails db:create

# 2. Run migrations
bin/rails db:migrate

# 3. (Optional) Generate test data
bin/rails dev:generate_page_views

# 4. Start server
bin/rails server
```

Visit: http://localhost:3000/admin/page_views

---

## ✅ Verify It Works

```bash
# Check database connection
bin/rails runner "puts ActiveRecord::Base.connection.execute('SELECT version()').first['version']"
```

Should output: `PostgreSQL 18.x ...`

---

## ❌ Common Issues

| Problem | Solution |
|---------|----------|
| Connection refused | `brew services start postgresql@18` |
| Authentication failed | Check `.env` password or leave empty |
| Database doesn't exist | Run `bin/rails db:create` |
| Command not found: psql | Install PostgreSQL first |

---

## 📖 Full Documentation

For detailed instructions and troubleshooting, see:
- `docs/LOCAL_POSTGRESQL_SETUP.md` - Complete setup guide
- `docs/PAGE_VIEWS_TEST_CHECKLIST.md` - Testing checklist
- `docs/ACTIVE_STORAGE_FIX.md` - ActiveStorage troubleshooting

---

## 🔧 Why This Matters

Using PostgreSQL locally (same as production):
- ✅ Catches SQL errors early (GROUP BY, data types, etc.)
- ✅ Tests real database behavior
- ✅ No "works on my machine" surprises
- ✅ Accurate performance testing

---

**Status:** Configuration complete ✅ | PostgreSQL installation pending ⏳
