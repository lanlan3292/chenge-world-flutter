import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'US'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @communityTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'ChengeWorld 社区广场'**
  String get communityTitle;

  /// No description provided for @discover.
  ///
  /// In zh_CN, this message translates to:
  /// **'发现'**
  String get discover;

  /// No description provided for @social.
  ///
  /// In zh_CN, this message translates to:
  /// **'社交'**
  String get social;

  /// No description provided for @store.
  ///
  /// In zh_CN, this message translates to:
  /// **'商城'**
  String get store;

  /// No description provided for @account.
  ///
  /// In zh_CN, this message translates to:
  /// **'我的'**
  String get account;

  /// No description provided for @settings.
  ///
  /// In zh_CN, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In zh_CN, this message translates to:
  /// **'外观'**
  String get appearance;

  /// No description provided for @themeMode.
  ///
  /// In zh_CN, this message translates to:
  /// **'主题模式'**
  String get themeMode;

  /// No description provided for @followSystem.
  ///
  /// In zh_CN, this message translates to:
  /// **'跟随系统'**
  String get followSystem;

  /// No description provided for @light.
  ///
  /// In zh_CN, this message translates to:
  /// **'浅色'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In zh_CN, this message translates to:
  /// **'深色'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In zh_CN, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @localeZhCn.
  ///
  /// In zh_CN, this message translates to:
  /// **'中文（中国）'**
  String get localeZhCn;

  /// No description provided for @localeZhTw.
  ///
  /// In zh_CN, this message translates to:
  /// **'中文（台湾）'**
  String get localeZhTw;

  /// No description provided for @localeEnUs.
  ///
  /// In zh_CN, this message translates to:
  /// **'英语（美国）'**
  String get localeEnUs;

  /// No description provided for @dynamicColor.
  ///
  /// In zh_CN, this message translates to:
  /// **'动态取色'**
  String get dynamicColor;

  /// No description provided for @dynamicColorDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'使用 Android 12+ 壁纸配色（Material You）'**
  String get dynamicColorDescription;

  /// No description provided for @themeColor.
  ///
  /// In zh_CN, this message translates to:
  /// **'主题色'**
  String get themeColor;

  /// No description provided for @systemBars.
  ///
  /// In zh_CN, this message translates to:
  /// **'系统栏'**
  String get systemBars;

  /// No description provided for @statusBarImmersive.
  ///
  /// In zh_CN, this message translates to:
  /// **'状态栏沉浸'**
  String get statusBarImmersive;

  /// No description provided for @statusBarDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'内容延伸至状态栏下方，状态栏透明'**
  String get statusBarDescription;

  /// No description provided for @navigationBarImmersive.
  ///
  /// In zh_CN, this message translates to:
  /// **'导航栏沉浸'**
  String get navigationBarImmersive;

  /// No description provided for @navigationBarDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'内容延伸至导航栏下方，导航栏透明'**
  String get navigationBarDescription;

  /// No description provided for @scrollBehavior.
  ///
  /// In zh_CN, this message translates to:
  /// **'滚动行为'**
  String get scrollBehavior;

  /// No description provided for @autoHideTopBar.
  ///
  /// In zh_CN, this message translates to:
  /// **'自动隐藏顶栏'**
  String get autoHideTopBar;

  /// No description provided for @autoHideTopDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'在发现 / 商城向下滚动时收起页面顶栏（默认开启）'**
  String get autoHideTopDescription;

  /// No description provided for @autoHideBottomBar.
  ///
  /// In zh_CN, this message translates to:
  /// **'自动隐藏底栏'**
  String get autoHideBottomBar;

  /// No description provided for @autoHideBottomDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'在发现 / 商城向下滚动时收起底部导航；宽屏侧边栏不会隐藏'**
  String get autoHideBottomDescription;

  /// No description provided for @chat.
  ///
  /// In zh_CN, this message translates to:
  /// **'聊天'**
  String get chat;

  /// No description provided for @showSelfAvatar.
  ///
  /// In zh_CN, this message translates to:
  /// **'在会话聊天显示自己的头像'**
  String get showSelfAvatar;

  /// No description provided for @showSelfAvatarDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'自己发送的消息右侧显示头像（默认关闭）'**
  String get showSelfAvatarDescription;

  /// No description provided for @showPeerAvatar.
  ///
  /// In zh_CN, this message translates to:
  /// **'在私人会话聊天显示对方的头像'**
  String get showPeerAvatar;

  /// No description provided for @showPeerAvatarDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'私聊中对方消息左侧显示头像；群聊始终显示成员头像（默认关闭）'**
  String get showPeerAvatarDescription;

  /// No description provided for @systemGestures.
  ///
  /// In zh_CN, this message translates to:
  /// **'系统手势'**
  String get systemGestures;

  /// No description provided for @predictiveBack.
  ///
  /// In zh_CN, this message translates to:
  /// **'预见式返回'**
  String get predictiveBack;

  /// No description provided for @predictiveBackDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'Android 13+ 页面过渡使用预见式返回动画（默认关闭）'**
  String get predictiveBackDescription;

  /// No description provided for @layout.
  ///
  /// In zh_CN, this message translates to:
  /// **'布局'**
  String get layout;

  /// No description provided for @feedColumns.
  ///
  /// In zh_CN, this message translates to:
  /// **'发现页列数范围'**
  String get feedColumns;

  /// No description provided for @shopColumns.
  ///
  /// In zh_CN, this message translates to:
  /// **'商店页列数范围'**
  String get shopColumns;

  /// No description provided for @columnRange.
  ///
  /// In zh_CN, this message translates to:
  /// **'当前：{min} – {max} 列（宽度足够时在此范围内自适应）'**
  String columnRange(int min, int max);

  /// No description provided for @minimumColumns.
  ///
  /// In zh_CN, this message translates to:
  /// **'最小 {count}'**
  String minimumColumns(int count);

  /// No description provided for @maximumColumns.
  ///
  /// In zh_CN, this message translates to:
  /// **'最大 {count}'**
  String maximumColumns(int count);

  /// No description provided for @postCount.
  ///
  /// In zh_CN, this message translates to:
  /// **'{count} 篇'**
  String postCount(int count);

  /// No description provided for @pageCount.
  ///
  /// In zh_CN, this message translates to:
  /// **'第 {page} / {total} 页'**
  String pageCount(int page, int total);

  /// No description provided for @itemCount.
  ///
  /// In zh_CN, this message translates to:
  /// **'{count} 件商品'**
  String itemCount(int count);

  /// No description provided for @rightNow.
  ///
  /// In zh_CN, this message translates to:
  /// **'此刻在聊'**
  String get rightNow;

  /// No description provided for @freshDiscussions.
  ///
  /// In zh_CN, this message translates to:
  /// **'看看社区里的新鲜讨论'**
  String get freshDiscussions;

  /// No description provided for @searchPostsAndTopics.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索帖子和话题'**
  String get searchPostsAndTopics;

  /// No description provided for @search.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索'**
  String get search;

  /// No description provided for @refreshPosts.
  ///
  /// In zh_CN, this message translates to:
  /// **'刷新帖子'**
  String get refreshPosts;

  /// No description provided for @latest.
  ///
  /// In zh_CN, this message translates to:
  /// **'最新'**
  String get latest;

  /// No description provided for @popular.
  ///
  /// In zh_CN, this message translates to:
  /// **'热门'**
  String get popular;

  /// No description provided for @featured.
  ///
  /// In zh_CN, this message translates to:
  /// **'精华'**
  String get featured;

  /// No description provided for @noPosts.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂时没有帖子'**
  String get noPosts;

  /// No description provided for @noPostsHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'换个关键词或稍后再来看看'**
  String get noPostsHint;

  /// No description provided for @retry.
  ///
  /// In zh_CN, this message translates to:
  /// **'重试'**
  String get retry;

  /// No description provided for @previousPage.
  ///
  /// In zh_CN, this message translates to:
  /// **'上一页'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In zh_CN, this message translates to:
  /// **'下一页'**
  String get nextPage;

  /// No description provided for @signOut.
  ///
  /// In zh_CN, this message translates to:
  /// **'退出登录'**
  String get signOut;

  /// No description provided for @confirmSignOut.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定退出当前 ChengeWorld 账户？'**
  String get confirmSignOut;

  /// No description provided for @cancel.
  ///
  /// In zh_CN, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @exit.
  ///
  /// In zh_CN, this message translates to:
  /// **'退出'**
  String get exit;

  /// No description provided for @signedOut.
  ///
  /// In zh_CN, this message translates to:
  /// **'已退出登录'**
  String get signedOut;

  /// No description provided for @accountSettingsSignIn.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录后可管理账户设置'**
  String get accountSettingsSignIn;

  /// No description provided for @signedIn.
  ///
  /// In zh_CN, this message translates to:
  /// **'已登录'**
  String get signedIn;

  /// No description provided for @welcome.
  ///
  /// In zh_CN, this message translates to:
  /// **'欢迎来到社区'**
  String get welcome;

  /// No description provided for @accountConnected.
  ///
  /// In zh_CN, this message translates to:
  /// **'账户已连接到 ChengeWorld'**
  String get accountConnected;

  /// No description provided for @signInForPersonalized.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录后浏览个性化内容'**
  String get signInForPersonalized;

  /// No description provided for @taskCenter.
  ///
  /// In zh_CN, this message translates to:
  /// **'任务中心'**
  String get taskCenter;

  /// No description provided for @taskCenterDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'签到、完成任务并领取 ChengeCoin'**
  String get taskCenterDescription;

  /// No description provided for @signIn.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录'**
  String get signIn;

  /// No description provided for @signInAccount.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录账户'**
  String get signInAccount;

  /// No description provided for @signInSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录成功'**
  String get signInSuccess;

  /// No description provided for @signInToChengeWorld.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录 ChengeWorld'**
  String get signInToChengeWorld;

  /// No description provided for @username.
  ///
  /// In zh_CN, this message translates to:
  /// **'用户名'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入用户名'**
  String get enterUsername;

  /// No description provided for @password.
  ///
  /// In zh_CN, this message translates to:
  /// **'密码'**
  String get password;

  /// No description provided for @showPassword.
  ///
  /// In zh_CN, this message translates to:
  /// **'显示密码'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In zh_CN, this message translates to:
  /// **'隐藏密码'**
  String get hidePassword;

  /// No description provided for @enterPassword.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入密码'**
  String get enterPassword;

  /// No description provided for @signingIn.
  ///
  /// In zh_CN, this message translates to:
  /// **'正在登录'**
  String get signingIn;

  /// No description provided for @contacts.
  ///
  /// In zh_CN, this message translates to:
  /// **'通讯录'**
  String get contacts;

  /// No description provided for @productDetails.
  ///
  /// In zh_CN, this message translates to:
  /// **'商品详情'**
  String get productDetails;

  /// No description provided for @post.
  ///
  /// In zh_CN, this message translates to:
  /// **'帖子'**
  String get post;

  /// No description provided for @shopNow.
  ///
  /// In zh_CN, this message translates to:
  /// **'逛商城'**
  String get shopNow;

  /// No description provided for @myAssets.
  ///
  /// In zh_CN, this message translates to:
  /// **'我的资产'**
  String get myAssets;

  /// No description provided for @orders.
  ///
  /// In zh_CN, this message translates to:
  /// **'订单'**
  String get orders;

  /// No description provided for @discoverItems.
  ///
  /// In zh_CN, this message translates to:
  /// **'发现好物'**
  String get discoverItems;

  /// No description provided for @searchProducts.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索商品'**
  String get searchProducts;

  /// No description provided for @sortProducts.
  ///
  /// In zh_CN, this message translates to:
  /// **'排序商品'**
  String get sortProducts;

  /// No description provided for @newestArrivals.
  ///
  /// In zh_CN, this message translates to:
  /// **'最新上架'**
  String get newestArrivals;

  /// No description provided for @popularProducts.
  ///
  /// In zh_CN, this message translates to:
  /// **'热门商品'**
  String get popularProducts;

  /// No description provided for @priceLowToHigh.
  ///
  /// In zh_CN, this message translates to:
  /// **'价格从低到高'**
  String get priceLowToHigh;

  /// No description provided for @priceHighToLow.
  ///
  /// In zh_CN, this message translates to:
  /// **'价格从高到低'**
  String get priceHighToLow;

  /// No description provided for @ratingFirst.
  ///
  /// In zh_CN, this message translates to:
  /// **'评分优先'**
  String get ratingFirst;

  /// No description provided for @all.
  ///
  /// In zh_CN, this message translates to:
  /// **'全部'**
  String get all;

  /// No description provided for @files.
  ///
  /// In zh_CN, this message translates to:
  /// **'文件'**
  String get files;

  /// No description provided for @emojiPacks.
  ///
  /// In zh_CN, this message translates to:
  /// **'表情包'**
  String get emojiPacks;

  /// No description provided for @components.
  ///
  /// In zh_CN, this message translates to:
  /// **'组件'**
  String get components;

  /// No description provided for @applications.
  ///
  /// In zh_CN, this message translates to:
  /// **'应用'**
  String get applications;

  /// No description provided for @executables.
  ///
  /// In zh_CN, this message translates to:
  /// **'可执行'**
  String get executables;

  /// No description provided for @libraries.
  ///
  /// In zh_CN, this message translates to:
  /// **'类库'**
  String get libraries;

  /// No description provided for @functionLibraries.
  ///
  /// In zh_CN, this message translates to:
  /// **'函数库'**
  String get functionLibraries;

  /// No description provided for @noAssetsOrOrdersSignIn.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录后查看资产与订单'**
  String get noAssetsOrOrdersSignIn;

  /// No description provided for @goSignIn.
  ///
  /// In zh_CN, this message translates to:
  /// **'前往登录'**
  String get goSignIn;

  /// No description provided for @shopUnavailable.
  ///
  /// In zh_CN, this message translates to:
  /// **'商城暂时不可用'**
  String get shopUnavailable;

  /// No description provided for @checkNetworkAndRetry.
  ///
  /// In zh_CN, this message translates to:
  /// **'检查网络后重试'**
  String get checkNetworkAndRetry;

  /// No description provided for @noProducts.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂时没有商品'**
  String get noProducts;

  /// No description provided for @tryOtherSearch.
  ///
  /// In zh_CN, this message translates to:
  /// **'试试其他关键词或分类'**
  String get tryOtherSearch;

  /// No description provided for @noAssets.
  ///
  /// In zh_CN, this message translates to:
  /// **'还没有资产'**
  String get noAssets;

  /// No description provided for @noOrders.
  ///
  /// In zh_CN, this message translates to:
  /// **'还没有订单'**
  String get noOrders;

  /// No description provided for @purchasesShowHere.
  ///
  /// In zh_CN, this message translates to:
  /// **'在商城购买的内容会显示在这里'**
  String get purchasesShowHere;

  /// No description provided for @refresh.
  ///
  /// In zh_CN, this message translates to:
  /// **'刷新'**
  String get refresh;

  /// No description provided for @refreshTasks.
  ///
  /// In zh_CN, this message translates to:
  /// **'刷新任务'**
  String get refreshTasks;

  /// No description provided for @claimComplete.
  ///
  /// In zh_CN, this message translates to:
  /// **'去完成'**
  String get claimComplete;

  /// No description provided for @rewardClaimed.
  ///
  /// In zh_CN, this message translates to:
  /// **'奖励已领取，+{coins} CC'**
  String rewardClaimed(String coins);

  /// No description provided for @productPurchaseSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'购买成功，已加入资产清单'**
  String get productPurchaseSuccess;

  /// No description provided for @signInToLike.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录后即可点赞'**
  String get signInToLike;

  /// No description provided for @signInToComment.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录后即可发表评论'**
  String get signInToComment;

  /// No description provided for @commentPublished.
  ///
  /// In zh_CN, this message translates to:
  /// **'评论已发表'**
  String get commentPublished;

  /// No description provided for @noComments.
  ///
  /// In zh_CN, this message translates to:
  /// **'还没有评论'**
  String get noComments;

  /// No description provided for @back.
  ///
  /// In zh_CN, this message translates to:
  /// **'返回'**
  String get back;

  /// No description provided for @commentCount.
  ///
  /// In zh_CN, this message translates to:
  /// **'评论 · {count}'**
  String commentCount(int count);

  /// No description provided for @refreshComments.
  ///
  /// In zh_CN, this message translates to:
  /// **'刷新评论'**
  String get refreshComments;

  /// No description provided for @cancelReply.
  ///
  /// In zh_CN, this message translates to:
  /// **'取消回复'**
  String get cancelReply;

  /// No description provided for @writeComment.
  ///
  /// In zh_CN, this message translates to:
  /// **'写下你的评论…'**
  String get writeComment;

  /// No description provided for @reply.
  ///
  /// In zh_CN, this message translates to:
  /// **'回复'**
  String get reply;

  /// No description provided for @publishing.
  ///
  /// In zh_CN, this message translates to:
  /// **'正在发表'**
  String get publishing;

  /// No description provided for @publishComment.
  ///
  /// In zh_CN, this message translates to:
  /// **'发表评论'**
  String get publishComment;

  /// No description provided for @liked.
  ///
  /// In zh_CN, this message translates to:
  /// **'已点赞'**
  String get liked;

  /// No description provided for @like.
  ///
  /// In zh_CN, this message translates to:
  /// **'点赞'**
  String get like;

  /// No description provided for @commentsWithCount.
  ///
  /// In zh_CN, this message translates to:
  /// **'评论 ({count})'**
  String commentsWithCount(int count);

  /// No description provided for @noMessages.
  ///
  /// In zh_CN, this message translates to:
  /// **'还没有消息，打个招呼吧'**
  String get noMessages;

  /// No description provided for @online.
  ///
  /// In zh_CN, this message translates to:
  /// **'在线'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In zh_CN, this message translates to:
  /// **'离线'**
  String get offline;

  /// No description provided for @groupChat.
  ///
  /// In zh_CN, this message translates to:
  /// **'群聊'**
  String get groupChat;

  /// No description provided for @loadOlderMessages.
  ///
  /// In zh_CN, this message translates to:
  /// **'加载更早消息'**
  String get loadOlderMessages;

  /// No description provided for @backToConversations.
  ///
  /// In zh_CN, this message translates to:
  /// **'返回会话列表'**
  String get backToConversations;

  /// No description provided for @searchConversation.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索会话'**
  String get searchConversation;

  /// No description provided for @addressBook.
  ///
  /// In zh_CN, this message translates to:
  /// **'通讯录'**
  String get addressBook;

  /// No description provided for @noFriendsToInvite.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无好友可邀请'**
  String get noFriendsToInvite;

  /// No description provided for @selectConversation.
  ///
  /// In zh_CN, this message translates to:
  /// **'选择一个会话，开始聊天'**
  String get selectConversation;

  /// No description provided for @refreshConversations.
  ///
  /// In zh_CN, this message translates to:
  /// **'刷新会话'**
  String get refreshConversations;

  /// No description provided for @signInToStartChat.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录后开始聊天'**
  String get signInToStartChat;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'US':
            return AppLocalizationsEnUs();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
