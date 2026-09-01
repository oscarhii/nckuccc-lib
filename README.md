# NCKU CCC Library PWA

成功大學學園團契圖書館的跨裝置 PWA。前端採 React + TypeScript，後端與排程採 Cloudflare Workers，D1 儲存書籍、借閱和心得，R2 儲存封面。

## 已包含

- 電腦、iPad、手機獨立響應式 layout，可安裝為 PWA
- 最新上架、管理員推薦、書名／作者搜尋、繁中注音 collation 排序
- 暱稱辨識；借書時另填真實姓名；30 天到期；一鍵還書
- 管理員新增書籍、拍照或上傳封面、瀏覽器端壓縮成 WebP
- D1 schema 已預留心得、1–5 星評價及 Web Push subscription
- R2 私有 bucket 經 Worker 安全讀取，不需公開 bucket

## 本機啟動

```bash
npm install
npm run db:migrate:local
npm run dev
```

若要讓 Vite 開發環境同時連 Worker API，建議直接使用 `npm run build` 後執行 `npx wrangler dev`。未連 D1 時前台會顯示示範書籍。

## 第一次 Cloudflare 設定

1. 建立 Cloudflare 帳戶，安裝 Node.js 20+，執行 `npx wrangler login`。
2. 建立 D1：`npx wrangler d1 create ncku-ccc-library`，把輸出的 database ID 貼進 `wrangler.jsonc`。
3. 建立 R2：`npx wrangler r2 bucket create ncku-ccc-book-covers`。
4. 初始化正式資料庫：`npm run db:migrate:remote`。
5. 不要把正式密碼寫進 Git。刪除 `wrangler.jsonc` 的 `ADMIN_TOKEN` vars 後，執行 `npx wrangler secret put ADMIN_TOKEN`。
6. `npm run deploy` 測試正式部署。

## GitHub 自動部署

1. 在 GitHub 建立空 repository。
2. 本機執行 `git init`、`git add .`、`git commit -m "Initial NCKU CCC Library PWA"`，再依 GitHub 畫面加入 remote 並 push。
3. Cloudflare Dashboard → Workers & Pages → Create → Import a repository。
4. Build command 填 `npm run build`，deploy command 填 `npx wrangler deploy`。
5. Cloudflare 專案環境變數加入 `ADMIN_TOKEN` secret。D1/R2 binding 由 `wrangler.jsonc` 管理。

## 無帳號與提醒的建議方案

暱稱留在裝置的 localStorage，不能視為身分驗證，重裝或換手機也會遺失。因此正式版建議：借閱仍只填真實姓名，但首次借閱自動產生一組「借閱卡復原碼」，用雜湊存於 D1；裝置用此碼綁定借閱紀錄。提醒則讓使用者在自己的手機按「允許通知」，把該裝置的 Web Push subscription 綁到借閱卡，而不是綁名字。這樣不需要帳號密碼，也不會因同名而看錯紀錄。

目前 service worker 已具備接收推播能力，D1 也有 subscription 表；實際發送尚需 VAPID 公私鑰、訂閱 API 和排程簽章。也建議提供可選 Email／LINE Notify 類替代提醒，因 iPhone 必須先把 PWA 加到主畫面後才可開 Web Push。

## 上線前仍要完成

- 將「暱稱查詢借閱」升級成借閱卡復原碼，避免同名或猜名字看到紀錄
- 管理員完整列表、編輯／刪除 UI（刪除 API 已有）
- 評價填寫與展示 UI（新增 API 與資料表已有）
- 條碼掃描：使用手機 `BarcodeDetector`，不支援時退回手動輸入 ISBN
- Web Push VAPID 發送與到期前 7、3、1 天排程
- 管理員登入速率限制；正式環境建議 Cloudflare Access 或一次性登入，而非共用密碼

## 需要團契提供

- 團契 Logo、偏好的主色／字體（目前使用深綠與暖金）
- 首批書目（Excel/CSV 即可）與封面照片；至少需要書名
- 管理員 Email 名單與想採用的登入方式
- 提醒策略：到期前幾天、是否逾期後繼續提醒、是否加 Email
- GitHub repository 權限、Cloudflare 帳戶與預計網域
- 借閱隱私告知文字，以及借閱資料保留多久

## 維護選型

TypeScript 前後端共用一種語言，社群與套件成熟；React 適合互動式 PWA；Cloudflare 的 Worker + D1 + R2 是免主機維運、用量小時成本低的組合。資料量增加後仍可把 D1 換成 PostgreSQL，而不用重寫畫面。
