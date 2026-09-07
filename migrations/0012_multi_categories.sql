CREATE TABLE IF NOT EXISTS categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE COLLATE NOCASE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS book_categories (
  book_id TEXT NOT NULL,
  category_id TEXT NOT NULL,
  PRIMARY KEY (book_id, category_id),
  FOREIGN KEY (book_id) REFERENCES books(id),
  FOREIGN KEY (category_id) REFERENCES categories(id)
);
CREATE INDEX IF NOT EXISTS idx_book_categories_category ON book_categories(category_id,book_id);
INSERT OR IGNORE INTO categories(id,name)
SELECT lower(hex(randomblob(16))),trim(category) FROM books
WHERE deleted_at IS NULL AND category IS NOT NULL AND trim(category)<>'';
INSERT OR IGNORE INTO book_categories(book_id,category_id)
SELECT b.id,c.id FROM books b JOIN categories c ON c.name=trim(b.category)
WHERE b.deleted_at IS NULL AND b.category IS NOT NULL AND trim(b.category)<>'';
