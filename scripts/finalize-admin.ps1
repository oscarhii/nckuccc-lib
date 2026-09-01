$p = Resolve-Path 'public/admin-v3.html'
$t = [IO.File]::ReadAllText($p)
$oldSubmit = @'
$('#bookForm').onsubmit=async e=>{e.preventDefault();const f=new FormData(e.target),pic=$('#cover').files[0];f.set('featured',f.has('featured')?'true':'false');f.set('is_new',f.has('is_new')?'true':'false');if(pic)f.set('cover',await shrink(pic),'cover.webp');try{await req('/api/admin/books',{method:'POST',body:f});e.target.reset();toast('書籍新增完成');await load()}catch(x){toast(x.message)}};
'@
$newSubmit = @'
$('#bookForm').onsubmit=async e=>{e.preventDefault();const form=e.target,id=form.edit_id.value;try{if(id){const x=Object.fromEntries(new FormData(form));x.featured=form.featured.checked;x.is_new=form.is_new.checked;await req('/api/admin/books/'+id,{method:'PUT',headers:{'content-type':'application/json'},body:JSON.stringify(x)});toast('書籍更新完成')}else{const f=new FormData(form),pic=$('#cover').files[0];f.set('featured',f.has('featured')?'true':'false');f.set('is_new',f.has('is_new')?'true':'false');if(pic)f.set('cover',await shrink(pic),'cover.webp');await req('/api/admin/books',{method:'POST',body:f});toast('書籍新增完成')}form.reset();$('#bookModal').classList.remove('open');await load()}catch(x){toast(x.message)}};
'@
$t = $t.Replace($oldSubmit.Trim(),$newSubmit.Trim())
$oldClick = @'
$('#bookRows').onclick=async e=>{const id=e.target.dataset.delete||e.target.dataset.edit;if(!id)return;const b=state.books.find(x=>x.id===id);if(e.target.dataset.delete){if(!confirm(`確定刪除《${b.title}》？`))return;await req('/api/admin/books/'+id,{method:'DELETE'});toast('書籍已刪除')}else{const title=prompt('書名',b.title);if(!title)return;const author=prompt('作者',b.author||'');const category=prompt('分類',b.category||'');await req('/api/admin/books/'+id,{method:'PUT',headers:{'content-type':'application/json'},body:JSON.stringify({...b,title,author,category})});toast('書籍已更新')}await load()};
'@
$newClick = @'
$('#bookRows').onclick=async e=>{const id=e.target.dataset.delete||e.target.dataset.edit;if(!id)return;const b=state.books.find(x=>x.id===id);if(e.target.dataset.delete){if(!confirm(`確定刪除《${b.title}》？`))return;await req('/api/admin/books/'+id,{method:'DELETE'});toast('書籍已刪除');await load();return}const f=$('#bookForm');for(const k of ['title','author','publisher','pages','category','description'])f.elements[k].value=b[k]||'';f.featured.checked=!!b.featured;f.is_new.checked=!!b.is_new;f.edit_id.value=b.id;$('#formTitle').textContent='編輯書籍';$('#bookModal').classList.add('open')};
'@
$t = $t.Replace($oldClick.Trim(),$newClick.Trim())
[IO.File]::WriteAllText($p,$t,[Text.UTF8Encoding]::new($false))
