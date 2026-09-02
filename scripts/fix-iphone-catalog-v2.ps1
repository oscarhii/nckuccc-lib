$p=Resolve-Path 'src/AppV3.tsx';$t=[IO.File]::ReadAllText($p)
$t=$t.Replace("[notify,setNotify]=useState(Notification.permission==='granted')","[notify,setNotify]=useState(typeof Notification!=='undefined'&&Notification.permission==='granted')")
$t=$t.Replace(",[name,setName]=useState(localStorage.getItem('ccc-name')||'');",",[name,setName]=useState(localStorage.getItem('ccc-name')||''),[group,setGroup]=useState('');")
$t=$t.Replace('const shown=useMemo','useEffect(()=>setGroup(''''),[sort]);const shown=useMemo')
$old='<div className="grouped">{Object.entries(grouped).map'
$new='<div className="dictionary-index"><button className={!group?''on'':''} onClick={()=>setGroup('''')}>全部</button>{Object.keys(grouped).map(g=><button className={group===g?''on'':''} onClick={()=>setGroup(g)}>{g}</button>)}</div><div className="grouped">{Object.entries(grouped).filter(([g])=>!group||g===group).map'
$t=$t.Replace($old,$new)
$t=$t.Replace('<main>{msg&&','{menu&&<button className="drawer-overlay" aria-label="關閉選單" onClick={()=>setMenu(false)}/>}<main>{msg&&')
[IO.File]::WriteAllText($p,$t,[Text.UTF8Encoding]::new($false))
$p=Resolve-Path 'src/v3.css';$t=[IO.File]::ReadAllText($p);$extra=@'
.dictionary-index{display:flex;flex-wrap:wrap;gap:7px;margin:16px 0 5px;padding:14px;background:#eee9df;border-radius:14px}.dictionary-index button{min-width:38px;border:0;background:#fff;color:#40564a;border-radius:8px;padding:8px 10px}.dictionary-index button.on{background:#b26c3e;color:#fff}.drawer-overlay{display:none}.close{color:#fff!important;background:transparent!important;border:0!important}
@media(max-width:700px){.drawer-overlay{display:block;position:fixed;z-index:8;inset:0;border:0;background:#071a1299}.dictionary-index{flex-wrap:nowrap;overflow-x:auto;padding:10px}.dictionary-index button{flex:0 0 auto}body:has(aside.open){overflow:hidden}.close{box-shadow:none!important}}
'@;if($t-notmatch'dictionary-index'){[IO.File]::WriteAllText($p,$t+$extra,[Text.UTF8Encoding]::new($false))}
