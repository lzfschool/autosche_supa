# 拔河賽自動賽程表（Supabase 版）

與 [lzfschool/autosche](https://github.com/lzfschool/autosche)（Firebase 版）程式完全相同，只差在雲端同步改用 **Supabase**，方便兩種環境比較。

- 網頁：`https://lzfschool.github.io/autosche_supa/`
- 觀眾唯讀：`https://lzfschool.github.io/autosche_supa/?view=1`

## 檔案說明

| 檔案 | 用途 |
|---|---|
| `index.html` | 主程式（與 Firebase 版相同） |
| `supabase-config.js` | Supabase 連線設定（Project URL ＋ anon / publishable key） |
| `supabase-setup.sql` | 建立資料表、權限、Realtime 的 SQL |
| `firebase-config.js` | 本版保持 `null`（不使用 Firebase） |
| `.github/workflows/supabase-keepalive.yml` | **每日喚醒**：每天台灣時間 08:00 寫入一次資料庫，避免免費專案因 7 天閒置被暫停 |
| `tournament_data.json` | 初始賽程資料 |

## 設定步驟

1. 到 <https://supabase.com/dashboard> 建立專案（Region 建議選 Singapore）。
2. 左側 **SQL Editor** → 貼上 `supabase-setup.sql` 全部內容 → **Run**。
3. **Project Settings → API**（或 Data API / API Keys）複製：
   - Project URL（`https://xxxx.supabase.co`）
   - anon public key（或 `sb_publishable_...`）
4. 把兩個值填進 `supabase-config.js`，push 到 GitHub。
5. **Settings → Pages**：Source 選 `main` / `(root)`。
6. **Actions** 分頁 → 選「Supabase 每日喚醒」→ **Run workflow** 手動跑一次，確認是綠勾。

## 每日喚醒說明

- Supabase 免費方案約 7 天沒有活動就會暫停專案，需要到主控台手動恢復。
- `supabase-keepalive.yml` 每天自動寫入 `keepalive` 表一次，保持專案啟用。
- GitHub 會停用「60 天沒有 commit」的 repo 的排程，因此 workflow 在距上次 commit 滿 50 天時會自動補一個空 commit。

## 安全提醒

資料表允許任何持有 anon key 的人讀寫（與 Firebase 版規則相同）。觀眾請一律分享 `?view=1` 唯讀網址。
