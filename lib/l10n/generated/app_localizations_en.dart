// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
}

/// The translations for English, as used in the United States (`en_US`).
class AppLocalizationsEnUs extends AppLocalizationsEn {
  AppLocalizationsEnUs() : super('en_US');

  @override
  String get communityTitle => 'ChengeWorld Community';

  @override
  String get discover => 'Discover';

  @override
  String get social => 'Social';

  @override
  String get store => 'Store';

  @override
  String get account => 'Account';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeMode => 'Theme mode';

  @override
  String get followSystem => 'Follow system';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get localeZhCn => 'Chinese (China)';

  @override
  String get localeZhTw => 'Chinese (Taiwan)';

  @override
  String get localeEnUs => 'English (United States)';

  @override
  String get dynamicColor => 'Dynamic color';

  @override
  String get dynamicColorDescription =>
      'Use Android 12+ wallpaper colors (Material You)';

  @override
  String get themeColor => 'Theme color';

  @override
  String get systemBars => 'System bars';

  @override
  String get statusBarImmersive => 'Transparent status bar';

  @override
  String get statusBarDescription =>
      'Extend content behind the transparent status bar';

  @override
  String get navigationBarImmersive => 'Transparent navigation bar';

  @override
  String get navigationBarDescription =>
      'Extend content behind the transparent navigation bar';

  @override
  String get scrollBehavior => 'Scrolling';

  @override
  String get autoHideTopBar => 'Auto-hide top bar';

  @override
  String get autoHideTopDescription =>
      'Hide the app bar when scrolling down in Discover or Store (on by default)';

  @override
  String get autoHideBottomBar => 'Auto-hide bottom bar';

  @override
  String get autoHideBottomDescription =>
      'Hide bottom navigation when scrolling down; the rail stays visible on wide screens';

  @override
  String get chat => 'Chat';

  @override
  String get showSelfAvatar => 'Show my avatar in chats';

  @override
  String get showSelfAvatarDescription =>
      'Show your avatar beside sent messages (off by default)';

  @override
  String get showPeerAvatar =>
      'Show the other person’s avatar in private chats';

  @override
  String get showPeerAvatarDescription =>
      'Show the other person’s avatar beside private messages; group avatars are always shown (off by default)';

  @override
  String get systemGestures => 'System gestures';

  @override
  String get predictiveBack => 'Predictive back';

  @override
  String get predictiveBackDescription =>
      'Use predictive back animations on Android 13+ (off by default)';

  @override
  String get layout => 'Layout';

  @override
  String get feedColumns => 'Discover grid columns';

  @override
  String get shopColumns => 'Store grid columns';

  @override
  String columnRange(int min, int max) {
    return 'Current: $min–$max columns (adapts within this range when space allows)';
  }

  @override
  String minimumColumns(int count) {
    return 'Min $count';
  }

  @override
  String maximumColumns(int count) {
    return 'Max $count';
  }

  @override
  String postCount(int count) {
    return '$count posts';
  }

  @override
  String pageCount(int page, int total) {
    return 'Page $page of $total';
  }

  @override
  String itemCount(int count) {
    return '$count products';
  }

  @override
  String get rightNow => 'What people are discussing';

  @override
  String get freshDiscussions => 'See what is new in the community';

  @override
  String get searchPostsAndTopics => 'Search posts and topics';

  @override
  String get search => 'Search';

  @override
  String get refreshPosts => 'Refresh posts';

  @override
  String get latest => 'Latest';

  @override
  String get popular => 'Popular';

  @override
  String get featured => 'Featured';

  @override
  String get noPosts => 'No posts yet';

  @override
  String get noPostsHint => 'Try another keyword or check back later';

  @override
  String get retry => 'Retry';

  @override
  String get previousPage => 'Previous page';

  @override
  String get nextPage => 'Next page';

  @override
  String get signOut => 'Sign out';

  @override
  String get confirmSignOut =>
      'Are you sure you want to sign out of ChengeWorld?';

  @override
  String get cancel => 'Cancel';

  @override
  String get exit => 'Sign out';

  @override
  String get signedOut => 'Signed out';

  @override
  String get accountSettingsSignIn => 'Sign in to manage account settings';

