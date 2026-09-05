ALTER TABLE admins ADD COLUMN userid TEXT;
UPDATE admins SET userid = CASE WHEN lower(email) = 'oscarhiishanmin26@gmail.com' THEN 'oscarhii' ELSE lower(substr(email, 1, instr(email, '@') - 1)) END WHERE userid IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS idx_admins_userid ON admins(userid);
INSERT OR IGNORE INTO settings(key,value) VALUES('stats_reset_at','1970-01-01T00:00:00.000Z');
