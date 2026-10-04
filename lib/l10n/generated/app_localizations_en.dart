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
  String get communityMerchant => '社区商家';

  @override
  String get product => '商品';

  @override
  String get productInitial => '商';

  @override
  String stockCount(int count) {
    return '库存 $count';
  }

  @override
  String soldCount(int count) {
    return '已售 $count';
  }

  @override
  String ratingReviews(String rating, int count) {
    return '$rating · $count 评价';
  }

  @override
  String get productDescription => '商品介绍';

  @override
  String get purchasedContent => '已购内容';

  @override
  String get purchaseToViewContent => '购买后可查看完整内容';

  @override
  String get openOrDownloadFile => '打开/下载文件';

  @override
  String balanceCc(String amount) {
    return '余额 $amount CC';
  }

  @override
  String get buying => '购买中…';

  @override
  String get buy => '购买';

  @override
  String get yourListedProduct => '这是你上架的商品';

  @override
  String get backToShop => '返回商城';

  @override
  String holdingQuantityType(Object quantity, String type) {
    return '持有 $quantity 件 · $type';
  }

  @override
  String get orderPending => '待支付';

  @override
  String get orderPaid => '已支付';

  @override
  String get orderRefunded => '已退款';

  @override
  String get statusUnknown => '状态未知';

  @override
  String get conversationNotFound => '未找到该会话，请刷新后重试';

  @override
  String get noMatchingConversations => '没有匹配的会话';

  @override
  String get noConversationsYet => '还没有会话';

  @override
  String get goContactsToChat => '去通讯录发起聊天';

  @override
  String get friendInitial => '友';

  @override
  String get noMessagesYetShort => '还没有消息';

  @override
  String previewEmoji(String key) {
    return '[表情] $key';
  }

  @override
  String get previewSharedPost => '[分享帖子]';

  @override
  String get previewOrder => '[商品订单]';

  @override
  String get emojiMessage => '表情消息';

  @override
  String get me => '我';

  @override
  String get sharedPost => '分享帖子';

  @override
  String get productOrder => '商品订单';

  @override
  String get cannotOpenPostMissingId => '无法打开帖子：分享内容缺少帖子编号';

  @override
  String get cannotOpenProductMissingId => '无法打开商品：分享内容缺少商品编号';

  @override
  String get chengeUser => 'Chenge 用户';

  @override
  String get signInToPurchase => '登录后才能购买';

  @override
  String get typeMessage => '输入消息…';

  @override
  String get sendMessage => '发送消息';

  @override
  String get emoji => '表情';

  @override
  String get previewEmojiOnly => '[表情]';

  @override
  String get enterGroupNameKeyword => '请输入群名称关键词';

  @override
  String get enterUserSearchHint => '请输入用户名、昵称或邮箱';

  @override
  String get friendAddedBack => '已回加，现在你们是好友了';

  @override
  String get friendRequestSent => '好友申请已发送';

  @override
  String get rejectFriendRequest => '拒绝好友申请';

  @override
  String get removeFriend => '解除好友';

  @override
  String confirmRejectFriendRequest(String name) {
    return '确定拒绝 $name 的好友申请？';
  }

  @override
  String confirmRemoveFriend(String name) {
    return '确定与 $name 解除好友关系？';
  }

  @override
  String get reject => '拒绝';

  @override
  String get remove => '解除';

  @override
  String get friendRequestRejected => '已拒绝好友申请';

  @override
  String get friendRemoved => '已解除好友关系';

  @override
  String get remarkCleared => '备注已清除';

  @override
  String get remarkSaved => '备注已保存';

  @override
  String joinedGroup(String name) {
    return '已加入「$name」';
  }

  @override
  String get enterGroupName => '请输入群名称';

  @override
  String groupCreated(String name) {
    return '群聊「$name」已创建';
  }

  @override
  String get createGroupChat => '创建群聊';

  @override
  String get signInToManageContacts => '登录后管理通讯录';

  @override
  String get contactsSubtitle => '搜索用户、加入群聊、处理好友申请';

  @override
  String friendsTab(int count) {
    return '好友 $count';
  }

  @override
  String groupsTab(int count) {
    return '群聊 $count';
  }

  @override
  String requestsTab(int count) {
    return '申请 $count';
  }

  @override
  String get searchUsers => '搜用户';

  @override
  String get searchGroups => '搜群聊';

  @override
  String get groupNameKeyword => '群名称关键词';

  @override
  String get userSearchHint => '用户名、昵称或邮箱';

  @override
  String get searchGroupsTooltip => '搜索群聊';

  @override
  String get searchUsersTooltip => '搜索用户';

  @override
  String get searchPublicGroups => '搜索公开群聊';

  @override
  String get searchChengeUsers => '搜索 ChengeWorld 用户';

  @override
  String get searchPublicGroupsHint => '输入群名称关键词，加入感兴趣的群';

  @override
  String get searchUsersHint => '支持用户名、昵称或邮箱';

  @override
  String get noMatchingGroups => '没有找到匹配的群';

  @override
  String get noMatchingPeople => '没有找到匹配的人';

  @override
  String get tryOtherKeywords => '试试其他关键词';

  @override
  String get noGroupsYet => '还没有群聊';

  @override
  String get noGroupsHint => '创建群聊，或在搜索里加入公开群';

  @override
  String get noFriendsYet => '还没有好友';

  @override
  String get noFriendsHint => '搜索用户名或昵称，认识新朋友';

  @override
  String get noPendingRequests => '没有待处理的申请';

  @override
  String get noPendingRequestsHint => '新的好友申请会显示在这里';

  @override
  String get groupTapToJoin => '群聊 · 点击加入';

  @override
  String get join => '加入';

  @override
  String get enterGroup => '进入群聊';

  @override
  String requestAddYou(String username) {
    return '@$username · 申请添加你';
  }

  @override
  String onlineWithRemark(String status, String remark, String username) {
    return '$status · 备注：$remark · @$username';
  }

  @override
  String get friend => '好友';

  @override
  String get addBack => '回加';

  @override
  String get requested => '已申请';

  @override
  String get add => '添加';

  @override
  String get acceptAndAddBack => '回加并接受';

  @override
  String get rejectRequest => '拒绝申请';

  @override
  String get friendActions => '好友操作';

  @override
  String get sendMessageAction => '发消息';

  @override
  String get editRemark => '修改备注';

  @override
  String get setRemark => '设置备注';

  @override
  String get removeFriendRelation => '解除好友关系';

  @override
  String get setFriendRemark => '设置好友备注';

  @override
  String get remarkName => '备注名称';

  @override
  String get remarkHintClear => '留空以清除备注';

  @override
  String get save => '保存';

  @override
  String get groupName => '群名称';

  @override
  String get groupNameHint => '给群聊起个名字';

  @override
  String get selectMembersOptional => '选择成员（可选）';

  @override
  String get create => '创建';

  @override
  String get newConversation => '新对话';

  @override
  String get deleteSession => '删除会话';

  @override
  String confirmDeleteSession(String name) {
    return '确定删除「$name」？聊天记录将一并清除。';
  }

  @override
  String get delete => '删除';

  @override
  String get newChat => '新建对话';

  @override
  String get refreshSessions => '刷新会话';

  @override
  String get signInToUseAiAgent => '登录后使用 AI Agent';

  @override
  String get aiAgentSubtitle => '支持多会话、流式回复与 MCP 工具';

  @override
  String get selectOrCreateAiSession => '选择或新建一个 AI 会话';

  @override
  String get aiSessions => 'AI 会话';

  @override
  String get noAiChatsYet => '还没有 AI 对话';

  @override
  String get tapNewToStartChat => '点下方新建开始对话';

  @override
  String get thinking => '思考中…';

  @override
  String get aiRequestFailed => 'AI 请求失败';

  @override
  String get noTextReply => '（无文本回复）';

  @override
  String get waitingConfirm => '等待确认…';

  @override
  String receivedType(String type) {
    return '收到 $type';
  }

  @override
  String get backToSessionList => '返回会话列表';

  @override
  String get sendMessageToStart => '发一条消息开始对话';

  @override
  String get askAiAgent => '向 AI Agent 提问…';

  @override
  String emojiPackTitle(Object id) {
    return '表情包 $id';
  }

  @override
  String get noEmojiPacksBuyInShop => '暂无表情包，可在商店购买';

  @override
  String replyToUser(String name) {
    return '回复 @$name';
  }

  @override
  String get user => '用户';

  @override
  String get anonymousUser => '匿名用户';

  @override
  String get timeUnknown => '时间未知';

  @override
  String dateYmd(int year, int month, int day) {
    return '$year年$month月$day日';
  }

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

  @override
  String get registerAccount => '注册账号';

  @override
  String get registerTitle => '注册 ChengeWorld';

  @override
  String get registerSuccess => '注册成功，请登录';

  @override
  String get nicknameOptional => '昵称（可选）';

  @override
  String get email => '邮箱';

  @override
  String get enterEmail => '请输入邮箱';

  @override
  String get invalidEmail => '邮箱格式不正确';

  @override
  String get emailCode => '邮箱验证码';

  @override
  String get enterEmailCode => '请输入验证码';

  @override
  String get getEmailCode => '获取验证码';

  @override
  String get sendingCode => '发送中';

  @override
  String get emailCodeSent => '验证码已发送（开发环境可查看后端日志）';

  @override
  String get fillEmailFirst => '请先填写邮箱';

  @override
  String get passwordMinSix => '密码（至少 6 位）';

  @override
  String get passwordTooShort => '密码至少 6 位';

  @override
  String get register => '注册';

  @override
  String get registering => '注册中…';

  @override
  String get clearCache => '清空缓存';

  @override
  String get clearCacheDescription => '清除图片等本地缓存，不影响登录状态';

  @override
  String get clearCacheConfirm => '确定清空本地缓存？';

  @override
  String get clearCacheDone => '缓存已清空';

  @override
  String get clearingCache => '正在清空…';

  @override
  String get accessTokenCleared => '访问令牌已清除';
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

  @override
  String get chengeCore => 'ChengeCore';

  @override
  String get signInWithToken => 'Sign in with Token';

  @override
  String get openOfficialSiteWithWebView => 'Open official site with WebView';

  @override
  String get close => 'Close';

  @override
  String get raising => 'Raising';

  @override
  String get copy => 'Copy';

  @override
  String get webViewNotSupportedOnAllOs =>
      'Not all operating systems support WebView';

  @override
  String get platformWebViewNotSupported =>
      'Built-in web view is not supported on this platform';

  @override
  String get openCoreEcosystem => 'Open core ecosystem';

  @override
  String get openRaisingSystem => 'Open raising system';

  @override
  String get cannotOpenSiteMissingConfig =>
      'Cannot open site: missing service configuration';

  @override
  String get accessTokenDescription =>
      'Access token used for identity verification';

  @override
  String get confirm => 'OK';

  @override
  String get confirmSignIn => 'Confirm sign in';

  @override
  String get pasteJwtToken => 'Paste JWT Token';

  @override
  String get accessToken => 'Access token';

  @override
  String get accessTokenCopied => 'Access token copied';

  @override
  String get accessTokenUpdated => 'Access token updated';

  @override
  String get signInToUseChengeCore => 'Please sign in to use ChengeCore';

  @override
  String get signInToUseRaising => 'Please sign in to use raising';

  @override
  String get enterToken => 'Please enter token';

  @override
  String get communityMerchant => 'Community seller';

  @override
  String get product => 'Product';

  @override
  String get productInitial => 'P';

  @override
  String stockCount(int count) {
    return 'Stock $count';
  }

  @override
  String soldCount(int count) {
    return 'Sold $count';
  }

  @override
  String ratingReviews(String rating, int count) {
    return '$rating · $count reviews';
  }

  @override
  String get productDescription => 'Description';

  @override
  String get purchasedContent => 'Purchased content';

  @override
  String get purchaseToViewContent => 'Purchase to view full content';

  @override
  String get openOrDownloadFile => 'Open / download file';

  @override
  String balanceCc(String amount) {
    return 'Balance $amount CC';
  }

  @override
  String get buying => 'Buying…';

  @override
  String get buy => 'Buy';

  @override
  String get yourListedProduct => 'This is your listed product';

  @override
  String get backToShop => 'Back to store';

  @override
  String holdingQuantityType(Object quantity, String type) {
    return 'Owned $quantity · $type';
  }

  @override
  String get orderPending => 'Pending';

  @override
  String get orderPaid => 'Paid';

  @override
  String get orderRefunded => 'Refunded';

  @override
  String get statusUnknown => 'Unknown status';

  @override
  String get conversationNotFound =>
      'Conversation not found. Please refresh and try again.';

  @override
  String get noMatchingConversations => 'No matching conversations';

  @override
  String get noConversationsYet => 'No conversations yet';

  @override
  String get goContactsToChat => 'Go to contacts to start a chat';

  @override
  String get friendInitial => 'F';

  @override
  String get noMessagesYetShort => 'No messages yet';

  @override
  String previewEmoji(String key) {
    return '[Emoji] $key';
  }

  @override
  String get previewSharedPost => '[Shared post]';

  @override
  String get previewOrder => '[Product order]';

  @override
  String get emojiMessage => 'Emoji message';

  @override
  String get me => 'Me';

  @override
  String get sharedPost => 'Shared post';

  @override
  String get productOrder => 'Product order';

  @override
  String get cannotOpenPostMissingId =>
      'Cannot open post: missing post id in share';

  @override
  String get cannotOpenProductMissingId =>
      'Cannot open product: missing product id in share';

  @override
  String get chengeUser => 'Chenge user';

  @override
  String get signInToPurchase => 'Sign in to purchase';

  @override
  String get typeMessage => 'Type a message…';

  @override
  String get sendMessage => 'Send message';

  @override
  String get emoji => 'Emoji';

  @override
  String get previewEmojiOnly => '[Emoji]';

  @override
  String get enterGroupNameKeyword => 'Enter a group name keyword';

  @override
  String get enterUserSearchHint => 'Enter username, nickname, or email';

  @override
  String get friendAddedBack => 'Added back — you are friends now';

  @override
  String get friendRequestSent => 'Friend request sent';

  @override
  String get rejectFriendRequest => 'Reject friend request';

  @override
  String get removeFriend => 'Remove friend';

  @override
  String confirmRejectFriendRequest(String name) {
    return 'Reject friend request from $name?';
  }

  @override
  String confirmRemoveFriend(String name) {
    return 'Remove $name from friends?';
  }

  @override
  String get reject => 'Reject';

  @override
  String get remove => 'Remove';

  @override
  String get friendRequestRejected => 'Friend request rejected';

  @override
  String get friendRemoved => 'Friend removed';

  @override
  String get remarkCleared => 'Remark cleared';

  @override
  String get remarkSaved => 'Remark saved';

  @override
  String joinedGroup(String name) {
    return 'Joined “$name”';
  }

  @override
  String get enterGroupName => 'Please enter a group name';

  @override
  String groupCreated(String name) {
    return 'Group “$name” created';
  }

  @override
  String get createGroupChat => 'Create group chat';

  @override
  String get signInToManageContacts => 'Sign in to manage contacts';

  @override
  String get contactsSubtitle =>
      'Search users, join groups, handle friend requests';

  @override
  String friendsTab(int count) {
    return 'Friends $count';
  }

  @override
  String groupsTab(int count) {
    return 'Groups $count';
  }

  @override
  String requestsTab(int count) {
    return 'Requests $count';
  }

  @override
  String get searchUsers => 'Users';

  @override
  String get searchGroups => 'Groups';

  @override
  String get groupNameKeyword => 'Group name keyword';

  @override
  String get userSearchHint => 'Username, nickname, or email';

  @override
  String get searchGroupsTooltip => 'Search groups';

  @override
  String get searchUsersTooltip => 'Search users';

  @override
  String get searchPublicGroups => 'Search public groups';

  @override
  String get searchChengeUsers => 'Search ChengeWorld users';

  @override
  String get searchPublicGroupsHint =>
      'Enter a group name to join groups you like';

  @override
  String get searchUsersHint => 'Username, nickname, or email supported';

  @override
  String get noMatchingGroups => 'No matching groups';

  @override
  String get noMatchingPeople => 'No matching people';

  @override
  String get tryOtherKeywords => 'Try other keywords';

  @override
  String get noGroupsYet => 'No groups yet';

  @override
  String get noGroupsHint => 'Create a group, or join a public one from search';

  @override
  String get noFriendsYet => 'No friends yet';

  @override
  String get noFriendsHint => 'Search by username or nickname to meet people';

  @override
  String get noPendingRequests => 'No pending requests';

  @override
  String get noPendingRequestsHint => 'New friend requests will show up here';

  @override
  String get groupTapToJoin => 'Group · tap to join';

  @override
  String get join => 'Join';

  @override
  String get enterGroup => 'Enter group';

  @override
  String requestAddYou(String username) {
    return '@$username · wants to add you';
  }

  @override
  String onlineWithRemark(String status, String remark, String username) {
    return '$status · remark: $remark · @$username';
  }

  @override
  String get friend => 'Friend';

  @override
  String get addBack => 'Add back';

  @override
  String get requested => 'Requested';

  @override
  String get add => 'Add';

  @override
  String get acceptAndAddBack => 'Accept and add back';

  @override
  String get rejectRequest => 'Reject request';

  @override
  String get friendActions => 'Friend actions';

  @override
  String get sendMessageAction => 'Message';

  @override
  String get editRemark => 'Edit remark';

  @override
  String get setRemark => 'Set remark';

  @override
  String get removeFriendRelation => 'Remove friend';

  @override
  String get setFriendRemark => 'Set friend remark';

  @override
  String get remarkName => 'Remark name';

  @override
  String get remarkHintClear => 'Leave empty to clear remark';

  @override
  String get save => 'Save';

  @override
  String get groupName => 'Group name';

  @override
  String get groupNameHint => 'Give the group a name';

  @override
  String get selectMembersOptional => 'Select members (optional)';

  @override
  String get create => 'Create';

  @override
  String get newConversation => 'New chat';

  @override
  String get deleteSession => 'Delete session';

  @override
  String confirmDeleteSession(String name) {
    return 'Delete “$name”? Chat history will be removed.';
  }

  @override
  String get delete => 'Delete';

  @override
  String get newChat => 'New chat';

  @override
  String get refreshSessions => 'Refresh sessions';

  @override
  String get signInToUseAiAgent => 'Sign in to use AI Agent';

  @override
  String get aiAgentSubtitle =>
      'Multi-session, streaming replies, and MCP tools';

  @override
  String get selectOrCreateAiSession => 'Select or create an AI session';

  @override
  String get aiSessions => 'AI sessions';

  @override
  String get noAiChatsYet => 'No AI chats yet';

  @override
  String get tapNewToStartChat => 'Tap New below to start chatting';

  @override
  String get thinking => 'Thinking…';

  @override
  String get aiRequestFailed => 'AI request failed';

  @override
  String get noTextReply => '(No text reply)';

  @override
  String get waitingConfirm => 'Waiting for confirmation…';

  @override
  String receivedType(String type) {
    return 'Received $type';
  }

  @override
  String get backToSessionList => 'Back to sessions';

  @override
  String get sendMessageToStart => 'Send a message to start chatting';

  @override
  String get askAiAgent => 'Ask AI Agent…';

  @override
  String emojiPackTitle(Object id) {
    return 'Emoji pack $id';
  }

  @override
  String get noEmojiPacksBuyInShop =>
      'No emoji packs yet — buy some in the store';

  @override
  String replyToUser(String name) {
    return 'Reply @$name';
  }

  @override
  String get user => 'User';

  @override
  String get anonymousUser => 'Anonymous';

  @override
  String get timeUnknown => 'Unknown time';

  @override
  String dateYmd(int year, int month, int day) {
    return '$year-$month-$day';
  }

  @override
  String get tasksInProgress => 'In progress';

  @override
  String get tasksNoInProgress => 'No tasks in progress';

  @override
  String get tasksCompletedSection => 'Completed';

  @override
  String get tasksRewardHint =>
      'Rewards must be claimed manually · Tasks refresh by cycle';

  @override
  String get tasksTodayGoal => 'Today\'s goals';

  @override
  String get tasksTodayGoalSubtitle =>
      'Complete community tasks and claim ChengeCoin';

  @override
  String tasksProgressSummary(int completed) {
    return 'Pending · $completed completed';
  }

  @override
  String get taskClaimable => 'Claimable';

  @override
  String get taskCompletedBadge => 'Done';

  @override
  String taskCheckinStreak(int streak, int totalDays) {
    return 'Checked in $streak days in a row · $totalDays days total';
  }

  @override
  String get checkIn => 'Check in';

  @override
  String get claim => 'Claim';

  @override
  String get statusBarTopHideMask => 'Status bar mask when top bar is hidden';

  @override
  String get statusBarTopHideMaskDescription =>
      'When the top bar can auto-hide, use a translucent theme background for the status bar so content does not go under it (on by default)';

  @override
  String get siteAndToken => 'Site & token';

  @override
  String get officialSite => 'Official site';

  @override
  String webViewInitFailed(String errorType, String error) {
    return 'WebView failed to initialize ($errorType): $error\nWindows requires Edge WebView2 Runtime.';
  }

  @override
  String get registerAccount => 'Create account';

  @override
  String get registerTitle => 'Sign up for ChengeWorld';

  @override
  String get registerSuccess => 'Registration successful. Please sign in.';

  @override
  String get nicknameOptional => 'Nickname (optional)';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get invalidEmail => 'Invalid email format';

  @override
  String get emailCode => 'Email verification code';

  @override
  String get enterEmailCode => 'Enter verification code';

  @override
  String get getEmailCode => 'Get code';

  @override
  String get sendingCode => 'Sending';

  @override
  String get emailCodeSent => 'Code sent (check backend logs in development)';

  @override
  String get fillEmailFirst => 'Please enter your email first';

  @override
  String get passwordMinSix => 'Password (min 6 characters)';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get register => 'Sign up';

  @override
  String get registering => 'Signing up…';

  @override
  String get clearCache => 'Clear cache';

  @override
  String get clearCacheDescription =>
      'Clear local image cache without signing you out';

  @override
  String get clearCacheConfirm => 'Clear local cache?';

  @override
  String get clearCacheDone => 'Cache cleared';

  @override
  String get clearingCache => 'Clearing…';

  @override
  String get accessTokenCleared => 'Access token cleared';
}
