# ChengeWorld Flutter

ChengeWorld 社区的 Flutter 客户端。项目采用 Flutter + Material 3 构建，当前主要围绕 Android 使用场景开发，同时仓库保留了 iOS、Linux 和 Windows 的 Flutter 工程目录。

> 项目定位：为 ChengeWorld 提供帖子、社交、AI、商城和任务等功能的移动端/桌面端客户端。

## 功能

### 社区
- 浏览最新、热门、精华帖子
- 关键词搜索与分页
- Markdown 帖子详情
- 游客可浏览公开帖子

### 社交与聊天
- 好友列表与好友申请
- 单聊会话与历史消息
- 文本、表情和图片消息
- 已读/未读状态
- 聊天消息通过轮询获取更新

### AI Agent
- 创建、删除、重命名 AI 会话
- 加载历史对话
- 支持 `/ai/agent/stream` SSE 流式响应
- 处理 `status`、`delta`、`done` 等事件

### 商城
- 商品分类、关键词搜索和排序
- 商品详情
- ChengeCoin 余额查询
- 商品购买
- 已购资产与订单
- 已购文件下载
- 商品列表支持分页

### 任务与个人中心
- 签到
- 查看任务进度
- 从个人页进入任务中心
- 任务跳转
- 手动领取 ChengeCoin 奖励
- 账户退出登录

## 技术栈

- Flutter / Dart
- Material 3
- `http`：HTTP API
- `flutter_secure_storage`：安全保存登录凭据
- `flutter_markdown`：Markdown 渲染
- `shared_preferences`：本地偏好设置
- `dynamic_color`：动态配色
- `url_launcher`：外部链接跳转

Dart SDK 要求：

```text
>=3.7.0 <4.0.0
```

## 开发环境

请先安装：

- Flutter SDK（stable channel）
- Android SDK（Android 开发时）
- 对应平台的开发工具链

检查环境：

```bash
flutter doctor
flutter devices
```

## 快速开始

克隆项目后，在项目根目录执行：

```bash
flutter pub get
flutter run
```

运行测试和静态检查：

```bash
flutter test
flutter analyze
```

如果需要指定设备，可以先查看设备列表：

```bash
flutter devices
flutter run -d <device-id>
```

## API 配置

默认 API 地址：

```text
http://8.138.13.61
```

可以通过 `CHENGE_API_BASE_URL` 在启动时覆盖：

```bash
flutter run --dart-define=CHENGE_API_BASE_URL=http://8.138.13.61
```

例如连接本地或测试服务：

```bash
flutter run --dart-define=CHENGE_API_BASE_URL=http://127.0.0.1:8080
```

> 当前默认地址使用 HTTP。Android 工程已经开启 `android:usesCleartextTraffic="true"` 以支持该配置。生产环境建议服务端启用 HTTPS，并关闭明文 HTTP 流量。

## 登录与权限

登录凭据会通过 Android Keystore 对应的安全存储能力保存。

无需登录即可使用的主要功能：
- 公开帖子浏览
- 公开商品浏览

需要登录的功能包括：
- 好友与好友申请
- 私聊
- 钱包与资产
- 商品购买与订单
- 任务奖励领取
- AI Agent

好友申请的接受操作遵循服务端语义，会同时回加对方。

## 主要 API

### 任务

- `/task/list`
- `/task/claim`

### 聊天

- `/chat/conversations`
- `/chat/single`
- `/chat/{id}/messages`
- `/chat/{id}/send`
- `/chat/{id}/read`

### 商城

- `/shop/items`
- `/shop/item/{id}`
- `/shop/wallet`
- `/shop/buy`
- `/shop/assets`
- `/shop/orders`

### AI 会话

- `/chatSession/list/my`
- `/chatSession/create`
- `/chatSession/delete/{id}`
- `/chatSession/getchat`
- `/chatSession/rename`
- `/ai/agent/stream`（SSE）

## 项目结构

```text
.
├── android/       # Android 工程
├── ios/           # iOS 工程
├── linux/         # Linux 工程
├── windows/       # Windows 工程
├── assets/        # 静态资源
├── lib/
│   ├── models/    # 数据模型
│   ├── screens/   # 页面
│   ├── services/  # API 与业务服务
│   ├── theme/     # 主题
│   ├── widgets/   # 通用组件
│   └── main.dart  # 应用入口
└── test/          # 测试
```

## Android 说明

Android 权限及 Flutter Embedding 配置已经包含在仓库中，正常情况下不需要再执行 `flutter create` 或手动复制 `android/` 目录。

如果重新生成或升级 Android 工程，请确认：

- `android/app/src/main/AndroidManifest.xml` 包含 INTERNET 权限
- 如果 API 仍使用 HTTP，需要保留 `android:usesCleartextTraffic="true"`
- 切换到 HTTPS 后，建议移除明文流量配置

## 相关项目

服务端项目：[ChengeWorld](https://gitee.com/bfg-as/chenge-world)

## License

当前仓库未在根目录声明独立 License。使用或二次分发前，请先确认项目维护者的授权范围。
