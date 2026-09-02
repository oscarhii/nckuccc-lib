$source=Resolve-Path 'public/admin-v3.html';$target=Join-Path(Split-Path $source)'admin-v4.html';$t=[IO.File]::ReadAllText($source)
$t=$t.Replace(' value="oscarhiishanmin26@gmail.com"','')
$t=$t.Replace('<div class="error" id="loginError"></div>','<div class="error" id="loginError"></div><button type="button" id="forgot" style="border:0;background:none;color:#37614b;padding:6px 0">忘記密碼？</button>')
$t=$t.Replace('<button data-tab="settings">網站設定</button>','<button data-tab="settings">網站設定</button><button data-tab="team">管理員</button><button data-tab="account">我的密碼</button>')
$panels=@'
<section class="panel" id="team"><div class="card"><h2>新增管理員</h2><p class="muted">新帳號預設密碼為 000000，首次登入後必須更改。</p><form id="adminForm" class="toolbar"><input name="email" type="email" placeholder="管理員 Email" required><button class="primary">新增管理員</button></form></div><div class="card"><h2>管理員名單</h2><div class="table-wrap"><table><thead><tr><th>Email</th><th>權限</th><th>密碼狀態</th><th>操作</th></tr></thead><tbody id="adminRows"></tbody></table></div><h3>待處理的密碼重設</h3><div id="resetRows"></div></div></section>
<section class="panel" id="account"><form class="card settings" id="passwordForm"><h2>更改我的密碼</h2><label class="field">目前密碼<input name="currentPassword" type="password" required></label><label class="field">新密碼<input name="newPassword" type="password" minlength="8" required><small class="muted">至少 8 個字元</small></label><button class="primary">更新密碼</button></form></section>
'@
$t=$t.Replace('</main></section>',$panels.Trim()+'</main></section>')
$logic=@'
function renderTeam(){const admins=state.admins||[],resets=state.resets||[];$('#adminRows').innerHTML=admins.map(a=>`<tr><td><b>${esc(a.email)}</b></td><td>${a.role==='superadmin'?'最高管理員':'管理員'}</td><td>${a.mustChange?'需更改':'正常'}</td><td class="actions">${a.role==='superadmin'?'不可刪除':`<button class="danger" data-admin-delete="${esc(a.email)}">刪除</button>`}</td></tr>`).join('');$('#resetRows').innerHTML=resets.length?resets.map(r=>`<p>${esc(r.email)} <button class="primary" data-reset="${r.id}">重設為 000000</button></p>`).join(''):'<p class="muted">目前沒有待處理申請</p>'}
$('#forgot').onclick=async()=>{const email=$('#email').value.trim();if(!email){$('#loginError').textContent='請先輸入 Email';return}const x=await req('/api/admin/forgot',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({email})});$('#loginError').textContent=x.message};
$('#adminForm').onsubmit=async e=>{e.preventDefault();try{await req('/api/admin/admins',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({email:e.target.email.value})});e.target.reset();toast('管理員已新增，預設密碼 000000');await load()}catch(x){toast(x.message)}};
$('#adminRows').onclick=async e=>{const email=e.target.dataset.adminDelete;if(!email)return;if(!confirm(`確定停用 ${email}？`))return;await req('/api/admin/admins/'+encodeURIComponent(email),{method:'DELETE'});toast('管理員已停用');await load()};$('#resetRows').onclick=async e=>{const id=e.target.dataset.reset;if(!id)return;await req('/api/admin/resets/'+id,{method:'POST'});toast('密碼已重設為 000000');await load()};
$('#passwordForm').onsubmit=async e=>{e.preventDefault();try{await req('/api/admin/change-password',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify(Object.fromEntries(new FormData(e.target)))});e.target.reset();toast('密碼已更新')}catch(x){toast(x.message)}};
'@
$t=$t.Replace('function render(){','function render(){renderTeam();')
$t=$t.Replace('start();</script>',$logic.Trim()+'start();</script>')
[IO.File]::WriteAllText($target,$t,[Text.UTF8Encoding]::new($false))
