ALTER TABLE loans ADD COLUMN renew_count INTEGER NOT NULL DEFAULT 0;
CREATE TABLE IF NOT EXISTS password_reset_tokens(id TEXT PRIMARY KEY,email TEXT NOT NULL,token_hash TEXT NOT NULL,expires_at TEXT NOT NULL,used_at TEXT,created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE INDEX IF NOT EXISTS idx_password_reset_token ON password_reset_tokens(token_hash,expires_at);
