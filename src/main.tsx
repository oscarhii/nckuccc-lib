import React from 'react';
import {createRoot} from 'react-dom/client';
import {App} from './App';
import './styles.css';

createRoot(document.getElementById('root')!).render(<React.StrictMode><App/></React.StrictMode>);

function showUpdate(registration:ServiceWorkerRegistration){
  if(document.getElementById('pwa-update'))return;
  const bar=document.createElement('div');
  bar.id='pwa-update';
  bar.innerHTML='<span>圖書館有新版本可用</span><button>立即更新</button><button class="dismiss" aria-label="稍後更新">×</button>';
  bar.querySelector('button')!.addEventListener('click',()=>registration.waiting?.postMessage({type:'SKIP_WAITING'}));
  bar.querySelector('.dismiss')!.addEventListener('click',()=>bar.remove());
  document.body.appendChild(bar);
}

if('serviceWorker' in navigator)addEventListener('load',async()=>{
  const registration=await navigator.serviceWorker.register('/sw.js');
  if(registration.waiting)showUpdate(registration);
  registration.addEventListener('updatefound',()=>{const worker=registration.installing;if(!worker)return;worker.addEventListener('statechange',()=>{if(worker.state==='installed'&&navigator.serviceWorker.controller)showUpdate(registration)})});
  let refreshing=false;navigator.serviceWorker.addEventListener('controllerchange',()=>{if(!refreshing){refreshing=true;location.reload()}});
});
