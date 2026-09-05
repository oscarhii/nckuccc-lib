$path='src/App.tsx';$app=Get-Content -Raw -Encoding UTF8 $path
$borrowStart=$app.IndexOf('const borrow=async(b:B)=>')
$reserveStart=$app.IndexOf('const reserve=async(b:B)=>',$borrowStart)
if($borrowStart -ge 0 -and $reserveStart -gt $borrowStart){$app=$app.Remove($borrowStart,$reserveStart-$borrowStart)}
$renewStart=$app.IndexOf('const renew=async(id:string)=>')
$returnEnd=$app.IndexOf(';',$app.IndexOf('await refresh()}catch(e){setMsg((e as Error).message)}}',$renewStart))+1
if($renewStart -ge 0 -and $returnEnd -gt $renewStart){$app=$app.Remove($renewStart,$returnEnd-$renewStart)}
$app=$app.Replace(' borrow={borrow}','')
$app=$app.Replace(',borrow,reserve,notify',',reserve,notify')
$app=$app.Replace(';borrow:(b:B)=>void','')
$app=$app.Replace('掃描借書','掃描書籍')
Set-Content -LiteralPath $path -Value $app -Encoding UTF8
