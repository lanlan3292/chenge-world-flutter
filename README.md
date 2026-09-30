# ChengeWorld Flutter

面向 Android 的 ChengeWorld 社区客户端，包含账号密码登录、会话安全保存、帖子浏览、好友管理、私聊和商城。界面使用 Flutter Material 3 组件构建，适配手机和平板屏幕。

- 帖子：最新/热门/精华、搜索、分页和 Markdown 详情。
- 社交：好友与聊天共用一个主导航入口，页面内切换；好友支持列表、申请回加/拒绝、用户搜索、备注和解除关系。
- 私聊：好友发起单聊、会话列表、历史记录、文本与表情图片消息、已读和未读；以 8 秒轮询获取新消息。
- 商城：商品分类/关键词/排序、详情、ChengeCoin 余额与购买、已购资产、订单和已购文件下载。
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

登录后 token 存在 Android Keystore 中；访客也可读取公开帖子和商品。聊天、好友申请、钱包、资产、任务领奖和下单需要登录。任务接口为 `/task/list` 和 `/task/claim`；聊天接口为 `/chat/conversations`、`/chat/single`、`/chat/{id}/messages`、`/chat/{id}/send`、`/chat/{id}/read`；商城接口为 `/shop/items`、`/shop/item/{id}`、`/shop/wallet`、`/shop/buy`、`/shop/assets` 和 `/shop/orders`。好友申请接受操作按服务端语义回加对方。
