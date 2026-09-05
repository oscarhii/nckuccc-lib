UPDATE loans SET nickname=full_name WHERE nickname<>full_name;
UPDATE reservations SET nickname=full_name WHERE nickname<>full_name;
CREATE TABLE IF NOT EXISTS circulation_audit(
  id TEXT PRIMARY KEY,
  action TEXT NOT NULL,
  book_id TEXT,
  book_title TEXT,
  borrower_name TEXT,
  admin_email TEXT NOT NULL,
  details TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_circulation_audit_created ON circulation_audit(created_at);
