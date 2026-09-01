$p=Resolve-Path 'worker/app-v2.ts';$t=[IO.File]::ReadAllText($p)
$t=$t.Replace('fetch(s.endpoint,payload)','fetch(s.endpoint,payload as unknown as RequestInit)')
$t=$t.Replace('SELECT b.*,NOT EXISTS(SELECT 1 FROM loans l WHERE l.book_id=b.id AND l.returned_at IS NULL) available FROM books b','SELECT b.*,NOT EXISTS(SELECT 1 FROM loans l WHERE l.book_id=b.id AND l.returned_at IS NULL) available,(SELECT COUNT(*) FROM loans z WHERE z.book_id=b.id) borrowCount FROM books b')
$t=$t.Replace('INSERT INTO books(id,title,author,publisher,pages,description,category,featured,cover_key)VALUES(?,?,?,?,?,?,?,?,?)','INSERT INTO books(id,title,author,publisher,pages,description,category,featured,is_new,cover_key)VALUES(?,?,?,?,?,?,?,?,?,?)')
$t=$t.Replace("f.get('featured')==='true'?1:0,key).run()","f.get('featured')==='true'?1:0,f.get('is_new')==='true'?1:0,key).run()")
$t=$t.Replace("featured=? WHERE id=?').bind(x.title,x.author||null,x.publisher||null,Number(x.pages)||null,x.description||null,x.category||null,x.featured?1:0,book[1])","featured=?,is_new=? WHERE id=?').bind(x.title,x.author||null,x.publisher||null,Number(x.pages)||null,x.description||null,x.category||null,x.featured?1:0,x.is_new?1:0,book[1])")
$old="async scheduled(_c:ScheduledController,e:Env){await e.DB.prepare('DELETE FROM admin_sessions WHERE expires_at<?').bind(new Date().toISOString()).run()}"
$new=@'
async scheduled(_c:ScheduledController,e:Env){await e.DB.prepare('DELETE FROM admin_sessions WHERE expires_at<?').bind(new Date().toISOString()).run();const setting=await e.DB.prepare(`SELECT value FROM settings WHERE key='reminder_days'`).first<any>(),days=new Set(String(setting?.value||'3,1').split(',').map(Number)),rows=await e.DB.prepare(`SELECT l.nickname,l.due_at,b.title FROM loans l JOIN books b ON b.id=l.book_id WHERE l.returned_at IS NULL`).all<any>(),today=new Date();today.setUTCHours(0,0,0,0);for(const l of rows.results){const due=new Date(l.due_at);due.setUTCHours(0,0,0,0);const left=Math.round((due.getTime()-today.getTime())/864e5);if(days.has(left))await push(e,l.nickname,'借閱到期提醒',`《${l.title}》還有 ${left} 天到期，記得準時歸還。`)}}
'@
$t=$t.Replace($old,$new.Trim())
[IO.File]::WriteAllText($p,$t,[Text.UTF8Encoding]::new($false))
