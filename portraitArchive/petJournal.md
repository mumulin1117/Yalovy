# Yalovy 本地资源图片封装

源码统一放在 `yalovy-content/`，其中入口为 `yalovy-pet-shell.html`，脚本和样式位于 `yalovycheukids/`。开发源码保留用于维护，但不作为明文资源复制进 App。`portraitArchive/annualPortrait.png` 是当前已经生成好的加密彩色图片，并已作为项目资源加入 Xcode；Xcode 构建时只复制这张图片，不会再临时生成。

构建链路：目录中的全部普通文件（含 HTML、JS、CSS、JSON、SVG、图片、视频）→ 保留文件路径与原始字节的二进制 plist → AES-256-GCM（随机 nonce、认证标签）→ Base64 字符串 → RGB 像素 → 无损 PNG。前 8 个 RGB 字节记录字符串长度，后面存放字符串字节。不要缩放、压缩为 JPEG、调色或放进可能优化像素的 Asset Catalog。

加载链路位于 `Yalovy/YearlyGrowthMosaic.swift`。原生层读取 PNG、还原 RGB 字节、解析 Base64、校验 AES-GCM 并解密，在应用缓存目录 `yearlyGrowthMosaic/` 中恢复原来的目录布局：根目录入口、`yalovycheukids/` 脚本及 `yalovy-content/` 资源。继续沿用既有 `loadFileURL`、原生桥接、商品配置、媒体路径和 WebKit 数据存储设置。首次访问恢复资源，同进程后续调用复用目录；下一次进程启动会从安装包重新恢复，适应版本更新及缓存清理。解密后的文件会存在应用私有缓存中。

新增自主标识符使用用户提供的宠物、成长、记录和影像词表（类型采用首字母大写）；Apple API、协议要求的入口和构建系统变量沿用系统名称。

## 修改资源后

修改、新增、移动或删除 `yalovy-content/` 里的资源后，先更新清单：

```sh
./portraitArchive/annualRetrospective.sh
```

然后重新生成项目中使用的加密图片：

```sh
xcrun --sdk macosx swiftc -O -module-cache-path /tmp/yalovy-swift-cache Yalovy/YearlyGrowthMosaic.swift portraitArchive/AnnualPortrait.swift -o /tmp/yalovy-annualPortrait
/tmp/yalovy-annualPortrait yalovy-content portraitArchive/annualPortrait.png
```

每次生成都使用实际运行时解码器逐文件、逐字节比较，校验失败会终止。当前像素缓冲上限为 64 MiB，超过时会明确失败。生成完成后正常 Xcode 构建即可。

## 校验

```sh
xcrun --sdk macosx swiftc -O -module-cache-path /tmp/yalovy-swift-cache Yalovy/YearlyGrowthMosaic.swift portraitArchive/WellnessAssessment.swift -o /tmp/yalovy-wellnessAssessment
/tmp/yalovy-wellnessAssessment
```

覆盖中文和表情、全部字节值、空文件、随机 nonce、截断图片、非法 Base64、越界路径、错误密钥及认证标签篡改。

AES 密钥随客户端分发，因此此方案用于本地资源封装，不能保证密钥或解密资源无法被逆向提取。PNG 不是业务图片，像素内容不应参与视觉编辑。