  @override
  String get signedIn => 'Signed in';

  @override
  String get welcome => 'Welcome to the community';

  @override
  String get accountConnected => 'Your account is connected to ChengeWorld';

  @override
  String get signInForPersonalized => 'Sign in to explore personalized content';

  @override
  String get taskCenter => 'Task center';

  @override
  String get taskCenterDescription =>
      'Check in, complete tasks, and earn ChengeCoin';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInAccount => 'Sign in';

  @override
  String get signInSuccess => 'Signed in successfully';

  @override
  String get signInToChengeWorld => 'Sign in to ChengeWorld';

  @override
  String get username => 'Username';

  @override
  String get enterUsername => 'Enter a username';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get enterPassword => 'Enter a password';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get contacts => 'Contacts';

  @override
  String get productDetails => 'Product details';

  @override
  String get post => 'Post';

  @override
  String get shopNow => 'Store';

  @override
  String get myAssets => 'My assets';

  @override
  String get orders => 'Orders';

  @override
  String get discoverItems => 'Discover products';

  @override
  String get searchProducts => 'Search products';

  @override
  String get sortProducts => 'Sort products';

  @override
  String get newestArrivals => 'Newest arrivals';

  @override
  String get popularProducts => 'Popular products';

  @override
  String get priceLowToHigh => 'Price: low to high';

  @override
  String get priceHighToLow => 'Price: high to low';

  @override
  String get ratingFirst => 'Top rated';

  @override
  String get all => 'All';

  @override
  String get files => 'Files';

  @override
  String get emojiPacks => 'Emoji packs';

  @override
  String get components => 'Components';

  @override
  String get applications => 'Applications';

  @override
  String get executables => 'Executables';

  @override
  String get libraries => 'Libraries';

  @override
  String get functionLibraries => 'Function libraries';

  @override
  String get noAssetsOrOrdersSignIn => 'Sign in to view assets and orders';

  @override
  String get goSignIn => 'Sign in';

  @override
  String get shopUnavailable => 'Store temporarily unavailable';

  @override
  String get checkNetworkAndRetry => 'Check your connection and try again';

  @override
  String get noProducts => 'No products yet';

  @override
  String get tryOtherSearch => 'Try another keyword or category';

  @override
  String get noAssets => 'No assets yet';

  @override
  String get noOrders => 'No orders yet';

  @override
  String get purchasesShowHere => 'Your store purchases will appear here';

  @override
  String get refresh => 'Refresh';

  @override
  String get refreshTasks => 'Refresh tasks';

  @override
  String get claimComplete => 'Continue';

  @override
  String rewardClaimed(String coins) {
    return 'Reward claimed: +$coins CC';
  }

  @override
  String get productPurchaseSuccess =>
      'Purchase complete; added to your assets';

  @override
  String get signInToLike => 'Sign in to like this post';

  @override
  String get signInToComment => 'Sign in to comment';

  @override
  String get commentPublished => 'Comment posted';

  @override
  String get noComments => 'No comments yet';

  @override
  String get back => 'Back';

  @override
  String commentCount(int count) {
    return 'Comments · $count';
  }

  @override
  String get refreshComments => 'Refresh comments';

  @override
  String get cancelReply => 'Cancel reply';

  @override
  String get writeComment => 'Write a comment…';

  @override
  String get reply => 'Reply';

  @override
  String get publishing => 'Posting…';

  @override
  String get publishComment => 'Post comment';

  @override
  String get liked => 'Liked';

  @override
  String get like => 'Like';

  @override
  String commentsWithCount(int count) {
    return 'Comments ($count)';
  }

  @override
  String get noMessages => 'No messages yet. Say hello!';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get groupChat => 'Group chat';

  @override
  String get loadOlderMessages => 'Load earlier messages';

  @override
  String get backToConversations => 'Back to conversations';

  @override
  String get searchConversation => 'Search conversations';

  @override
  String get addressBook => 'Contacts';

  @override
  String get noFriendsToInvite => 'No friends to invite yet';

  @override
  String get selectConversation => 'Select a conversation to start chatting';

  @override
  String get refreshConversations => 'Refresh conversations';

  @override
  String get signInToStartChat => 'Sign in to start chatting';
}
