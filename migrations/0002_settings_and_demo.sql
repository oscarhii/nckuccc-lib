CREATE TABLE IF NOT EXISTS settings(key TEXT PRIMARY KEY,value TEXT NOT NULL,updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP);
INSERT OR IGNORE INTO settings(key,value) VALUES ('admin_email','oscarhiishanmin26@gmail.com'),('primary_color','#18392b'),('accent_color','#f1c864'),('reminder_days','3,1');
INSERT OR IGNORE INTO books(id,title,author,publisher,pages,description,category,featured,created_at) VALUES
('demo-01','標竿人生','華理克','道聲出版社',336,'從人生目的重新思考信仰與生活。','信仰成長',1,'2026-08-28T00:00:00Z'),
('demo-02','返璞歸真的牧養藝術','尤金・畢德生','以琳書房',288,'在忙碌中重新看見牧養的本質。','牧養',1,'2026-08-19T00:00:00Z'),
('demo-03','禱告：經歷渴慕神','提摩太・凱勒','希望之聲',352,'從聖經與歷代信徒學習禱告。','靈修',1,'2026-08-03T00:00:00Z'),
('demo-04','團契生活','潘霍華','校園書房',160,'關於基督徒共同生活的經典作品。','群體',0,'2026-07-25T00:00:00Z'),
('demo-05','為何是祂','提摩太・凱勒','希望之聲',320,'回應現代人對基督信仰的核心疑問。','護教',0,'2026-07-14T00:00:00Z'),
('demo-06','恩典多奇異','楊腓力','校園書房',304,'尋找恩典在破碎世界中的蹤跡。','信仰成長',0,'2026-06-30T00:00:00Z'),
('demo-07','安息日的真諦','侯士庭','上海三聯',240,'在效率至上的文化中重拾安息。','生活實踐',0,'2026-06-18T00:00:00Z'),
('demo-08','認識神','巴刻','福音證主協會',384,'兼具神學深度與靈命實踐的入門經典。','神學',0,'2026-06-05T00:00:00Z');
