ALTER TABLE books ADD COLUMN is_new INTEGER NOT NULL DEFAULT 1;
ALTER TABLE books ADD COLUMN zhuyin_group TEXT;
ALTER TABLE books ADD COLUMN pinyin_group TEXT;
ALTER TABLE books ADD COLUMN stroke_count INTEGER;
CREATE TABLE IF NOT EXISTS reservations(id TEXT PRIMARY KEY,book_id TEXT NOT NULL,full_name TEXT NOT NULL,nickname TEXT NOT NULL,created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,notified_at TEXT,cancelled_at TEXT,fulfilled_at TEXT,FOREIGN KEY(book_id) REFERENCES books(id));
CREATE INDEX IF NOT EXISTS idx_reservations_queue ON reservations(book_id,created_at);
UPDATE books SET zhuyin_group=CASE id WHEN 'demo-01' THEN 'ㄅ' WHEN 'demo-02' THEN 'ㄈ' WHEN 'demo-03' THEN 'ㄉ' WHEN 'demo-04' THEN 'ㄊ' WHEN 'demo-05' THEN 'ㄨ' WHEN 'demo-06' THEN 'ㄣ' WHEN 'demo-07' THEN 'ㄢ' WHEN 'demo-08' THEN 'ㄖ' END,
pinyin_group=CASE id WHEN 'demo-01' THEN 'B' WHEN 'demo-02' THEN 'F' WHEN 'demo-03' THEN 'D' WHEN 'demo-04' THEN 'T' WHEN 'demo-05' THEN 'W' WHEN 'demo-06' THEN 'E' WHEN 'demo-07' THEN 'A' WHEN 'demo-08' THEN 'R' END,
stroke_count=CASE id WHEN 'demo-01' THEN 15 WHEN 'demo-02' THEN 7 WHEN 'demo-03' THEN 18 WHEN 'demo-04' THEN 14 WHEN 'demo-05' THEN 9 WHEN 'demo-06' THEN 10 WHEN 'demo-07' THEN 6 WHEN 'demo-08' THEN 14 END;
