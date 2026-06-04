<div align="center">

# 🌱 Carbon-Calculation

**一款跨平台的碳排計算機,把「我該減碳」變成每日習慣。**

幾秒記錄每日 CO₂e、執行引導式低碳行動、解鎖徽章,並向內建 AI 助手詢問建議 — 以 Flutter + Firebase 打造,支援 iOS 與網頁。

![Flutter](https://img.shields.io/badge/Flutter-stable-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Backend-Firebase-FFCA28?logo=firebase&logoColor=black)
![AI](https://img.shields.io/badge/AI-OpenAI%20GPT--3.5%20fine--tuned-412991?logo=openai&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Web-success)
![License](https://img.shields.io/badge/License-MIT-yellow)

[English](README.md) | **繁體中文**

<table>
  <tr>
    <td align="center"><img src="assets/screenshots/home.png" width="180"><br><sub>首頁</sub></td>
    <td align="center"><img src="assets/screenshots/actions.png" width="180"><br><sub>行動</sub></td>
    <td align="center"><img src="assets/screenshots/aichat.png" width="180"><br><sub>AI 聊天</sub></td>
    <td align="center"><img src="assets/screenshots/social.png" width="180"><br><sub>社群</sub></td>
  </tr>
</table>

</div>

---

## 📖 關於專案

多數人想降低碳足跡,卻沒有簡單的方法量測 — 手動查碳排係數太繁瑣,於是始終沒有開始。

Carbon-Calculation 消除這道門檻。五大分頁 — **社群、首頁、行動、成就、個人** — 帶你從「量測」走到「減量」:記錄活動、用日曆檢視 CO₂e,並逐步完成飲食、居家、辦公、戶外的低碳行動。AI 助手把一句話換算成碳排,徽章與排行榜則讓減碳成為習慣。

### 主要功能

- **碳足跡計算機** — 估算個人 CO₂e,並以 `fl_chart` / Syncfusion 圖表呈現。
- **引導式行動** — 飲食 / 居家 / 辦公 / 戶外四類,各有清單、卡片與細節頁。
- **AI 助手** — 由微調後的 OpenAI GPT-3.5 驅動的內建聊天。
- **遊戲化** — 徽章、成就、點數商店與優惠券。
- **社群動態** — 貼文、按讚、留言、好友與碳排排行榜。
- **多種登入方式** — Email、Google、Apple、GitHub、匿名,皆透過 Firebase Auth。
- **後台管理** — 儀表板、會員管理、貼文審核、商店管理。
- **跨平台** — 單一 Flutter 程式碼庫同時出貨 iOS 與網頁。

---

## 👤 我的負責範圍

> 大學畢業專題 · 5 人團隊

我獨立負責以下模組:

- **登入驗證**(`lib/auth`、`lib/login`)— 多種登入方式:Email、Google、Apple、GitHub、匿名,透過 Firebase Auth。
- **首頁日曆**(`lib/pages/home`)— 記錄並彙總每日 CO₂e 的日曆。
- **碳排計算機**(`lib/pages/calculator`)— 簡易碳足跡計算機。
- **點數獎勵**(`lib/personalpage/shop`、`lib/flutter_flow/coupon_page.dart`)— 點數商店與優惠券系統。

---

## 💡 對使用者的價值

- **幾秒記錄,免查表** — 對 AI 助手說*「開車 50 公里、吃 1 公斤牛排、用 3 度電」*,立刻回傳你的 CO₂e,不必手動查碳排係數。
- **一鍵行動** — 四大類精選行動,把「我要減碳」化為可直接記錄的具體步驟。
- **看見趨勢** — 日曆追蹤每日 CO₂e,進步或暴增一眼看清。
- **持續動力** — 徽章、成就與好友排行榜,讓減碳成為習慣。

---

## 🛠 技術棧

**Flutter**(Dart 3)· **Firebase**(Auth · Firestore · Storage · Cloud Functions)· **OpenAI** GPT-3.5(微調)· 以 **FlutterFlow** 建構 · `go_router` · `provider` · `fl_chart` / Syncfusion。

---

## 🏗 架構

Flutter 客戶端(iOS + web)以 Firebase 處理登入、資料(Firestore)與檔案儲存。AI 請求不直接呼叫 OpenAI:App 帶著使用者的 Firebase ID token 呼叫 Cloud Function(`chatCompletion`),由它驗證後以伺服器端金鑰轉發 — 因此沒有任何 API 金鑰隨 App 出貨。

```
Flutter app  ──►  Firebase Auth / Firestore / Storage
     │
     └── Firebase ID token ──►  Cloud Function (chatCompletion)  ──►  OpenAI API
                                  驗證 token、注入金鑰
```

---

## 📂 專案結構

```
CO2e/
├── lib/
│   ├── main.dart                 # App 進入點、Firebase 初始化、根導覽
│   ├── auth/                     # Firebase 登入(email/google/apple/github/匿名)
│   ├── backend/                  # Firestore schema、Storage、API 呼叫
│   ├── pages/                    # 核心功能畫面
│   │   ├── home/  social/  achievement/  calculator/
│   │   ├── action/               # 行動 + diet/house/office/outdoor 選項
│   │   └── badge/                # 徽章與解鎖流程
│   ├── chatgpt/                  # 內建 AI 助手
│   ├── admin_home/               # 後台儀表板 / 會員 / 貼文 / 商店
│   ├── personalpage/             # 個人頁、編輯、好友、商店、說明
│   └── flutter_flow/             # FlutterFlow 主題、元件、導覽、商店/購物車
├── firebase/                     # Firestore 規則/索引、Storage 規則、Functions
│   └── functions/                # onUserDeleted + chatCompletion(OpenAI proxy)
├── ios/   ·   web/   ·   test/
└── pubspec.yaml
```

---

## 📫 聯絡

**poweichen00** — [GitHub](https://github.com/poweichen00) · [專案 repository](https://github.com/poweichen00/Carbon-Calculation)

---

## 📄 授權

以 [MIT License](LICENSE) 釋出。碳排係數與第三方圖示素材保留其原始授權。
