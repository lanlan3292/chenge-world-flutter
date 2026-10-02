# ChengeWorld Flutter

面向 Android 的 [ChengeWorld](https://gitee.com/bfg-as/chenge-world) 社区客户端，包含账号密码登录、会话安全保存、帖子浏览、好友管理、私聊、AI Agent 和商城。界面使用 Flutter Material 3 组件构建，适配手机和平板屏幕。

- 帖子：最新/热门/精华、搜索、分页和 Markdown 详情。
- 社交：好友、聊天与 **AI** 共用主导航入口，页面内 SegmentedButton 切换。
- 私聊：好友发起单聊、会话列表、历史记录、文本与表情图片消息、已读和未读；以 8 秒轮询获取新消息。
- **AI Agent**：多会话管理、历史加载、`/ai/agent/stream` SSE 流式回复（status / delta / done）。
- 商城：商品分类/关键词/排序、详情、ChengeCoin 余额与购买、已购资产、订单和已购文件下载；发现和商城均支持前后页翻页。
- 我的：右上角设置中退出登录；从个人页进入任务中心。
- 任务：签到、进度查看、任务跳转和手动领取 ChengeCoin 奖励。

API 默认地址为 `http://8.138.13.61`，也可以在启动时覆盖：

```powershell
flutter run --dart-define=CHENGE_API_BASE_URL=http://8.138.13.61
```

## 初始化 Android 工程

安装 Flutter SDK 和 Android SDK 后，在项目目录执行：

```powershell
flutter config --android-sdk D:\fuckgoogle
flutter create --platforms=android --project-name chenge_world_app scaffold
Copy-Item scaffold\android -Destination . -Recurse
Remove-Item scaffold -Recurse -Force
flutter pub get
```

平台脚手架在临时目录生成，只合并 Android 原生目录，不覆盖 `lib/` 中的客户端源码。

生成 Android 工程后，在 `android/app/src/main/AndroidManifest.xml` 的 `<manifest>` 内、`<application>` 前添加 `<uses-permission android:name="android.permission.INTERNET" />`，并在 `<application>` 上添加 `android:usesCleartextTraffic="true"`。当前工作区已配置完成。正式部署建议为服务端启用 HTTPS 后移除明文流量例外。

## 运行与测试

```powershell
flutter devices
flutter run
flutter test
flutter analyze
```

登录后 token 存在 Android Keystore 中；访客也可读取公开帖子和商品。聊天、好友申请、钱包、资产、任务领奖、下单和 **AI Agent** 需要登录。

- 任务：`/task/list`、`/task/claim`
- 聊天：`/chat/conversations`、`/chat/single`、`/chat/{id}/messages`、`/chat/{id}/send`、`/chat/{id}/read`
- 商城：`/shop/items`、`/shop/item/{id}`、`/shop/wallet`、`/shop/buy`、`/shop/assets`、`/shop/orders`
- AI：`/chatSession/list/my`、`/chatSession/create`、`/chatSession/delete/{id}`、`/chatSession/getchat`、`/chatSession/rename`、`/ai/agent/stream`（SSE）

好友申请接受操作按服务端语义回加对方。
