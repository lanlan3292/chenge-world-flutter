import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ja'),
    Locale('ja', 'JP'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale('zh', 'TW'),
    Locale('ko'),
    Locale('ko', 'KR'),
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

  /// No description provided for @chengeCore.
  ///
  /// In zh_CN, this message translates to:
  /// **'ChengeCore'**
  String get chengeCore;

  /// No description provided for @signInWithToken.
  ///
  /// In zh_CN, this message translates to:
  /// **'使用 Token 登录'**
  String get signInWithToken;

  /// No description provided for @openOfficialSiteWithWebView.
  ///
  /// In zh_CN, this message translates to:
  /// **'使用 WebView 打开官网'**
  String get openOfficialSiteWithWebView;

  /// No description provided for @close.
  ///
  /// In zh_CN, this message translates to:
  /// **'关闭'**
  String get close;

  /// No description provided for @raising.
  ///
  /// In zh_CN, this message translates to:
  /// **'养成'**
  String get raising;

  /// No description provided for @copy.
  ///
  /// In zh_CN, this message translates to:
  /// **'复制'**
  String get copy;

  /// No description provided for @webViewNotSupportedOnAllOs.
  ///
  /// In zh_CN, this message translates to:
  /// **'并非所有操作系统都能够调用 WebView'**
  String get webViewNotSupportedOnAllOs;

  /// No description provided for @platformWebViewNotSupported.
  ///
  /// In zh_CN, this message translates to:
  /// **'当前平台暂不支持内置网页'**
  String get platformWebViewNotSupported;

  /// No description provided for @openCoreEcosystem.
  ///
  /// In zh_CN, this message translates to:
  /// **'打开核心生态'**
  String get openCoreEcosystem;

  /// No description provided for @openRaisingSystem.
  ///
  /// In zh_CN, this message translates to:
  /// **'打开站娘养成系统'**
  String get openRaisingSystem;

  /// No description provided for @cannotOpenSiteMissingConfig.
  ///
  /// In zh_CN, this message translates to:
  /// **'无法打开官网：缺少服务配置'**
  String get cannotOpenSiteMissingConfig;

  /// No description provided for @accessTokenDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'用于校验身份的访问令牌'**
  String get accessTokenDescription;

  /// No description provided for @confirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定'**
  String get confirm;

  /// No description provided for @confirmSignIn.
  ///
  /// In zh_CN, this message translates to:
  /// **'确认登录'**
  String get confirmSignIn;

  /// No description provided for @pasteJwtToken.
  ///
  /// In zh_CN, this message translates to:
  /// **'粘贴 JWT Token'**
  String get pasteJwtToken;

  /// No description provided for @accessToken.
  ///
  /// In zh_CN, this message translates to:
  /// **'访问令牌'**
  String get accessToken;

  /// No description provided for @accessTokenCopied.
  ///
  /// In zh_CN, this message translates to:
  /// **'访问令牌 已复制'**
  String get accessTokenCopied;

  /// No description provided for @accessTokenUpdated.
  ///
  /// In zh_CN, this message translates to:
  /// **'访问令牌 已更新'**
  String get accessTokenUpdated;

  /// No description provided for @signInToUseChengeCore.
  ///
  /// In zh_CN, this message translates to:
  /// **'请先登录后再使用 ChengeCore'**
  String get signInToUseChengeCore;

  /// No description provided for @signInToUseRaising.
  ///
  /// In zh_CN, this message translates to:
  /// **'请先登录后再使用养成'**
  String get signInToUseRaising;

  /// No description provided for @enterToken.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入 Token'**
  String get enterToken;

  /// No description provided for @communityMerchant.
  ///
  /// In zh_CN, this message translates to:
  /// **'社区商家'**
  String get communityMerchant;

  /// No description provided for @product.
  ///
  /// In zh_CN, this message translates to:
  /// **'商品'**
  String get product;

  /// No description provided for @productInitial.
  ///
  /// In zh_CN, this message translates to:
  /// **'商'**
  String get productInitial;

  /// No description provided for @stockCount.
  ///
  /// In zh_CN, this message translates to:
  /// **'库存 {count}'**
  String stockCount(int count);

  /// No description provided for @soldCount.
  ///
  /// In zh_CN, this message translates to:
  /// **'已售 {count}'**
  String soldCount(int count);

  /// No description provided for @ratingReviews.
  ///
  /// In zh_CN, this message translates to:
  /// **'{rating} · {count} 评价'**
  String ratingReviews(String rating, int count);

  /// No description provided for @productDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'商品介绍'**
  String get productDescription;

  /// No description provided for @purchasedContent.
  ///
  /// In zh_CN, this message translates to:
  /// **'已购内容'**
  String get purchasedContent;

  /// No description provided for @purchaseToViewContent.
  ///
  /// In zh_CN, this message translates to:
  /// **'购买后可查看完整内容'**
  String get purchaseToViewContent;

  /// No description provided for @openOrDownloadFile.
  ///
  /// In zh_CN, this message translates to:
  /// **'打开/下载文件'**
  String get openOrDownloadFile;

  /// No description provided for @balanceCc.
  ///
  /// In zh_CN, this message translates to:
  /// **'余额 {amount} CC'**
  String balanceCc(String amount);

  /// No description provided for @buying.
  ///
  /// In zh_CN, this message translates to:
  /// **'购买中…'**
  String get buying;

  /// No description provided for @buy.
  ///
  /// In zh_CN, this message translates to:
  /// **'购买'**
  String get buy;

  /// No description provided for @yourListedProduct.
  ///
  /// In zh_CN, this message translates to:
  /// **'这是你上架的商品'**
  String get yourListedProduct;

  /// No description provided for @backToShop.
  ///
  /// In zh_CN, this message translates to:
  /// **'返回商城'**
  String get backToShop;

  /// No description provided for @holdingQuantityType.
  ///
  /// In zh_CN, this message translates to:
  /// **'持有 {quantity} 件 · {type}'**
  String holdingQuantityType(Object quantity, String type);

  /// No description provided for @orderPending.
  ///
  /// In zh_CN, this message translates to:
  /// **'待支付'**
  String get orderPending;

  /// No description provided for @orderPaid.
  ///
  /// In zh_CN, this message translates to:
  /// **'已支付'**
  String get orderPaid;

  /// No description provided for @orderRefunded.
  ///
  /// In zh_CN, this message translates to:
  /// **'已退款'**
  String get orderRefunded;

  /// No description provided for @statusUnknown.
  ///
  /// In zh_CN, this message translates to:
  /// **'状态未知'**
  String get statusUnknown;

  /// No description provided for @conversationNotFound.
  ///
  /// In zh_CN, this message translates to:
  /// **'未找到该会话，请刷新后重试'**
  String get conversationNotFound;

  /// No description provided for @noMatchingConversations.
  ///
  /// In zh_CN, this message translates to:
  /// **'没有匹配的会话'**
  String get noMatchingConversations;

  /// No description provided for @noConversationsYet.
  ///
  /// In zh_CN, this message translates to:
  /// **'还没有会话'**
  String get noConversationsYet;

  /// No description provided for @goContactsToChat.
  ///
  /// In zh_CN, this message translates to:
  /// **'去通讯录发起聊天'**
  String get goContactsToChat;

  /// No description provided for @friendInitial.
  ///
  /// In zh_CN, this message translates to:
  /// **'友'**
  String get friendInitial;

  /// No description provided for @noMessagesYetShort.
  ///
  /// In zh_CN, this message translates to:
  /// **'还没有消息'**
  String get noMessagesYetShort;

  /// No description provided for @previewEmoji.
  ///
  /// In zh_CN, this message translates to:
  /// **'[表情] {key}'**
  String previewEmoji(String key);

  /// No description provided for @previewSharedPost.
  ///
  /// In zh_CN, this message translates to:
  /// **'[分享帖子]'**
  String get previewSharedPost;

  /// No description provided for @previewOrder.
  ///
  /// In zh_CN, this message translates to:
  /// **'[商品订单]'**
  String get previewOrder;

  /// No description provided for @emojiMessage.
  ///
  /// In zh_CN, this message translates to:
  /// **'表情消息'**
  String get emojiMessage;

  /// No description provided for @me.
  ///
  /// In zh_CN, this message translates to:
  /// **'我'**
  String get me;

  /// No description provided for @sharedPost.
  ///
  /// In zh_CN, this message translates to:
  /// **'分享帖子'**
  String get sharedPost;

  /// No description provided for @productOrder.
  ///
  /// In zh_CN, this message translates to:
  /// **'商品订单'**
  String get productOrder;

  /// No description provided for @cannotOpenPostMissingId.
  ///
  /// In zh_CN, this message translates to:
  /// **'无法打开帖子：分享内容缺少帖子编号'**
  String get cannotOpenPostMissingId;

  /// No description provided for @cannotOpenProductMissingId.
  ///
  /// In zh_CN, this message translates to:
  /// **'无法打开商品：分享内容缺少商品编号'**
  String get cannotOpenProductMissingId;

  /// No description provided for @chengeUser.
  ///
  /// In zh_CN, this message translates to:
  /// **'Chenge 用户'**
  String get chengeUser;

  /// No description provided for @signInToPurchase.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录后才能购买'**
  String get signInToPurchase;

  /// No description provided for @typeMessage.
  ///
  /// In zh_CN, this message translates to:
  /// **'输入消息…'**
  String get typeMessage;

  /// No description provided for @sendMessage.
  ///
  /// In zh_CN, this message translates to:
  /// **'发送消息'**
  String get sendMessage;

  /// No description provided for @emoji.
  ///
  /// In zh_CN, this message translates to:
  /// **'表情'**
  String get emoji;

  /// No description provided for @previewEmojiOnly.
  ///
  /// In zh_CN, this message translates to:
  /// **'[表情]'**
  String get previewEmojiOnly;

  /// No description provided for @enterGroupNameKeyword.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入群名称关键词'**
  String get enterGroupNameKeyword;

  /// No description provided for @enterUserSearchHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入用户名、昵称或邮箱'**
  String get enterUserSearchHint;

  /// No description provided for @friendAddedBack.
  ///
  /// In zh_CN, this message translates to:
  /// **'已回加，现在你们是好友了'**
  String get friendAddedBack;

  /// No description provided for @friendRequestSent.
  ///
  /// In zh_CN, this message translates to:
  /// **'好友申请已发送'**
  String get friendRequestSent;

  /// No description provided for @rejectFriendRequest.
  ///
  /// In zh_CN, this message translates to:
  /// **'拒绝好友申请'**
  String get rejectFriendRequest;

  /// No description provided for @removeFriend.
  ///
  /// In zh_CN, this message translates to:
  /// **'解除好友'**
  String get removeFriend;

  /// No description provided for @confirmRejectFriendRequest.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定拒绝 {name} 的好友申请？'**
  String confirmRejectFriendRequest(String name);

  /// No description provided for @confirmRemoveFriend.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定与 {name} 解除好友关系？'**
  String confirmRemoveFriend(String name);

  /// No description provided for @reject.
  ///
  /// In zh_CN, this message translates to:
  /// **'拒绝'**
  String get reject;

  /// No description provided for @remove.
  ///
  /// In zh_CN, this message translates to:
  /// **'解除'**
  String get remove;

  /// No description provided for @friendRequestRejected.
  ///
  /// In zh_CN, this message translates to:
  /// **'已拒绝好友申请'**
  String get friendRequestRejected;

  /// No description provided for @friendRemoved.
  ///
  /// In zh_CN, this message translates to:
  /// **'已解除好友关系'**
  String get friendRemoved;

  /// No description provided for @remarkCleared.
  ///
  /// In zh_CN, this message translates to:
  /// **'备注已清除'**
  String get remarkCleared;

  /// No description provided for @remarkSaved.
  ///
  /// In zh_CN, this message translates to:
  /// **'备注已保存'**
  String get remarkSaved;

  /// No description provided for @joinedGroup.
  ///
  /// In zh_CN, this message translates to:
  /// **'已加入「{name}」'**
  String joinedGroup(String name);

  /// No description provided for @enterGroupName.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入群名称'**
  String get enterGroupName;

  /// No description provided for @groupCreated.
  ///
  /// In zh_CN, this message translates to:
  /// **'群聊「{name}」已创建'**
  String groupCreated(String name);

  /// No description provided for @createGroupChat.
  ///
  /// In zh_CN, this message translates to:
  /// **'创建群聊'**
  String get createGroupChat;

  /// No description provided for @signInToManageContacts.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录后管理通讯录'**
  String get signInToManageContacts;

  /// No description provided for @contactsSubtitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索用户、加入群聊、处理好友申请'**
  String get contactsSubtitle;

  /// No description provided for @friendsTab.
  ///
  /// In zh_CN, this message translates to:
  /// **'好友 {count}'**
  String friendsTab(int count);

  /// No description provided for @groupsTab.
  ///
  /// In zh_CN, this message translates to:
  /// **'群聊 {count}'**
  String groupsTab(int count);

  /// No description provided for @requestsTab.
  ///
  /// In zh_CN, this message translates to:
  /// **'申请 {count}'**
  String requestsTab(int count);

  /// No description provided for @searchUsers.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜用户'**
  String get searchUsers;

  /// No description provided for @searchGroups.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜群聊'**
  String get searchGroups;

  /// No description provided for @groupNameKeyword.
  ///
  /// In zh_CN, this message translates to:
  /// **'群名称关键词'**
  String get groupNameKeyword;

  /// No description provided for @userSearchHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'用户名、昵称或邮箱'**
  String get userSearchHint;

  /// No description provided for @searchGroupsTooltip.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索群聊'**
  String get searchGroupsTooltip;

  /// No description provided for @searchUsersTooltip.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索用户'**
  String get searchUsersTooltip;

  /// No description provided for @searchPublicGroups.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索公开群聊'**
  String get searchPublicGroups;

  /// No description provided for @searchChengeUsers.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索 ChengeWorld 用户'**
  String get searchChengeUsers;

  /// No description provided for @searchPublicGroupsHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'输入群名称关键词，加入感兴趣的群'**
  String get searchPublicGroupsHint;

  /// No description provided for @searchUsersHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'支持用户名、昵称或邮箱'**
  String get searchUsersHint;

  /// No description provided for @noMatchingGroups.
  ///
  /// In zh_CN, this message translates to:
  /// **'没有找到匹配的群'**
  String get noMatchingGroups;

  /// No description provided for @noMatchingPeople.
  ///
  /// In zh_CN, this message translates to:
  /// **'没有找到匹配的人'**
  String get noMatchingPeople;

  /// No description provided for @tryOtherKeywords.
  ///
  /// In zh_CN, this message translates to:
  /// **'试试其他关键词'**
  String get tryOtherKeywords;

  /// No description provided for @noGroupsYet.
  ///
  /// In zh_CN, this message translates to:
  /// **'还没有群聊'**
  String get noGroupsYet;

  /// No description provided for @noGroupsHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'创建群聊，或在搜索里加入公开群'**
  String get noGroupsHint;

  /// No description provided for @noFriendsYet.
  ///
  /// In zh_CN, this message translates to:
  /// **'还没有好友'**
  String get noFriendsYet;

  /// No description provided for @noFriendsHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索用户名或昵称，认识新朋友'**
  String get noFriendsHint;

  /// No description provided for @noPendingRequests.
  ///
  /// In zh_CN, this message translates to:
  /// **'没有待处理的申请'**
  String get noPendingRequests;

  /// No description provided for @noPendingRequestsHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'新的好友申请会显示在这里'**
  String get noPendingRequestsHint;

  /// No description provided for @groupTapToJoin.
  ///
  /// In zh_CN, this message translates to:
  /// **'群聊 · 点击加入'**
  String get groupTapToJoin;

  /// No description provided for @join.
  ///
  /// In zh_CN, this message translates to:
  /// **'加入'**
  String get join;

  /// No description provided for @enterGroup.
  ///
  /// In zh_CN, this message translates to:
  /// **'进入群聊'**
  String get enterGroup;

  /// No description provided for @requestAddYou.
  ///
  /// In zh_CN, this message translates to:
  /// **'@{username} · 申请添加你'**
  String requestAddYou(String username);

  /// No description provided for @onlineWithRemark.
  ///
  /// In zh_CN, this message translates to:
  /// **'{status} · 备注：{remark} · @{username}'**
  String onlineWithRemark(String status, String remark, String username);

  /// No description provided for @friend.
  ///
  /// In zh_CN, this message translates to:
  /// **'好友'**
  String get friend;

  /// No description provided for @addBack.
  ///
  /// In zh_CN, this message translates to:
  /// **'回加'**
  String get addBack;

  /// No description provided for @requested.
  ///
  /// In zh_CN, this message translates to:
  /// **'已申请'**
  String get requested;

  /// No description provided for @add.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加'**
  String get add;

  /// No description provided for @acceptAndAddBack.
  ///
  /// In zh_CN, this message translates to:
  /// **'回加并接受'**
  String get acceptAndAddBack;

  /// No description provided for @rejectRequest.
  ///
  /// In zh_CN, this message translates to:
  /// **'拒绝申请'**
  String get rejectRequest;

  /// No description provided for @friendActions.
  ///
  /// In zh_CN, this message translates to:
  /// **'好友操作'**
  String get friendActions;

  /// No description provided for @sendMessageAction.
  ///
  /// In zh_CN, this message translates to:
  /// **'发消息'**
  String get sendMessageAction;

  /// No description provided for @editRemark.
  ///
  /// In zh_CN, this message translates to:
  /// **'修改备注'**
  String get editRemark;

  /// No description provided for @setRemark.
  ///
  /// In zh_CN, this message translates to:
  /// **'设置备注'**
  String get setRemark;

  /// No description provided for @removeFriendRelation.
  ///
  /// In zh_CN, this message translates to:
  /// **'解除好友关系'**
  String get removeFriendRelation;

  /// No description provided for @setFriendRemark.
  ///
  /// In zh_CN, this message translates to:
  /// **'设置好友备注'**
  String get setFriendRemark;

  /// No description provided for @remarkName.
  ///
  /// In zh_CN, this message translates to:
  /// **'备注名称'**
  String get remarkName;

  /// No description provided for @remarkHintClear.
  ///
  /// In zh_CN, this message translates to:
  /// **'留空以清除备注'**
  String get remarkHintClear;

  /// No description provided for @save.
  ///
  /// In zh_CN, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @groupName.
  ///
  /// In zh_CN, this message translates to:
  /// **'群名称'**
  String get groupName;

  /// No description provided for @groupNameHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'给群聊起个名字'**
  String get groupNameHint;

  /// No description provided for @selectMembersOptional.
  ///
  /// In zh_CN, this message translates to:
  /// **'选择成员（可选）'**
  String get selectMembersOptional;

  /// No description provided for @create.
  ///
  /// In zh_CN, this message translates to:
  /// **'创建'**
  String get create;

  /// No description provided for @newConversation.
  ///
  /// In zh_CN, this message translates to:
  /// **'新对话'**
  String get newConversation;

  /// No description provided for @deleteSession.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除会话'**
  String get deleteSession;

  /// No description provided for @confirmDeleteSession.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定删除「{name}」？聊天记录将一并清除。'**
  String confirmDeleteSession(String name);

  /// No description provided for @delete.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @newChat.
  ///
  /// In zh_CN, this message translates to:
  /// **'新建对话'**
  String get newChat;

  /// No description provided for @refreshSessions.
  ///
  /// In zh_CN, this message translates to:
  /// **'刷新会话'**
  String get refreshSessions;

  /// No description provided for @signInToUseAiAgent.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录后使用 AI Agent'**
  String get signInToUseAiAgent;

  /// No description provided for @aiAgentSubtitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'支持多会话、流式回复与 MCP 工具'**
  String get aiAgentSubtitle;

  /// No description provided for @selectOrCreateAiSession.
  ///
  /// In zh_CN, this message translates to:
  /// **'选择或新建一个 AI 会话'**
  String get selectOrCreateAiSession;

  /// No description provided for @aiSessions.
  ///
  /// In zh_CN, this message translates to:
  /// **'AI 会话'**
  String get aiSessions;

  /// No description provided for @noAiChatsYet.
  ///
  /// In zh_CN, this message translates to:
  /// **'还没有 AI 对话'**
  String get noAiChatsYet;

  /// No description provided for @tapNewToStartChat.
  ///
  /// In zh_CN, this message translates to:
  /// **'点下方新建开始对话'**
  String get tapNewToStartChat;

  /// No description provided for @thinking.
  ///
  /// In zh_CN, this message translates to:
  /// **'思考中…'**
  String get thinking;

  /// No description provided for @aiRequestFailed.
  ///
  /// In zh_CN, this message translates to:
  /// **'AI 请求失败'**
  String get aiRequestFailed;

  /// No description provided for @noTextReply.
  ///
  /// In zh_CN, this message translates to:
  /// **'（无文本回复）'**
  String get noTextReply;

  /// No description provided for @waitingConfirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'等待确认…'**
  String get waitingConfirm;

  /// No description provided for @receivedType.
  ///
  /// In zh_CN, this message translates to:
  /// **'收到 {type}'**
  String receivedType(String type);

  /// No description provided for @backToSessionList.
  ///
  /// In zh_CN, this message translates to:
  /// **'返回会话列表'**
  String get backToSessionList;

  /// No description provided for @sendMessageToStart.
  ///
  /// In zh_CN, this message translates to:
  /// **'发一条消息开始对话'**
  String get sendMessageToStart;

  /// No description provided for @askAiAgent.
  ///
  /// In zh_CN, this message translates to:
  /// **'向 AI Agent 提问…'**
  String get askAiAgent;

  /// No description provided for @emojiPackTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'表情包 {id}'**
  String emojiPackTitle(Object id);

  /// No description provided for @noEmojiPacksBuyInShop.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无表情包，可在商店购买'**
  String get noEmojiPacksBuyInShop;

  /// No description provided for @replyToUser.
  ///
  /// In zh_CN, this message translates to:
  /// **'回复 @{name}'**
  String replyToUser(String name);

  /// No description provided for @user.
  ///
  /// In zh_CN, this message translates to:
  /// **'用户'**
  String get user;

  /// No description provided for @anonymousUser.
  ///
  /// In zh_CN, this message translates to:
  /// **'匿名用户'**
  String get anonymousUser;

  /// No description provided for @timeUnknown.
  ///
  /// In zh_CN, this message translates to:
  /// **'时间未知'**
  String get timeUnknown;

  /// No description provided for @dateYmd.
  ///
  /// In zh_CN, this message translates to:
  /// **'{year}年{month}月{day}日'**
  String dateYmd(int year, int month, int day);

  /// No description provided for @tasksInProgress.
  ///
  /// In zh_CN, this message translates to:
  /// **'进行中'**
  String get tasksInProgress;

  /// No description provided for @tasksNoInProgress.
  ///
  /// In zh_CN, this message translates to:
  /// **'当前没有进行中的任务'**
  String get tasksNoInProgress;

  /// No description provided for @tasksCompletedSection.
  ///
  /// In zh_CN, this message translates to:
  /// **'已完成'**
  String get tasksCompletedSection;

  /// No description provided for @tasksRewardHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'奖励需要手动领取 · 任务按周期刷新'**
  String get tasksRewardHint;

  /// No description provided for @tasksTodayGoal.
  ///
  /// In zh_CN, this message translates to:
  /// **'今日目标'**
  String get tasksTodayGoal;

  /// No description provided for @tasksTodayGoalSubtitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'完成社区任务，领取 ChengeCoin'**
  String get tasksTodayGoalSubtitle;

  /// No description provided for @tasksProgressSummary.
  ///
  /// In zh_CN, this message translates to:
  /// **'待完成 · {completed} 已完成'**
  String tasksProgressSummary(int completed);

  /// No description provided for @taskClaimable.
  ///
  /// In zh_CN, this message translates to:
  /// **'可领取'**
  String get taskClaimable;

  /// No description provided for @taskCompletedBadge.
  ///
  /// In zh_CN, this message translates to:
  /// **'已完成'**
  String get taskCompletedBadge;

  /// No description provided for @taskCheckinStreak.
  ///
  /// In zh_CN, this message translates to:
  /// **'已连续签到 {streak} 天 · 累计 {totalDays} 天'**
  String taskCheckinStreak(int streak, int totalDays);

  /// No description provided for @checkIn.
  ///
  /// In zh_CN, this message translates to:
  /// **'签到'**
  String get checkIn;

  /// No description provided for @claim.
  ///
  /// In zh_CN, this message translates to:
  /// **'领取'**
  String get claim;

  /// No description provided for @statusBarTopHideMask.
  ///
  /// In zh_CN, this message translates to:
  /// **'顶栏隐藏时状态栏遮罩'**
  String get statusBarTopHideMask;

  /// No description provided for @statusBarTopHideMaskDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'顶栏可自动隐藏时，状态栏使用半透明主题背景，避免内容顶到状态栏（默认开启）'**
  String get statusBarTopHideMaskDescription;

  /// No description provided for @siteAndToken.
  ///
  /// In zh_CN, this message translates to:
  /// **'站点与令牌'**
  String get siteAndToken;

  /// No description provided for @officialSite.
  ///
  /// In zh_CN, this message translates to:
  /// **'官网'**
  String get officialSite;

  /// No description provided for @webViewInitFailed.
  ///
  /// In zh_CN, this message translates to:
  /// **'WebView 初始化失败（{errorType}）：{error}\nWindows 需安装 Edge WebView2 Runtime。'**
  String webViewInitFailed(String errorType, String error);

  /// No description provided for @registerAccount.
  ///
  /// In zh_CN, this message translates to:
  /// **'注册账号'**
  String get registerAccount;

  /// No description provided for @registerTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'注册 ChengeWorld'**
  String get registerTitle;

  /// No description provided for @registerSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'注册成功，请登录'**
  String get registerSuccess;

  /// No description provided for @nicknameOptional.
  ///
  /// In zh_CN, this message translates to:
  /// **'昵称（可选）'**
  String get nicknameOptional;

  /// No description provided for @email.
  ///
  /// In zh_CN, this message translates to:
  /// **'邮箱'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入邮箱'**
  String get enterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In zh_CN, this message translates to:
  /// **'邮箱格式不正确'**
  String get invalidEmail;

  /// No description provided for @emailCode.
  ///
  /// In zh_CN, this message translates to:
  /// **'邮箱验证码'**
  String get emailCode;

  /// No description provided for @enterEmailCode.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入验证码'**
  String get enterEmailCode;

  /// No description provided for @getEmailCode.
  ///
  /// In zh_CN, this message translates to:
  /// **'获取验证码'**
  String get getEmailCode;

  /// No description provided for @sendingCode.
  ///
  /// In zh_CN, this message translates to:
  /// **'发送中'**
  String get sendingCode;

  /// No description provided for @emailCodeSent.
  ///
  /// In zh_CN, this message translates to:
  /// **'验证码已发送（开发环境可查看后端日志）'**
  String get emailCodeSent;

  /// No description provided for @fillEmailFirst.
  ///
  /// In zh_CN, this message translates to:
  /// **'请先填写邮箱'**
  String get fillEmailFirst;

  /// No description provided for @passwordMinSix.
  ///
  /// In zh_CN, this message translates to:
  /// **'密码（至少 6 位）'**
  String get passwordMinSix;

  /// No description provided for @passwordTooShort.
  ///
  /// In zh_CN, this message translates to:
  /// **'密码至少 6 位'**
  String get passwordTooShort;

  /// No description provided for @register.
  ///
  /// In zh_CN, this message translates to:
  /// **'注册'**
  String get register;

  /// No description provided for @registering.
  ///
  /// In zh_CN, this message translates to:
  /// **'注册中…'**
  String get registering;

  /// No description provided for @clearCache.
  ///
  /// In zh_CN, this message translates to:
  /// **'清空缓存'**
  String get clearCache;

  /// No description provided for @clearCacheDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'清除图片等本地缓存，不影响登录状态'**
  String get clearCacheDescription;

  /// No description provided for @clearCacheConfirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定清空本地缓存？'**
  String get clearCacheConfirm;

  /// No description provided for @clearCacheDone.
  ///
  /// In zh_CN, this message translates to:
  /// **'缓存已清空'**
  String get clearCacheDone;

  /// No description provided for @clearingCache.
  ///
  /// In zh_CN, this message translates to:
  /// **'正在清空…'**
  String get clearingCache;

  /// No description provided for @accessTokenCleared.
  ///
  /// In zh_CN, this message translates to:
  /// **'访问令牌已清除'**
  String get accessTokenCleared;

  /// No description provided for @createPost.
  ///
  /// In zh_CN, this message translates to:
  /// **'发帖'**
  String get createPost;

  /// No description provided for @publishPost.
  ///
  /// In zh_CN, this message translates to:
  /// **'发布'**
  String get publishPost;

  /// No description provided for @postTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'标题'**
  String get postTitle;

  /// No description provided for @postContent.
  ///
  /// In zh_CN, this message translates to:
  /// **'正文（Markdown）'**
  String get postContent;

  /// No description provided for @markdownHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'支持 Markdown，可插入图片'**
  String get markdownHint;

  /// No description provided for @insertImage.
  ///
  /// In zh_CN, this message translates to:
  /// **'插入图片'**
  String get insertImage;

  /// No description provided for @coverImage.
  ///
  /// In zh_CN, this message translates to:
  /// **'封面图'**
  String get coverImage;

  /// No description provided for @chooseCover.
  ///
  /// In zh_CN, this message translates to:
  /// **'选择封面'**
  String get chooseCover;

  /// No description provided for @removeCover.
  ///
  /// In zh_CN, this message translates to:
  /// **'移除封面'**
  String get removeCover;

  /// No description provided for @category.
  ///
  /// In zh_CN, this message translates to:
  /// **'板块'**
  String get category;

  /// No description provided for @selectCategoryHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'请选择板块'**
  String get selectCategoryHint;

  /// No description provided for @noCategories.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无可用板块'**
  String get noCategories;

  /// No description provided for @titleRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'请填写标题'**
  String get titleRequired;

  /// No description provided for @contentRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'请填写正文'**
  String get contentRequired;

  /// No description provided for @postPublished.
  ///
  /// In zh_CN, this message translates to:
  /// **'发布成功'**
  String get postPublished;

  /// No description provided for @signInToCreatePost.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录后即可发帖'**
  String get signInToCreatePost;

  /// No description provided for @tagsOptional.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签（可选）'**
  String get tagsOptional;

  /// No description provided for @tagsHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'用逗号或空格分隔'**
  String get tagsHint;

  /// No description provided for @saveDraft.
  ///
  /// In zh_CN, this message translates to:
  /// **'存草稿'**
  String get saveDraft;

  /// No description provided for @draftSaved.
  ///
  /// In zh_CN, this message translates to:
  /// **'草稿已保存'**
  String get draftSaved;

  /// No description provided for @draftAutoSaved.
  ///
  /// In zh_CN, this message translates to:
  /// **'草稿已自动保存 {time}'**
  String draftAutoSaved(String time);

  /// No description provided for @restoreDraftTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'恢复草稿？'**
  String get restoreDraftTitle;

  /// No description provided for @restoreDraftMessage.
  ///
  /// In zh_CN, this message translates to:
  /// **'检测到未发布的草稿，是否恢复？'**
  String get restoreDraftMessage;

  /// No description provided for @restoreDraft.
  ///
  /// In zh_CN, this message translates to:
  /// **'恢复'**
  String get restoreDraft;

  /// No description provided for @discardDraft.
  ///
  /// In zh_CN, this message translates to:
  /// **'丢弃'**
  String get discardDraft;

  /// No description provided for @hotTags.
  ///
  /// In zh_CN, this message translates to:
  /// **'热门标签'**
  String get hotTags;

  /// No description provided for @attachmentUrls.
  ///
  /// In zh_CN, this message translates to:
  /// **'附件 URL'**
  String get attachmentUrls;

  /// No description provided for @attachmentUrlsHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'支持任意附件链接；也可填写 B 站视频链接'**
  String get attachmentUrlsHint;

  /// No description provided for @attachmentUrlHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'https://…'**
  String get attachmentUrlHint;

  /// No description provided for @addAttachmentUrl.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加附件 URL'**
  String get addAttachmentUrl;

  /// No description provided for @removeAttachment.
  ///
  /// In zh_CN, this message translates to:
  /// **'移除附件'**
  String get removeAttachment;

  /// No description provided for @maxImagesReached.
  ///
  /// In zh_CN, this message translates to:
  /// **'最多上传 {count} 张图片'**
  String maxImagesReached(int count);

  /// No description provided for @articleImages.
  ///
  /// In zh_CN, this message translates to:
  /// **'文章图片'**
  String get articleImages;

  /// No description provided for @articleImagesHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'最多 5 张，用于文章内容区展示（非 Markdown）；未设封面时默认用第一张作封面'**
  String get articleImagesHint;

  /// No description provided for @deleteImage.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除图片'**
  String get deleteImage;
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
      <String>['en', 'ja', 'zh', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

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
    case 'ja':
      {
        switch (locale.countryCode) {
          case 'JP':
            return AppLocalizationsJaJp();
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
    case 'ko':
      {
        switch (locale.countryCode) {
          case 'KR':
            return AppLocalizationsKoKr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
