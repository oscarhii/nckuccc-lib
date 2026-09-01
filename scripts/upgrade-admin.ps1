$source = Resolve-Path 'public/admin-v2.html'
$target = Join-Path (Split-Path $source) 'admin-v3.html'
$t = [IO.File]::ReadAllText($source)
$t = $t.Replace('.card{background:', '.modalbg{display:none;position:fixed;inset:0;background:#10291faa;z-index:20;padding:20px;place-items:center}.modalbg.open{display:grid}.modalbox{background:#f4f1e9;border-radius:20px;max-width:720px;width:100%;max-height:90dvh;overflow:auto;padding:5px 20px 20px}.modalclose{float:right;border:0;background:none;font-size:28px}.card{background:')
$t = $t.Replace('<section class="panel active" id="books"><div class="card"><h2>新增書籍</h2>', '<section class="panel active" id="books"><div class="toolbar"><h2>全部書籍</h2><button class="primary" id="openAdd">＋ 新增書籍</button></div><div class="modalbg" id="bookModal"><div class="modalbox"><button class="modalclose" type="button">×</button><div class="card"><h2 id="formTitle">新增書籍</h2>')
$t = $t.Replace('</form></div><div class="card"><div class="toolbar"><h2>全部書籍</h2><input id="bookSearch"', '</form></div></div></div><div class="card"><div class="toolbar"><input id="bookSearch"')
$t = $t.Replace('<label class="check wide"><input name="featured" type="checkbox">設為推薦書籍</label>', '<label class="check"><input name="featured" type="checkbox">設為推薦書籍</label><label class="check"><input name="is_new" type="checkbox" checked>顯示於最新上架</label><input name="edit_id" type="hidden">')
$t = $t.Replace('<th>推薦</th><th>操作</th>', '<th>推薦</th><th>最新</th><th>借閱次數</th><th>操作</th>')
$t = $t.Replace("<td>${b.featured?'★':'—'}</td><td class=", "<td>${b.featured?'★':'—'}</td><td>${b.is_new?'NEW':'—'}</td><td>${b.borrowCount||0}</td><td class=")
$t = $t.Replace("f.set('featured',f.has('featured')?'true':'false');", "f.set('featured',f.has('featured')?'true':'false');f.set('is_new',f.has('is_new')?'true':'false');")
$addon = @'
<script>const modal=document.querySelector('#bookModal'),form=document.querySelector('#bookForm');document.querySelector('#openAdd').onclick=()=>{form.reset();form.is_new.checked=true;form.edit_id.value='';document.querySelector('#formTitle').textContent='新增書籍';modal.classList.add('open')};document.querySelector('.modalclose').onclick=()=>modal.classList.remove('open');modal.onclick=e=>{if(e.target===modal)modal.classList.remove('open')};</script>
'@
$t = $t.Replace('</body>', $addon + '</body>')
[IO.File]::WriteAllText($target,$t,[Text.UTF8Encoding]::new($false))
