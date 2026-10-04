// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get communityTitle => 'ChengeWorld 社区广场';

  @override
  String get discover => '发现';

  @override
  String get social => '社交';

  @override
  String get store => '商城';

  @override
  String get account => '我的';

  @override
  String get settings => '设置';

  @override
  String get appearance => '外观';

  @override
  String get themeMode => '主题模式';

  @override
  String get followSystem => '跟随系统';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get language => '语言';

  @override
  String get localeZhCn => '中文（中国）';

  @override
  String get localeZhTw => '中文（台湾）';

  @override
  String get localeEnUs => '英语（美国）';

  @override
  String get dynamicColor => '动态取色';

  @override
  String get dynamicColorDescription => '使用 Android 12+ 壁纸配色（Material You）';

  @override
  String get themeColor => '主题色';

  @override
  String get systemBars => '系统栏';

  @override
  String get statusBarImmersive => '状态栏沉浸';

  @override
  String get statusBarDescription => '内容延伸至状态栏下方，状态栏透明';

  @override
  String get navigationBarImmersive => '导航栏沉浸';

  @override
  String get navigationBarDescription => '内容延伸至导航栏下方，导航栏透明';

  @override
  String get scrollBehavior => '滚动行为';

  @override
  String get autoHideTopBar => '自动隐藏顶栏';

  @override
  String get autoHideTopDescription => '在发现 / 商城向下滚动时收起页面顶栏（默认开启）';

  @override
  String get autoHideBottomBar => '自动隐藏底栏';

  @override
  String get autoHideBottomDescription => '在发现 / 商城向下滚动时收起底部导航；宽屏侧边栏不会隐藏';

  @override
  String get chat => '聊天';

  @override
  String get showSelfAvatar => '在会话聊天显示自己的头像';

  @override
  String get showSelfAvatarDescription => '自己发送的消息右侧显示头像（默认关闭）';

  @override
  String get showPeerAvatar => '在私人会话聊天显示对方的头像';

  @override
  String get showPeerAvatarDescription => '私聊中对方消息左侧显示头像；群聊始终显示成员头像（默认关闭）';

  @override
  String get systemGestures => '系统手势';

  @override
  String get predictiveBack => '预见式返回';

  @override
  String get predictiveBackDescription => 'Android 13+ 页面过渡使用预见式返回动画（默认关闭）';

  @override
  String get layout => '布局';

  @override
  String get feedColumns => '发现页列数范围';

  @override
  String get shopColumns => '商店页列数范围';

  @override
  String columnRange(int min, int max) {
    return '当前：$min – $max 列（宽度足够时在此范围内自适应）';
  }

  @override
  String minimumColumns(int count) {
    return '最小 $count';
  }

  @override
  String maximumColumns(int count) {
    return '最大 $count';
  }

  @override
  String postCount(int count) {
    return '$count 篇';
  }

  @override
  String pageCount(int page, int total) {
    return '第 $page / $total 页';
  }

  @override
  String itemCount(int count) {
    return '$count 件商品';
  }

  @override
  String get rightNow => '此刻在聊';

  @override
  String get freshDiscussions => '看看社区里的新鲜讨论';

  @override
  String get searchPostsAndTopics => '搜索帖子和话题';

  @override
  String get search => '搜索';

  @override
  String get refreshPosts => '刷新帖子';

  @override
  String get latest => '最新';

  @override
  String get popular => '热门';

  @override
  String get featured => '精华';

  @override
  String get noPosts => '暂时没有帖子';

  @override
  String get noPostsHint => '换个关键词或稍后再来看看';

  @override
  String get retry => '重试';

  @override
  String get previousPage => '上一页';

  @override
  String get nextPage => '下一页';

  @override
  String get signOut => '退出登录';

  @override
  String get confirmSignOut => '确定退出当前 ChengeWorld 账户？';

  @override
  String get cancel => '取消';

  @override
  String get exit => '退出';

  @override
  String get signedOut => '已退出登录';

  @override
  String get accountSettingsSignIn => '登录后可管理账户设置';

  @override
  String get signedIn => '已登录';

  @override
  String get welcome => '欢迎来到社区';

  @override
  String get accountConnected => '账户已连接到 ChengeWorld';

  @override
  String get signInForPersonalized => '登录后浏览个性化内容';

  @override
  String get taskCenter => '任务中心';

  @override
  String get taskCenterDescription => '签到、完成任务并领取 ChengeCoin';

  @override
  String get signIn => '登录';

  @override
  String get signInAccount => '登录账户';

  @override
  String get signInSuccess => '登录成功';

  @override
  String get signInToChengeWorld => '登录 ChengeWorld';

  @override
  String get username => '用户名';

  @override
  String get enterUsername => '请输入用户名';

  @override
  String get password => '密码';

  @override
  String get showPassword => '显示密码';

  @override
  String get hidePassword => '隐藏密码';

  @override
  String get enterPassword => '请输入密码';

  @override
  String get signingIn => '正在登录';

  @override
  String get contacts => '通讯录';

  @override
  String get productDetails => '商品详情';

  @override
  String get post => '帖子';

  @override
  String get shopNow => '逛商城';

  @override
  String get myAssets => '我的资产';

  @override
  String get orders => '订单';

  @override
  String get discoverItems => '发现好物';

  @override
  String get searchProducts => '搜索商品';

  @override
  String get sortProducts => '排序商品';

  @override
  String get newestArrivals => '最新上架';

  @override
  String get popularProducts => '热门商品';

  @override
  String get priceLowToHigh => '价格从低到高';

  @override
  String get priceHighToLow => '价格从高到低';

  @override
  String get ratingFirst => '评分优先';

  @override
  String get all => '全部';

  @override
  String get files => '文件';

  @override
  String get emojiPacks => '表情包';

  @override
  String get components => '组件';

  @override
  String get applications => '应用';

  @override
  String get executables => '可执行';

  @override
  String get libraries => '类库';

  @override
  String get functionLibraries => '函数库';

  @override
  String get noAssetsOrOrdersSignIn => '登录后查看资产与订单';

  @override
  String get goSignIn => '前往登录';

  @override
  String get shopUnavailable => '商城暂时不可用';

  @override
  String get checkNetworkAndRetry => '检查网络后重试';

  @override
  String get noProducts => '暂时没有商品';

  @override
  String get tryOtherSearch => '试试其他关键词或分类';

  @override
  String get noAssets => '还没有资产';

  @override
  String get noOrders => '还没有订单';

  @override
  String get purchasesShowHere => '在商城购买的内容会显示在这里';

  @override
  String get refresh => '刷新';

  @override
  String get refreshTasks => '刷新任务';

  @override
  String get claimComplete => '去完成';

  @override
  String rewardClaimed(String coins) {
    return '奖励已领取，+$coins CC';
  }

  @override
  String get productPurchaseSuccess => '购买成功，已加入资产清单';

  @override
  String get signInToLike => '登录后即可点赞';

  @override
  String get signInToComment => '登录后即可发表评论';

  @override
  String get commentPublished => '评论已发表';

  @override
  String get noComments => '还没有评论';

  @override
  String get back => '返回';

  @override
  String commentCount(int count) {
    return '评论 · $count';
  }

  @override
  String get refreshComments => '刷新评论';

  @override
  String get cancelReply => '取消回复';

  @override
  String get writeComment => '写下你的评论…';

  @override
  String get reply => '回复';

  @override
  String get publishing => '正在发表';

  @override
  String get publishComment => '发表评论';

  @override
  String get liked => '已点赞';

  @override
  String get like => '点赞';

  @override
  String commentsWithCount(int count) {
    return '评论 ($count)';
  }

  @override
  String get noMessages => '还没有消息，打个招呼吧';

  @override
  String get online => '在线';

  @override
  String get offline => '离线';

  @override
  String get groupChat => '群聊';

  @override
  String get loadOlderMessages => '加载更早消息';

  @override
  String get backToConversations => '返回会话列表';

  @override
  String get searchConversation => '搜索会话';

  @override
  String get addressBook => '通讯录';

  @override
  String get noFriendsToInvite => '暂无好友可邀请';

  @override
  String get selectConversation => '选择一个会话，开始聊天';

  @override
  String get refreshConversations => '刷新会话';

  @override
  String get signInToStartChat => '登录后开始聊天';

  @override
  String get chengeCore => 'ChengeCore';

  @override
  String get signInWithToken => '使用 Token 登录';

  @override
  String get openOfficialSiteWithWebView => '使用 WebView 打开官网';

  @override
  String get close => '关闭';

  @override
  String get raising => '养成';

  @override
  String get copy => '复制';

  @override
  String get webViewNotSupportedOnAllOs => '并非所有操作系统都能够调用 WebView';

  @override
  String get platformWebViewNotSupported => '当前平台暂不支持内置网页';

  @override
  String get openCoreEcosystem => '打开核心生态';

  @override
  String get openRaisingSystem => '打开站娘养成系统';

  @override
  String get cannotOpenSiteMissingConfig => '无法打开官网：缺少服务配置';

  @override
  String get accessTokenDescription => '用于校验身份的访问令牌';

  @override
  String get confirm => '确定';

  @override
  String get confirmSignIn => '确认登录';

  @override
  String get pasteJwtToken => '粘贴 JWT Token';

  @override
  String get accessToken => '访问令牌';

  @override
  String get accessTokenCopied => '访问令牌 已复制';

  @override
  String get accessTokenUpdated => '访问令牌 已更新';

  @override
  String get signInToUseChengeCore => '请先登录后再使用 ChengeCore';

  @override
  String get signInToUseRaising => '请先登录后再使用养成';

  @override
  String get enterToken => '请输入 Token';

  @override
  String get tasksInProgress => '进行中';

  @override
  String get tasksNoInProgress => '当前没有进行中的任务';

  @override
  String get tasksCompletedSection => '已完成';

  @override
  String get tasksRewardHint => '奖励需要手动领取 · 任务按周期刷新';

  @override
  String get tasksTodayGoal => '今日目标';

  @override
  String get tasksTodayGoalSubtitle => '完成社区任务，领取 ChengeCoin';

  @override
  String tasksProgressSummary(int completed) {
    return '待完成 · $completed 已完成';
  }

  @override
  String get taskClaimable => '可领取';

  @override
  String get taskCompletedBadge => '已完成';

  @override
  String taskCheckinStreak(int streak, int totalDays) {
    return '已连续签到 $streak 天 · 累计 $totalDays 天';
  }

  @override
  String get checkIn => '签到';

  @override
  String get claim => '领取';

  @override
  String get statusBarTopHideMask => '顶栏隐藏时状态栏遮罩';

  @override
  String get statusBarTopHideMaskDescription =>
      '顶栏可自动隐藏时，状态栏使用半透明主题背景，避免内容顶到状态栏（默认开启）';

  @override
  String get siteAndToken => '站点与令牌';

  @override
  String get officialSite => '官网';

  @override
  String webViewInitFailed(String errorType, String error) {
    return 'WebView 初始化失败（$errorType）：$error\nWindows 需安装 Edge WebView2 Runtime。';
  }
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get communityTitle => 'ChengeWorld 社区广场';

  @override
  String get discover => '发现';

  @override
  String get social => '社交';

  @override
  String get store => '商城';

  @override
  String get account => '我的';

  @override
  String get settings => '设置';

  @override
  String get appearance => '外观';

  @override
  String get themeMode => '主题模式';

  @override
  String get followSystem => '跟随系统';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get language => '语言';

  @override
  String get localeZhCn => '中文（中国）';

  @override
  String get localeZhTw => '中文（台湾）';

  @override
  String get localeEnUs => '英语（美国）';

  @override
  String get dynamicColor => '动态取色';

  @override
  String get dynamicColorDescription => '使用 Android 12+ 壁纸配色（Material You）';

  @override
  String get themeColor => '主题色';

  @override
  String get systemBars => '系统栏';

  @override
  String get statusBarImmersive => '状态栏沉浸';

  @override
  String get statusBarDescription => '内容延伸至状态栏下方，状态栏透明';

  @override
  String get navigationBarImmersive => '导航栏沉浸';

  @override
  String get navigationBarDescription => '内容延伸至导航栏下方，导航栏透明';

  @override
  String get scrollBehavior => '滚动行为';

  @override
  String get autoHideTopBar => '自动隐藏顶栏';

  @override
  String get autoHideTopDescription => '在发现 / 商城向下滚动时收起页面顶栏（默认开启）';

  @override
  String get autoHideBottomBar => '自动隐藏底栏';

  @override
  String get autoHideBottomDescription => '在发现 / 商城向下滚动时收起底部导航；宽屏侧边栏不会隐藏';

  @override
  String get chat => '聊天';

  @override
  String get showSelfAvatar => '在会话聊天显示自己的头像';

  @override
  String get showSelfAvatarDescription => '自己发送的消息右侧显示头像（默认关闭）';

  @override
  String get showPeerAvatar => '在私人会话聊天显示对方的头像';

  @override
  String get showPeerAvatarDescription => '私聊中对方消息左侧显示头像；群聊始终显示成员头像（默认关闭）';

  @override
  String get systemGestures => '系统手势';

  @override
  String get predictiveBack => '预见式返回';

  @override
  String get predictiveBackDescription => 'Android 13+ 页面过渡使用预见式返回动画（默认关闭）';

  @override
  String get layout => '布局';

  @override
  String get feedColumns => '发现页列数范围';

  @override
  String get shopColumns => '商店页列数范围';

  @override
  String columnRange(int min, int max) {
    return '当前：$min – $max 列（宽度足够时在此范围内自适应）';
  }

  @override
  String minimumColumns(int count) {
    return '最小 $count';
  }

  @override
  String maximumColumns(int count) {
    return '最大 $count';
  }

  @override
  String postCount(int count) {
    return '$count 篇';
  }

  @override
  String pageCount(int page, int total) {
    return '第 $page / $total 页';
  }

  @override
  String itemCount(int count) {
    return '$count 件商品';
  }

  @override
  String get rightNow => '此刻在聊';

  @override
  String get freshDiscussions => '看看社区里的新鲜讨论';

  @override
  String get searchPostsAndTopics => '搜索帖子和话题';

  @override
  String get search => '搜索';

  @override
  String get refreshPosts => '刷新帖子';

  @override
  String get latest => '最新';

  @override
  String get popular => '热门';

  @override
  String get featured => '精华';

  @override
  String get noPosts => '暂时没有帖子';

  @override
  String get noPostsHint => '换个关键词或稍后再来看看';

  @override
  String get retry => '重试';

  @override
  String get previousPage => '上一页';

  @override
  String get nextPage => '下一页';

  @override
  String get signOut => '退出登录';

  @override
  String get confirmSignOut => '确定退出当前 ChengeWorld 账户？';

  @override
  String get cancel => '取消';

  @override
  String get exit => '退出';

  @override
  String get signedOut => '已退出登录';

  @override
  String get accountSettingsSignIn => '登录后可管理账户设置';

  @override
  String get signedIn => '已登录';

  @override
  String get welcome => '欢迎来到社区';

  @override
  String get accountConnected => '账户已连接到 ChengeWorld';

  @override
  String get signInForPersonalized => '登录后浏览个性化内容';

  @override
  String get taskCenter => '任务中心';

  @override
  String get taskCenterDescription => '签到、完成任务并领取 ChengeCoin';

  @override
  String get signIn => '登录';

  @override
  String get signInAccount => '登录账户';

  @override
  String get signInSuccess => '登录成功';

  @override
  String get signInToChengeWorld => '登录 ChengeWorld';

  @override
  String get username => '用户名';

  @override
  String get enterUsername => '请输入用户名';

  @override
  String get password => '密码';

  @override
  String get showPassword => '显示密码';

  @override
  String get hidePassword => '隐藏密码';

  @override
  String get enterPassword => '请输入密码';

  @override
  String get signingIn => '正在登录';

  @override
  String get contacts => '通讯录';

  @override
  String get productDetails => '商品详情';

  @override
  String get post => '帖子';

  @override
  String get shopNow => '逛商城';

  @override
  String get myAssets => '我的资产';

  @override
  String get orders => '订单';

  @override
  String get discoverItems => '发现好物';

  @override
  String get searchProducts => '搜索商品';

  @override
  String get sortProducts => '排序商品';

  @override
  String get newestArrivals => '最新上架';

  @override
  String get popularProducts => '热门商品';

  @override
  String get priceLowToHigh => '价格从低到高';

  @override
  String get priceHighToLow => '价格从高到低';

  @override
  String get ratingFirst => '评分优先';

  @override
  String get all => '全部';

  @override
  String get files => '文件';

  @override
  String get emojiPacks => '表情包';

  @override
  String get components => '组件';

  @override
  String get applications => '应用';

  @override
  String get executables => '可执行';

  @override
  String get libraries => '类库';

  @override
  String get functionLibraries => '函数库';

  @override
  String get noAssetsOrOrdersSignIn => '登录后查看资产与订单';

  @override
  String get goSignIn => '前往登录';

  @override
  String get shopUnavailable => '商城暂时不可用';

  @override
  String get checkNetworkAndRetry => '检查网络后重试';

  @override
  String get noProducts => '暂时没有商品';

  @override
  String get tryOtherSearch => '试试其他关键词或分类';

  @override
  String get noAssets => '还没有资产';

  @override
  String get noOrders => '还没有订单';

  @override
  String get purchasesShowHere => '在商城购买的内容会显示在这里';

  @override
  String get refresh => '刷新';

  @override
  String get refreshTasks => '刷新任务';

  @override
  String get claimComplete => '去完成';

  @override
  String rewardClaimed(String coins) {
    return '奖励已领取，+$coins CC';
  }

  @override
  String get productPurchaseSuccess => '购买成功，已加入资产清单';

  @override
  String get signInToLike => '登录后即可点赞';

  @override
  String get signInToComment => '登录后即可发表评论';

  @override
  String get commentPublished => '评论已发表';

  @override
  String get noComments => '还没有评论';

  @override
  String get back => '返回';

  @override
  String commentCount(int count) {
    return '评论 · $count';
  }

  @override
  String get refreshComments => '刷新评论';

  @override
  String get cancelReply => '取消回复';

  @override
  String get writeComment => '写下你的评论…';

  @override
  String get reply => '回复';

  @override
  String get publishing => '正在发表';

  @override
  String get publishComment => '发表评论';

  @override
  String get liked => '已点赞';

  @override
  String get like => '点赞';

  @override
  String commentsWithCount(int count) {
    return '评论 ($count)';
  }

  @override
  String get noMessages => '还没有消息，打个招呼吧';

  @override
  String get online => '在线';

  @override
  String get offline => '离线';

  @override
  String get groupChat => '群聊';

  @override
  String get loadOlderMessages => '加载更早消息';

  @override
  String get backToConversations => '返回会话列表';

  @override
  String get searchConversation => '搜索会话';

  @override
  String get addressBook => '通讯录';

  @override
  String get noFriendsToInvite => '暂无好友可邀请';

  @override
  String get selectConversation => '选择一个会话，开始聊天';

  @override
  String get refreshConversations => '刷新会话';

  @override
  String get signInToStartChat => '登录后开始聊天';

  @override
  String get chengeCore => 'ChengeCore';

  @override
  String get signInWithToken => '使用 Token 登录';

  @override
  String get openOfficialSiteWithWebView => '使用 WebView 打开官网';

  @override
  String get close => '关闭';

  @override
  String get raising => '养成';

  @override
  String get copy => '复制';

  @override
  String get webViewNotSupportedOnAllOs => '并非所有操作系统都能够调用 WebView';

  @override
  String get platformWebViewNotSupported => '当前平台暂不支持内置网页';

  @override
  String get openCoreEcosystem => '打开核心生态';

  @override
  String get openRaisingSystem => '打开站娘养成系统';

  @override
  String get cannotOpenSiteMissingConfig => '无法打开官网：缺少服务配置';

  @override
  String get accessTokenDescription => '用于校验身份的访问令牌';

  @override
  String get confirm => '确定';

  @override
  String get confirmSignIn => '确认登录';

  @override
  String get pasteJwtToken => '粘贴 JWT Token';

  @override
  String get accessToken => '访问令牌';

  @override
  String get accessTokenCopied => '访问令牌 已复制';

  @override
  String get accessTokenUpdated => '访问令牌 已更新';

  @override
  String get signInToUseChengeCore => '请先登录后再使用 ChengeCore';

  @override
  String get signInToUseRaising => '请先登录后再使用养成';

  @override
  String get enterToken => '请输入 Token';

  @override
  String get tasksInProgress => '进行中';

  @override
  String get tasksNoInProgress => '当前没有进行中的任务';

  @override
  String get tasksCompletedSection => '已完成';

  @override
  String get tasksRewardHint => '奖励需要手动领取 · 任务按周期刷新';

  @override
  String get tasksTodayGoal => '今日目标';

  @override
  String get tasksTodayGoalSubtitle => '完成社区任务，领取 ChengeCoin';

  @override
  String tasksProgressSummary(int completed) {
    return '待完成 · $completed 已完成';
  }

  @override
  String get taskClaimable => '可领取';

  @override
  String get taskCompletedBadge => '已完成';

  @override
  String taskCheckinStreak(int streak, int totalDays) {
    return '已连续签到 $streak 天 · 累计 $totalDays 天';
  }

  @override
  String get checkIn => '签到';

  @override
  String get claim => '领取';

  @override
  String get statusBarTopHideMask => '顶栏隐藏时状态栏遮罩';

  @override
  String get statusBarTopHideMaskDescription =>
      '顶栏可自动隐藏时，状态栏使用半透明主题背景，避免内容顶到状态栏（默认开启）';

  @override
  String get siteAndToken => '站点与令牌';

  @override
  String get officialSite => '官网';

  @override
  String webViewInitFailed(String errorType, String error) {
    return 'WebView 初始化失败（$errorType）：$error\nWindows 需安装 Edge WebView2 Runtime。';
  }
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get communityTitle => 'ChengeWorld 社群廣場';

  @override
  String get discover => '發現';

  @override
  String get social => '社交';

  @override
  String get store => '商城';

  @override
  String get account => '我的';

  @override
  String get settings => '設定';

  @override
  String get appearance => '外觀';

  @override
  String get themeMode => '主題模式';

  @override
  String get followSystem => '跟隨系統';

  @override
  String get light => '淺色';

  @override
  String get dark => '深色';

  @override
  String get language => '語言';

  @override
  String get localeZhCn => '中文（中國）';

  @override
  String get localeZhTw => '中文（台灣）';

  @override
  String get localeEnUs => '英文（美國）';

  @override
  String get dynamicColor => '動態取色';

  @override
  String get dynamicColorDescription => '使用 Android 12+ 桌布配色（Material You）';

  @override
  String get themeColor => '主題色';

  @override
  String get systemBars => '系統列';

  @override
  String get statusBarImmersive => '狀態列沉浸';

  @override
  String get statusBarDescription => '內容延伸至狀態列下方，狀態列透明';

  @override
  String get navigationBarImmersive => '導覽列沉浸';

  @override
  String get navigationBarDescription => '內容延伸至導覽列下方，導覽列透明';

  @override
  String get scrollBehavior => '捲動行為';

  @override
  String get autoHideTopBar => '自動隱藏頂端列';

  @override
  String get autoHideTopDescription => '在探索／商城向下捲動時收合頁面頂端列（預設開啟）';

  @override
  String get autoHideBottomBar => '自動隱藏底部列';

  @override
  String get autoHideBottomDescription => '在探索／商城向下捲動時收合底部導覽列；寬螢幕側邊列不會隱藏';

  @override
  String get chat => '聊天';

  @override
  String get showSelfAvatar => '在對話中顯示自己的頭像';

  @override
  String get showSelfAvatarDescription => '自己傳送的訊息右側顯示頭像（預設關閉）';

  @override
  String get showPeerAvatar => '在私人對話中顯示對方頭像';

  @override
  String get showPeerAvatarDescription => '私聊中對方訊息左側顯示頭像；群聊始終顯示成員頭像（預設關閉）';

  @override
  String get systemGestures => '系統手勢';

  @override
  String get predictiveBack => '預測式返回';

  @override
  String get predictiveBackDescription => 'Android 13+ 頁面轉場使用預測式返回動畫（預設關閉）';

  @override
  String get layout => '版面配置';

  @override
  String get feedColumns => '探索頁欄數範圍';

  @override
  String get shopColumns => '商店頁欄數範圍';

  @override
  String columnRange(int min, int max) {
    return '目前：$min – $max 欄（空間足夠時會在此範圍內自動調整）';
  }

  @override
  String minimumColumns(int count) {
    return '最少 $count';
  }

  @override
  String maximumColumns(int count) {
    return '最多 $count';
  }

  @override
  String postCount(int count) {
    return '$count 篇貼文';
  }

  @override
  String pageCount(int page, int total) {
    return '第 $page / $total 頁';
  }

  @override
  String itemCount(int count) {
    return '$count 件商品';
  }

  @override
  String get rightNow => '此刻熱聊';

  @override
  String get freshDiscussions => '看看社群裡的新鮮討論';

  @override
  String get searchPostsAndTopics => '搜尋貼文和話題';

  @override
  String get search => '搜尋';

  @override
  String get refreshPosts => '重新整理貼文';

  @override
  String get latest => '最新';

  @override
  String get popular => '熱門';

  @override
  String get featured => '精選';

  @override
  String get noPosts => '暫時沒有貼文';

  @override
  String get noPostsHint => '換個關鍵字或稍後再來看看';

  @override
  String get retry => '重試';

  @override
  String get previousPage => '上一頁';

  @override
  String get nextPage => '下一頁';

  @override
  String get signOut => '登出';

  @override
  String get confirmSignOut => '確定要登出目前的 ChengeWorld 帳戶嗎？';

  @override
  String get cancel => '取消';

  @override
  String get exit => '登出';

  @override
  String get signedOut => '已登出';

  @override
  String get accountSettingsSignIn => '登入後可管理帳戶設定';

  @override
  String get signedIn => '已登入';

  @override
  String get welcome => '歡迎來到社群';

  @override
  String get accountConnected => '帳戶已連線至 ChengeWorld';

  @override
  String get signInForPersonalized => '登入後瀏覽個人化內容';

  @override
  String get taskCenter => '任務中心';

  @override
  String get taskCenterDescription => '簽到、完成任務並領取 ChengeCoin';

  @override
  String get signIn => '登入';

  @override
  String get signInAccount => '登入帳戶';

  @override
  String get signInSuccess => '登入成功';

  @override
  String get signInToChengeWorld => '登入 ChengeWorld';

  @override
  String get username => '使用者名稱';

  @override
  String get enterUsername => '請輸入使用者名稱';

  @override
  String get password => '密碼';

  @override
  String get showPassword => '顯示密碼';

  @override
  String get hidePassword => '隱藏密碼';

  @override
  String get enterPassword => '請輸入密碼';

  @override
  String get signingIn => '正在登入';

  @override
  String get contacts => '通訊錄';

  @override
  String get productDetails => '商品詳細資料';

  @override
  String get post => '貼文';

  @override
  String get shopNow => '逛商城';

  @override
  String get myAssets => '我的資產';

  @override
  String get orders => '訂單';

  @override
  String get discoverItems => '發現好物';

  @override
  String get searchProducts => '搜尋商品';

  @override
  String get sortProducts => '排序商品';

  @override
  String get newestArrivals => '最新上架';

  @override
  String get popularProducts => '熱門商品';

  @override
  String get priceLowToHigh => '價格由低至高';

  @override
  String get priceHighToLow => '價格由高至低';

  @override
  String get ratingFirst => '評分優先';

  @override
  String get all => '全部';

  @override
  String get files => '檔案';

  @override
  String get emojiPacks => '表情包';

  @override
  String get components => '元件';

  @override
  String get applications => '應用程式';

  @override
  String get executables => '可執行檔';

  @override
  String get libraries => '類別庫';

  @override
  String get functionLibraries => '函式庫';

  @override
  String get noAssetsOrOrdersSignIn => '登入後查看資產與訂單';

  @override
  String get goSignIn => '前往登入';

  @override
  String get shopUnavailable => '商城暫時無法使用';

  @override
  String get checkNetworkAndRetry => '檢查網路後重試';

  @override
  String get noProducts => '暫時沒有商品';

  @override
  String get tryOtherSearch => '試試其他關鍵字或分類';

  @override
  String get noAssets => '還沒有資產';

  @override
  String get noOrders => '還沒有訂單';

  @override
  String get purchasesShowHere => '在商城購買的內容會顯示在這裡';

  @override
  String get refresh => '重新整理';

  @override
  String get refreshTasks => '重新整理任務';

  @override
  String get claimComplete => '前往完成';

  @override
  String rewardClaimed(String coins) {
    return '已領取獎勵，+$coins CC';
  }

  @override
  String get productPurchaseSuccess => '購買成功，已加入資產清單';

  @override
  String get signInToLike => '登入後即可按讚';

  @override
  String get signInToComment => '登入後即可發表評論';

  @override
  String get commentPublished => '已發表評論';

  @override
  String get noComments => '還沒有留言';

  @override
  String get back => '返回';

  @override
  String commentCount(int count) {
    return '評論 · $count';
  }

  @override
  String get refreshComments => '重新整理評論';

  @override
  String get cancelReply => '取消回覆';

  @override
  String get writeComment => '寫下你的評論…';

  @override
  String get reply => '回覆';

  @override
  String get publishing => '正在發表';

  @override
  String get publishComment => '發表評論';

  @override
  String get liked => '已按讚';

  @override
  String get like => '按讚';

  @override
  String commentsWithCount(int count) {
    return '評論（$count）';
  }

  @override
  String get noMessages => '還沒有訊息，打個招呼吧';

  @override
  String get online => '在線';

  @override
  String get offline => '離線';

  @override
  String get groupChat => '群聊';

  @override
  String get loadOlderMessages => '載入較早的訊息';

  @override
  String get backToConversations => '返回對話列表';

  @override
  String get searchConversation => '搜尋對話';

  @override
  String get addressBook => '通訊錄';

  @override
  String get noFriendsToInvite => '目前沒有好友可邀請';

  @override
  String get selectConversation => '選擇一個對話，開始聊天';

  @override
  String get refreshConversations => '重新整理對話';

  @override
  String get signInToStartChat => '登入後開始聊天';

  @override
  String get chengeCore => 'ChengeCore';

  @override
  String get signInWithToken => '使用 Token 登入';

  @override
  String get openOfficialSiteWithWebView => '使用 WebView 開啟官網';

  @override
  String get close => '關閉';

  @override
  String get raising => '養成';

  @override
  String get copy => '複製';

  @override
  String get webViewNotSupportedOnAllOs => '並非所有作業系統都能呼叫 WebView';

  @override
  String get platformWebViewNotSupported => '目前平台暫不支援內建網頁';

  @override
  String get openCoreEcosystem => '開啟核心生態';

  @override
  String get openRaisingSystem => '開啟站娘養成系統';

  @override
  String get cannotOpenSiteMissingConfig => '無法開啟官網：缺少服務設定';

  @override
  String get accessTokenDescription => '用於驗證身分的存取權杖';

  @override
  String get confirm => '確定';

  @override
  String get confirmSignIn => '確認登入';

  @override
  String get pasteJwtToken => '貼上 JWT Token';

  @override
  String get accessToken => '存取權杖';

  @override
  String get accessTokenCopied => '存取權杖 已複製';

  @override
  String get accessTokenUpdated => '存取權杖 已更新';

  @override
  String get signInToUseChengeCore => '請先登入後再使用 ChengeCore';

  @override
  String get signInToUseRaising => '請先登入後再使用養成';

  @override
  String get enterToken => '請輸入 Token';

  @override
  String get tasksInProgress => '進行中';

  @override
  String get tasksNoInProgress => '目前沒有進行中的任務';

  @override
  String get tasksCompletedSection => '已完成';

  @override
  String get tasksRewardHint => '獎勵需手動領取 · 任務依週期刷新';

  @override
  String get tasksTodayGoal => '今日目標';

  @override
  String get tasksTodayGoalSubtitle => '完成社群任務，領取 ChengeCoin';

  @override
  String tasksProgressSummary(int completed) {
    return '待完成 · $completed 已完成';
  }

  @override
  String get taskClaimable => '可領取';

  @override
  String get taskCompletedBadge => '已完成';

  @override
  String taskCheckinStreak(int streak, int totalDays) {
    return '已連續簽到 $streak 天 · 累計 $totalDays 天';
  }

  @override
  String get checkIn => '簽到';

  @override
  String get claim => '領取';

  @override
  String get statusBarTopHideMask => '頂欄隱藏時狀態列遮罩';

  @override
  String get statusBarTopHideMaskDescription =>
      '頂欄可自動隱藏時，狀態列使用半透明主題背景，避免內容頂到狀態列（預設開啟）';

  @override
  String get siteAndToken => '站點與權杖';

  @override
  String get officialSite => '官網';

  @override
  String webViewInitFailed(String errorType, String error) {
    return 'WebView 初始化失敗（$errorType）：$error\nWindows 需安裝 Edge WebView2 Runtime。';
  }
}
