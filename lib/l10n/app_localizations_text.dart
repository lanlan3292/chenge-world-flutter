import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

extension AppLocalizationsText on AppLocalizations {
  String translatedText(String source) => switch (source) {
    'ChengeWorld 社区广场' => communityTitle,
    '发现' => discover,
    '社交' => social,
    '商城' => store,
    '我的' => account,
    '设置' => settings,
    '外观' => appearance,
    '主题模式' => themeMode,
    '跟随系统' => followSystem,
    '浅色' => light,
    '深色' => dark,
    '语言' => language,
    '中文（中国）' => localeZhCn,
    '中文（台湾）' => localeZhTw,
    '英语（美国）' => localeEnUs,
    '动态取色' => dynamicColor,
    '使用 Android 12+ 壁纸配色（Material You）' => dynamicColorDescription,
    '主题色' => themeColor,
    '系统栏' => systemBars,
    '状态栏沉浸' => statusBarImmersive,
    '内容延伸至状态栏下方，状态栏透明' => statusBarDescription,
    '导航栏沉浸' => navigationBarImmersive,
    '内容延伸至导航栏下方，导航栏透明' => navigationBarDescription,
    '滚动行为' => scrollBehavior,
    '自动隐藏顶栏' => autoHideTopBar,
    '在发现 / 商城向下滚动时收起页面顶栏（默认开启）' => autoHideTopDescription,
    '自动隐藏底栏' => autoHideBottomBar,
    '在发现 / 商城向下滚动时收起底部导航；宽屏侧边栏不会隐藏' => autoHideBottomDescription,
    '聊天' => chat,
    '在会话聊天显示自己的头像' => showSelfAvatar,
    '自己发送的消息右侧显示头像（默认关闭）' => showSelfAvatarDescription,
    '在私人会话聊天显示对方的头像' => showPeerAvatar,
    '私聊中对方消息左侧显示头像；群聊始终显示成员头像（默认关闭）' => showPeerAvatarDescription,
    '系统手势' => systemGestures,
    '预见式返回' => predictiveBack,
    'Android 13+ 页面过渡使用预见式返回动画（默认关闭）' => predictiveBackDescription,
    '布局' => layout,
    '发现页列数范围' => feedColumns,
    '商店页列数范围' => shopColumns,
    '此刻在聊' => rightNow,
    '看看社区里的新鲜讨论' => freshDiscussions,
    '搜索帖子和话题' => searchPostsAndTopics,
    '搜索' => search,
    '刷新帖子' => refreshPosts,
    '最新' => latest,
    '热门' => popular,
    '精华' => featured,
    '暂时没有帖子' => noPosts,
    '换个关键词或稍后再来看看' => noPostsHint,
    '重试' => retry,
    '上一页' => previousPage,
    '下一页' => nextPage,
    '退出登录' => signOut,
    '确定退出当前 ChengeWorld 账户？' => confirmSignOut,
    '取消' => cancel,
    '退出' => exit,
    '已退出登录' => signedOut,
    '登录后可管理账户设置' => accountSettingsSignIn,
    '已登录' => signedIn,
    '欢迎来到社区' => welcome,
    '账户已连接到 ChengeWorld' => accountConnected,
    '登录后浏览个性化内容' => signInForPersonalized,
    '任务中心' => taskCenter,
    '签到、完成任务并领取 ChengeCoin' => taskCenterDescription,
    '登录' => signIn,
    '登录账户' => signInAccount,
    '登录成功' => signInSuccess,
    '登录 ChengeWorld' => signInToChengeWorld,
    '用户名' => username,
    '请输入用户名' => enterUsername,
    '密码' => password,
    '显示密码' => showPassword,
    '隐藏密码' => hidePassword,
    '请输入密码' => enterPassword,
    '正在登录' => signingIn,
    '通讯录' => contacts,
    '暂无好友可邀请' => noFriendsToInvite,
    '选择一个会话，开始聊天' => selectConversation,
    '商品详情' => productDetails,
    '帖子' => post,
    '逛商城' => shopNow,
    '我的资产' => myAssets,
    '订单' => orders,
    '发现好物' => discoverItems,
    '搜索商品' => searchProducts,
    '排序商品' => sortProducts,
    '最新上架' => newestArrivals,
    '热门商品' => popularProducts,
    '价格从低到高' => priceLowToHigh,
    '价格从高到低' => priceHighToLow,
    '评分优先' => ratingFirst,
    '全部' => all,
    '文件' => files,
    '表情包' => emojiPacks,
    '组件' => components,
    '应用' => applications,
    '可执行' => executables,
    '类库' => libraries,
    '函数库' => functionLibraries,
    '登录后查看资产与订单' => noAssetsOrOrdersSignIn,
    '前往登录' => goSignIn,
    '商城暂时不可用' => shopUnavailable,
    '检查网络后重试' => checkNetworkAndRetry,
    '暂时没有商品' => noProducts,
    '试试其他关键词或分类' => tryOtherSearch,
    '还没有资产' => noAssets,
    '还没有订单' => noOrders,
    '在商城购买的内容会显示在这里' => purchasesShowHere,
    '刷新' => refresh,
    '刷新任务' => refreshTasks,
    '去完成' => claimComplete,
    '购买成功，已加入资产清单' => productPurchaseSuccess,
    '登录后即可点赞' => signInToLike,
    '登录后即可发表评论' => signInToComment,
    '评论已发表' => commentPublished,
    '还没有评论' => noComments,
    '返回' => back,
    '刷新评论' => refreshComments,
    '取消回复' => cancelReply,
    '写下你的评论…' => writeComment,
    '回复' => reply,
    '正在发表' => publishing,
    '发表评论' => publishComment,
    '已点赞' => liked,
    '点赞' => like,
    '还没有消息，打个招呼吧' => noMessages,
    '在线' => online,
    '离线' => offline,
    '群聊' => groupChat,
    '加载更早消息' => loadOlderMessages,
    '返回会话列表' => backToConversations,
    '搜索会话' => searchConversation,
    '刷新会话' => refreshConversations,
    '登录后开始聊天' => signInToStartChat,
    _ => source,
  };

  String rewardClaimedMessage(String coins) => rewardClaimed(coins);

  String commentCountMessage(int count) => commentCount(count);

  String commentsWithCountMessage(int count) => commentsWithCount(count);
}

extension NullableAppLocalizationsText on AppLocalizations? {
  String text(String source) => this?.translatedText(source) ?? source;

  String postCount(int count) => this?.postCount(count) ?? '$count 篇';

  String itemCount(int count) => this?.itemCount(count) ?? '$count 件商品';

  String pageCount(int page, int total) =>
      this?.pageCount(page, total) ?? '第 $page / $total 页';

  String columnRange(int min, int max) =>
      this?.columnRange(min, max) ?? '当前：$min – $max 列（宽度足够时在此范围内自适应）';

  String minimumColumns(int count) =>
      this?.minimumColumns(count) ?? '最小 $count';

  String maximumColumns(int count) =>
      this?.maximumColumns(count) ?? '最大 $count';

  String commentCount(int count) => this?.commentCount(count) ?? '评论 · $count';

  String commentsWithCount(int count) =>
      this?.commentsWithCount(count) ?? '评论 ($count)';
}
