# 宠物vlog社区 (Pet Daily Vlog) — 开发交接包

移动端宠物社交 App，共 **43 个界面**：图文/视频(Vlog)发布、金币付费发布视频、互相关注才能私信、举报/拉黑等社区安全机制。

## 目录结构
```
dev_package_pet_daily_vlog/
├─ src/
│  ├─ Pet Daily Vlog.dc.html   # 设计源（43 屏 + 全部交互逻辑，唯一真源）
│  ├─ support.js               # 原型运行时（本地预览用）
│  └─ assets/
│     ├─ img/                  # 宠物图 pet-1..16.png、头像 avatar-17..32.png
│     ├─ coin.png / coin-sm.png# 金币位图
│     └─ icons/                # 35 个 SVG 开发图标（currentColor）
├─ assets-icons-preview.html   # 图标对照表
└─ README.md（本文件）
```

> 图片均以普通相对路径直接引用，例如 `<img src="assets/img/pet-1.png">`、`<img src="assets/img/avatar-17.png">`，不使用 blob: / data: URL，方便开发替换与打包。

## 关于这些文件
`src/Pet Daily Vlog.dc.html` 是 **在 HTML 中制作的高保真设计参考稿**，表达最终外观与交互，**不是生产代码**。开发任务：在目标工程既有环境（React / Vue / SwiftUI / 原生等）按其规范 **重新实现**；若无环境则选合适框架从零搭建。请勿直接搬运原型 HTML 上线。
- 本地预览：浏览器直接打开 `src/Pet Daily Vlog.dc.html`（需与 `support.js`、`assets/` 同目录）。
- 保真度：**高保真**，颜色/字号/间距/圆角/交互均为最终值，请像素级还原。

## 设计 Token
| Token | 值 | 用途 |
|---|---|---|
| 主色 Lime | `#C6F53C` | 主按钮/选中/强调；主推卡 `#C4F03A` |
| 背景 | `#141414`（深色页 `#0E0F10`） | App 背景 |
| 卡片/输入 | `#26282B`；深底 `#1a1b1d` | 表面 |
| 文字 | `#FFFFFF` / 次 `#8a8d86` / 暗 `#5f6a58` | |
| 状态标签 | 绿 `#7FD08A` on `#1d3a22` | 宠物状态 |
| 心情标签 | 紫 `#b7a6d6` on `#2e2748` | 心情 |
| 内容类型 | 图文 `#4f8a2e`/`#E7F3D8`、视频 `#7A5CC4`/`#EDE6F7` | |
| 金币金 | `#F2C94C`；危险 `#E8654E`/`#3a2020` | |
| 层叠卡 | 蓝 `linear-gradient(158deg,#99D3EF,#6BB4E4)`、紫 `…#CBB6EE,#AC90DD` | 首页 |

- 字体：系统 UI；标题 `.blk` 800 粗；画布基准 **375×812**。
- 圆角：小 12–16 / 卡片 18–24 / 大卡 30 / 胶囊 999；卡片阴影 `0 22px 46px rgba(0,0,0,.45)`。
- 底部 Tab（全局统一 5 项）：Home · Square · Create(凸起 lime +) · Album · My，选中项下方 5px lime 圆点。

## 43 屏清单
引导账号：1 Splash / 2 Login / 3 Sign Up / 4 Permission
核心发布：5 Home / 6 Create / 7 Photo Editor / 8 Video Editor / 9 Coin Dialog / 10 Photo OK / 11 Video OK / 12 Not Enough Coins
广场详情：13 Square / 14 Post Detail / 15 Video Detail / 16 Search
社交安全：17 Profile(未互关) / 18 Report / 19 Report OK / 20 Block / 35 Profile(等待互关) / 36 Profile(已互关) / 37 Followers / 38 Following / 39 Chat Locked / 40 Chat List / 41 Chat Detail / 42 Video Call
我的内容：21 My Album / 22 My Post Detail / 23 Edit Post / 24 Delete / 25 My
钱包设置：26 Coin Store / 27 Purchase OK / 28 Coin History / 29 Settings / 30 Edit Profile / 31 Blocked / 32 Terms / 33 Privacy / 34 About / 43 Tag Library

## 关键交互
- **首页主推卡**：可滑动层叠卡组（stacked deck）——整卡随手指拖动、前卡滑走、右侧层叠卡前移；松手按方向吸附（阈值 ±55px）；短点(位移<8px)进详情；5 张循环右侧恒留 2 张；每 ~3.6s 自动前进、拖动暂停；过渡 `.5s cubic-bezier(.22,.61,.36,1)`。
- **Like/Save**：点击切换选中态（填充 lime、图标实心、Like 计数 328↔329、Save↔Saved）。
- **付费闭环**：Video Editor → Coin Dialog（够→扣 20→成功 / 不够→Not Enough Coins→Coin Store→购买成功）。
- **社交门禁**：Message 仅「已互关」解锁，否则进 Chat Locked；Follow 流转 none→pending→mutual。
- **举报/拉黑**：详情/主页右上三点 → Report → Block This User → 确认。删除走二次确认。

## 建议状态
`auth` / `coins`(视频-20, 购买+, coinHistory[]) / `relationship(userId): none|pending|mutual|blocked`(驱动 Message 锁与私信可见) / `post.liked/saved` / `home.featuredIndex`+轮播 / `blockedUsers[]`。

## 资源
- `src/assets/img/` 宠物图 16 张 + 头像 16 张（原型 `IMG(n)/AVA(n)` 引用 `assets/img/pet-n.png`、`avatar-n.png`）。
- `src/assets/icons/` 35 个 SVG（Bootstrap Icons，MIT，currentColor 换色），见 `assets-icons-preview.html`。
- `src/assets/coin*.png` 金币位图。
