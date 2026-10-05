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
  /// In en_US, this message translates to:
  /// **'ChengeWorld Community'**
  String get communityTitle;

  /// No description provided for @discover.
  ///
  /// In en_US, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @social.
  ///
  /// In en_US, this message translates to:
  /// **'Social'**
  String get social;

  /// No description provided for @store.
  ///
  /// In en_US, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @account.
  ///
  /// In en_US, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @settings.
  ///
  /// In en_US, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en_US, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeMode.
  ///
  /// In en_US, this message translates to:
  /// **'Theme mode'**
  String get themeMode;

  /// No description provided for @followSystem.
  ///
  /// In en_US, this message translates to:
  /// **'Follow system'**
  String get followSystem;

  /// No description provided for @light.
  ///
  /// In en_US, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en_US, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In en_US, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @dynamicColor.
  ///
  /// In en_US, this message translates to:
  /// **'Dynamic color'**
  String get dynamicColor;

  /// No description provided for @dynamicColorDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Use Android 12+ wallpaper colors (Material You)'**
  String get dynamicColorDescription;

  /// No description provided for @themeColor.
  ///
  /// In en_US, this message translates to:
  /// **'Theme color'**
  String get themeColor;

  /// No description provided for @systemBars.
  ///
  /// In en_US, this message translates to:
  /// **'System bars'**
  String get systemBars;

  /// No description provided for @statusBarImmersive.
  ///
  /// In en_US, this message translates to:
  /// **'Transparent status bar'**
  String get statusBarImmersive;

  /// No description provided for @statusBarDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Extend content behind the transparent status bar'**
  String get statusBarDescription;

  /// No description provided for @navigationBarImmersive.
  ///
  /// In en_US, this message translates to:
  /// **'Transparent navigation bar'**
  String get navigationBarImmersive;

  /// No description provided for @navigationBarDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Extend content behind the transparent navigation bar'**
  String get navigationBarDescription;

  /// No description provided for @scrollBehavior.
  ///
  /// In en_US, this message translates to:
  /// **'Scrolling'**
  String get scrollBehavior;

  /// No description provided for @autoHideTopBar.
  ///
  /// In en_US, this message translates to:
  /// **'Auto-hide top bar'**
  String get autoHideTopBar;

  /// No description provided for @autoHideTopDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Hide the app bar when scrolling down in Discover or Store (on by default)'**
  String get autoHideTopDescription;

  /// No description provided for @autoHideBottomBar.
  ///
  /// In en_US, this message translates to:
  /// **'Auto-hide bottom bar'**
  String get autoHideBottomBar;

  /// No description provided for @autoHideBottomDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Hide bottom navigation when scrolling down; the rail stays visible on wide screens'**
  String get autoHideBottomDescription;

  /// No description provided for @chat.
  ///
  /// In en_US, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @showSelfAvatar.
  ///
  /// In en_US, this message translates to:
  /// **'Show my avatar in chats'**
  String get showSelfAvatar;

  /// No description provided for @showSelfAvatarDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Show your avatar beside sent messages (off by default)'**
  String get showSelfAvatarDescription;

  /// No description provided for @showPeerAvatar.
  ///
  /// In en_US, this message translates to:
  /// **'Show the other person’s avatar in private chats'**
  String get showPeerAvatar;

  /// No description provided for @showPeerAvatarDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Show the other person’s avatar beside private messages; group avatars are always shown (off by default)'**
  String get showPeerAvatarDescription;

  /// No description provided for @systemGestures.
  ///
  /// In en_US, this message translates to:
  /// **'System gestures'**
  String get systemGestures;

  /// No description provided for @predictiveBack.
  ///
  /// In en_US, this message translates to:
  /// **'Predictive back'**
  String get predictiveBack;

  /// No description provided for @predictiveBackDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Use predictive back animations on Android 13+ (off by default)'**
  String get predictiveBackDescription;

  /// No description provided for @layout.
  ///
  /// In en_US, this message translates to:
  /// **'Layout'**
  String get layout;

  /// No description provided for @feedColumns.
  ///
  /// In en_US, this message translates to:
  /// **'Discover grid columns'**
  String get feedColumns;

  /// No description provided for @shopColumns.
  ///
  /// In en_US, this message translates to:
  /// **'Store grid columns'**
  String get shopColumns;

  /// No description provided for @columnRange.
  ///
  /// In en_US, this message translates to:
  /// **'Current: {min}–{max} columns (adapts within this range when space allows)'**
  String columnRange(int min, int max);

  /// No description provided for @minimumColumns.
  ///
  /// In en_US, this message translates to:
  /// **'Min {count}'**
  String minimumColumns(int count);

  /// No description provided for @maximumColumns.
  ///
  /// In en_US, this message translates to:
  /// **'Max {count}'**
  String maximumColumns(int count);

  /// No description provided for @postCount.
  ///
  /// In en_US, this message translates to:
  /// **'{count} posts'**
  String postCount(int count);

  /// No description provided for @pageCount.
  ///
  /// In en_US, this message translates to:
  /// **'Page {page} of {total}'**
  String pageCount(int page, int total);

  /// No description provided for @itemCount.
  ///
  /// In en_US, this message translates to:
  /// **'{count} products'**
  String itemCount(int count);

  /// No description provided for @rightNow.
  ///
  /// In en_US, this message translates to:
  /// **'What people are discussing'**
  String get rightNow;

  /// No description provided for @freshDiscussions.
  ///
  /// In en_US, this message translates to:
  /// **'See what is new in the community'**
  String get freshDiscussions;

  /// No description provided for @searchPostsAndTopics.
  ///
  /// In en_US, this message translates to:
  /// **'Search posts and topics'**
  String get searchPostsAndTopics;

  /// No description provided for @search.
  ///
  /// In en_US, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @refreshPosts.
  ///
  /// In en_US, this message translates to:
  /// **'Refresh posts'**
  String get refreshPosts;

  /// No description provided for @latest.
  ///
  /// In en_US, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @popular.
  ///
  /// In en_US, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @featured.
  ///
  /// In en_US, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @noPosts.
  ///
  /// In en_US, this message translates to:
  /// **'No posts yet'**
  String get noPosts;

  /// No description provided for @noPostsHint.
  ///
  /// In en_US, this message translates to:
  /// **'Try another keyword or check back later'**
  String get noPostsHint;

  /// No description provided for @retry.
  ///
  /// In en_US, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @previousPage.
  ///
  /// In en_US, this message translates to:
  /// **'Previous page'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In en_US, this message translates to:
  /// **'Next page'**
  String get nextPage;

  /// No description provided for @signOut.
  ///
  /// In en_US, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @confirmSignOut.
  ///
  /// In en_US, this message translates to:
  /// **'Are you sure you want to sign out of ChengeWorld?'**
  String get confirmSignOut;

  /// No description provided for @cancel.
  ///
  /// In en_US, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @exit.
  ///
  /// In en_US, this message translates to:
  /// **'Sign out'**
  String get exit;

  /// No description provided for @signedOut.
  ///
  /// In en_US, this message translates to:
  /// **'Signed out'**
  String get signedOut;

  /// No description provided for @accountSettingsSignIn.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in to manage account settings'**
  String get accountSettingsSignIn;

  /// No description provided for @signedIn.
  ///
  /// In en_US, this message translates to:
  /// **'Signed in'**
  String get signedIn;

  /// No description provided for @welcome.
  ///
  /// In en_US, this message translates to:
  /// **'Welcome to the community'**
  String get welcome;

  /// No description provided for @accountConnected.
  ///
  /// In en_US, this message translates to:
  /// **'Your account is connected to ChengeWorld'**
  String get accountConnected;

  /// No description provided for @signInForPersonalized.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in to explore personalized content'**
  String get signInForPersonalized;

  /// No description provided for @taskCenter.
  ///
  /// In en_US, this message translates to:
  /// **'Task center'**
  String get taskCenter;

  /// No description provided for @taskCenterDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Check in, complete tasks, and earn ChengeCoin'**
  String get taskCenterDescription;

  /// No description provided for @signIn.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInAccount.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in'**
  String get signInAccount;

  /// No description provided for @signInSuccess.
  ///
  /// In en_US, this message translates to:
  /// **'Signed in successfully'**
  String get signInSuccess;

  /// No description provided for @signInToChengeWorld.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in to ChengeWorld'**
  String get signInToChengeWorld;

  /// No description provided for @username.
  ///
  /// In en_US, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In en_US, this message translates to:
  /// **'Enter a username'**
  String get enterUsername;

  /// No description provided for @password.
  ///
  /// In en_US, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @showPassword.
  ///
  /// In en_US, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en_US, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @enterPassword.
  ///
  /// In en_US, this message translates to:
  /// **'Enter a password'**
  String get enterPassword;

  /// No description provided for @signingIn.
  ///
  /// In en_US, this message translates to:
  /// **'Signing in…'**
  String get signingIn;

  /// No description provided for @contacts.
  ///
  /// In en_US, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @productDetails.
  ///
  /// In en_US, this message translates to:
  /// **'Product details'**
  String get productDetails;

  /// No description provided for @post.
  ///
  /// In en_US, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @shopNow.
  ///
  /// In en_US, this message translates to:
  /// **'Store'**
  String get shopNow;

  /// No description provided for @myAssets.
  ///
  /// In en_US, this message translates to:
  /// **'My assets'**
  String get myAssets;

  /// No description provided for @orders.
  ///
  /// In en_US, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @discoverItems.
  ///
  /// In en_US, this message translates to:
  /// **'Discover products'**
  String get discoverItems;

  /// No description provided for @searchProducts.
  ///
  /// In en_US, this message translates to:
  /// **'Search products'**
  String get searchProducts;

  /// No description provided for @sortProducts.
  ///
  /// In en_US, this message translates to:
  /// **'Sort products'**
  String get sortProducts;

  /// No description provided for @newestArrivals.
  ///
  /// In en_US, this message translates to:
  /// **'Newest arrivals'**
  String get newestArrivals;

  /// No description provided for @popularProducts.
  ///
  /// In en_US, this message translates to:
  /// **'Popular products'**
  String get popularProducts;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en_US, this message translates to:
  /// **'Price: low to high'**
  String get priceLowToHigh;

  /// No description provided for @priceHighToLow.
  ///
  /// In en_US, this message translates to:
  /// **'Price: high to low'**
  String get priceHighToLow;

  /// No description provided for @ratingFirst.
  ///
  /// In en_US, this message translates to:
  /// **'Top rated'**
  String get ratingFirst;

  /// No description provided for @all.
  ///
  /// In en_US, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @files.
  ///
  /// In en_US, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @emojiPacks.
  ///
  /// In en_US, this message translates to:
  /// **'Emoji packs'**
  String get emojiPacks;

  /// No description provided for @components.
  ///
  /// In en_US, this message translates to:
  /// **'Components'**
  String get components;

  /// No description provided for @applications.
  ///
  /// In en_US, this message translates to:
  /// **'Applications'**
  String get applications;

  /// No description provided for @executables.
  ///
  /// In en_US, this message translates to:
  /// **'Executables'**
  String get executables;

  /// No description provided for @libraries.
  ///
  /// In en_US, this message translates to:
  /// **'Libraries'**
  String get libraries;

  /// No description provided for @functionLibraries.
  ///
  /// In en_US, this message translates to:
  /// **'Function libraries'**
  String get functionLibraries;

  /// No description provided for @noAssetsOrOrdersSignIn.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in to view assets and orders'**
  String get noAssetsOrOrdersSignIn;

  /// No description provided for @goSignIn.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in'**
  String get goSignIn;

  /// No description provided for @shopUnavailable.
  ///
  /// In en_US, this message translates to:
  /// **'Store temporarily unavailable'**
  String get shopUnavailable;

  /// No description provided for @checkNetworkAndRetry.
  ///
  /// In en_US, this message translates to:
  /// **'Check your connection and try again'**
  String get checkNetworkAndRetry;

  /// No description provided for @noProducts.
  ///
  /// In en_US, this message translates to:
  /// **'No products yet'**
  String get noProducts;

  /// No description provided for @tryOtherSearch.
  ///
  /// In en_US, this message translates to:
  /// **'Try another keyword or category'**
  String get tryOtherSearch;

  /// No description provided for @noAssets.
  ///
  /// In en_US, this message translates to:
  /// **'No assets yet'**
  String get noAssets;

  /// No description provided for @noOrders.
  ///
  /// In en_US, this message translates to:
  /// **'No orders yet'**
  String get noOrders;

  /// No description provided for @purchasesShowHere.
  ///
  /// In en_US, this message translates to:
  /// **'Your store purchases will appear here'**
  String get purchasesShowHere;

  /// No description provided for @refresh.
  ///
  /// In en_US, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @refreshTasks.
  ///
  /// In en_US, this message translates to:
  /// **'Refresh tasks'**
  String get refreshTasks;

  /// No description provided for @claimComplete.
  ///
  /// In en_US, this message translates to:
  /// **'Continue'**
  String get claimComplete;

  /// No description provided for @rewardClaimed.
  ///
  /// In en_US, this message translates to:
  /// **'Reward claimed: +{coins} CC'**
  String rewardClaimed(String coins);

  /// No description provided for @productPurchaseSuccess.
  ///
  /// In en_US, this message translates to:
  /// **'Purchase complete; added to your assets'**
  String get productPurchaseSuccess;

  /// No description provided for @signInToLike.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in to like this post'**
  String get signInToLike;

  /// No description provided for @signInToComment.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in to comment'**
  String get signInToComment;

  /// No description provided for @commentPublished.
  ///
  /// In en_US, this message translates to:
  /// **'Comment posted'**
  String get commentPublished;

  /// No description provided for @noComments.
  ///
  /// In en_US, this message translates to:
  /// **'No comments yet'**
  String get noComments;

  /// No description provided for @back.
  ///
  /// In en_US, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @commentCount.
  ///
  /// In en_US, this message translates to:
  /// **'Comments · {count}'**
  String commentCount(int count);

  /// No description provided for @refreshComments.
  ///
  /// In en_US, this message translates to:
  /// **'Refresh comments'**
  String get refreshComments;

  /// No description provided for @cancelReply.
  ///
  /// In en_US, this message translates to:
  /// **'Cancel reply'**
  String get cancelReply;

  /// No description provided for @writeComment.
  ///
  /// In en_US, this message translates to:
  /// **'Write a comment…'**
  String get writeComment;

  /// No description provided for @reply.
  ///
  /// In en_US, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @publishing.
  ///
  /// In en_US, this message translates to:
  /// **'Posting…'**
  String get publishing;

  /// No description provided for @publishComment.
  ///
  /// In en_US, this message translates to:
  /// **'Post comment'**
  String get publishComment;

  /// No description provided for @liked.
  ///
  /// In en_US, this message translates to:
  /// **'Liked'**
  String get liked;

  /// No description provided for @like.
  ///
  /// In en_US, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @commentsWithCount.
  ///
  /// In en_US, this message translates to:
  /// **'Comments ({count})'**
  String commentsWithCount(int count);

  /// No description provided for @noMessages.
  ///
  /// In en_US, this message translates to:
  /// **'No messages yet. Say hello!'**
  String get noMessages;

  /// No description provided for @online.
  ///
  /// In en_US, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en_US, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @groupChat.
  ///
  /// In en_US, this message translates to:
  /// **'Group chat'**
  String get groupChat;

  /// No description provided for @loadOlderMessages.
  ///
  /// In en_US, this message translates to:
  /// **'Load earlier messages'**
  String get loadOlderMessages;

  /// No description provided for @backToConversations.
  ///
  /// In en_US, this message translates to:
  /// **'Back to conversations'**
  String get backToConversations;

  /// No description provided for @searchConversation.
  ///
  /// In en_US, this message translates to:
  /// **'Search conversations'**
  String get searchConversation;

  /// No description provided for @addressBook.
  ///
  /// In en_US, this message translates to:
  /// **'Contacts'**
  String get addressBook;

  /// No description provided for @noFriendsToInvite.
  ///
  /// In en_US, this message translates to:
  /// **'No friends to invite yet'**
  String get noFriendsToInvite;

  /// No description provided for @selectConversation.
  ///
  /// In en_US, this message translates to:
  /// **'Select a conversation to start chatting'**
  String get selectConversation;

  /// No description provided for @refreshConversations.
  ///
  /// In en_US, this message translates to:
  /// **'Refresh conversations'**
  String get refreshConversations;

  /// No description provided for @signInToStartChat.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in to start chatting'**
  String get signInToStartChat;

  /// No description provided for @chengeCore.
  ///
  /// In en_US, this message translates to:
  /// **'ChengeCore'**
  String get chengeCore;

  /// No description provided for @signInWithToken.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in with Token'**
  String get signInWithToken;

  /// No description provided for @openOfficialSiteWithWebView.
  ///
  /// In en_US, this message translates to:
  /// **'Open official site with WebView'**
  String get openOfficialSiteWithWebView;

  /// No description provided for @close.
  ///
  /// In en_US, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @raising.
  ///
  /// In en_US, this message translates to:
  /// **'Raising'**
  String get raising;

  /// No description provided for @copy.
  ///
  /// In en_US, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @webViewNotSupportedOnAllOs.
  ///
  /// In en_US, this message translates to:
  /// **'Not all operating systems support WebView'**
  String get webViewNotSupportedOnAllOs;

  /// No description provided for @platformWebViewNotSupported.
  ///
  /// In en_US, this message translates to:
  /// **'Built-in web view is not supported on this platform'**
  String get platformWebViewNotSupported;

  /// No description provided for @openCoreEcosystem.
  ///
  /// In en_US, this message translates to:
  /// **'Open core ecosystem'**
  String get openCoreEcosystem;

  /// No description provided for @openRaisingSystem.
  ///
  /// In en_US, this message translates to:
  /// **'Open raising system'**
  String get openRaisingSystem;

  /// No description provided for @cannotOpenSiteMissingConfig.
  ///
  /// In en_US, this message translates to:
  /// **'Cannot open site: missing service configuration'**
  String get cannotOpenSiteMissingConfig;

  /// No description provided for @accessTokenDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Access token used for identity verification'**
  String get accessTokenDescription;

  /// No description provided for @confirm.
  ///
  /// In en_US, this message translates to:
  /// **'OK'**
  String get confirm;

  /// No description provided for @confirmSignIn.
  ///
  /// In en_US, this message translates to:
  /// **'Confirm sign in'**
  String get confirmSignIn;

  /// No description provided for @pasteJwtToken.
  ///
  /// In en_US, this message translates to:
  /// **'Paste JWT Token'**
  String get pasteJwtToken;

  /// No description provided for @accessToken.
  ///
  /// In en_US, this message translates to:
  /// **'Access token'**
  String get accessToken;

  /// No description provided for @accessTokenCopied.
  ///
  /// In en_US, this message translates to:
  /// **'Access token copied'**
  String get accessTokenCopied;

  /// No description provided for @accessTokenUpdated.
  ///
  /// In en_US, this message translates to:
  /// **'Access token updated'**
  String get accessTokenUpdated;

  /// No description provided for @signInToUseChengeCore.
  ///
  /// In en_US, this message translates to:
  /// **'Please sign in to use ChengeCore'**
  String get signInToUseChengeCore;

  /// No description provided for @signInToUseRaising.
  ///
  /// In en_US, this message translates to:
  /// **'Please sign in to use raising'**
  String get signInToUseRaising;

  /// No description provided for @enterToken.
  ///
  /// In en_US, this message translates to:
  /// **'Please enter token'**
  String get enterToken;

  /// No description provided for @communityMerchant.
  ///
  /// In en_US, this message translates to:
  /// **'Community seller'**
  String get communityMerchant;

  /// No description provided for @product.
  ///
  /// In en_US, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @productInitial.
  ///
  /// In en_US, this message translates to:
  /// **'P'**
  String get productInitial;

  /// No description provided for @stockCount.
  ///
  /// In en_US, this message translates to:
  /// **'Stock {count}'**
  String stockCount(int count);

  /// No description provided for @soldCount.
  ///
  /// In en_US, this message translates to:
  /// **'Sold {count}'**
  String soldCount(int count);

  /// No description provided for @ratingReviews.
  ///
  /// In en_US, this message translates to:
  /// **'{rating} · {count} reviews'**
  String ratingReviews(String rating, int count);

  /// No description provided for @productDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Description'**
  String get productDescription;

  /// No description provided for @purchasedContent.
  ///
  /// In en_US, this message translates to:
  /// **'Purchased content'**
  String get purchasedContent;

  /// No description provided for @purchaseToViewContent.
  ///
  /// In en_US, this message translates to:
  /// **'Purchase to view full content'**
  String get purchaseToViewContent;

  /// No description provided for @openOrDownloadFile.
  ///
  /// In en_US, this message translates to:
  /// **'Open / download file'**
  String get openOrDownloadFile;

  /// No description provided for @balanceCc.
  ///
  /// In en_US, this message translates to:
  /// **'Balance {amount} CC'**
  String balanceCc(String amount);

  /// No description provided for @buying.
  ///
  /// In en_US, this message translates to:
  /// **'Buying…'**
  String get buying;

  /// No description provided for @buy.
  ///
  /// In en_US, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @yourListedProduct.
  ///
  /// In en_US, this message translates to:
  /// **'This is your listed product'**
  String get yourListedProduct;

  /// No description provided for @backToShop.
  ///
  /// In en_US, this message translates to:
  /// **'Back to store'**
  String get backToShop;

  /// No description provided for @holdingQuantityType.
  ///
  /// In en_US, this message translates to:
  /// **'Owned {quantity} · {type}'**
  String holdingQuantityType(Object quantity, String type);

  /// No description provided for @orderPending.
  ///
  /// In en_US, this message translates to:
  /// **'Pending'**
  String get orderPending;

  /// No description provided for @orderPaid.
  ///
  /// In en_US, this message translates to:
  /// **'Paid'**
  String get orderPaid;

  /// No description provided for @orderRefunded.
  ///
  /// In en_US, this message translates to:
  /// **'Refunded'**
  String get orderRefunded;

  /// No description provided for @statusUnknown.
  ///
  /// In en_US, this message translates to:
  /// **'Unknown status'**
  String get statusUnknown;

  /// No description provided for @conversationNotFound.
  ///
  /// In en_US, this message translates to:
  /// **'Conversation not found. Please refresh and try again.'**
  String get conversationNotFound;

  /// No description provided for @noMatchingConversations.
  ///
  /// In en_US, this message translates to:
  /// **'No matching conversations'**
  String get noMatchingConversations;

  /// No description provided for @noConversationsYet.
  ///
  /// In en_US, this message translates to:
  /// **'No conversations yet'**
  String get noConversationsYet;

  /// No description provided for @goContactsToChat.
  ///
  /// In en_US, this message translates to:
  /// **'Go to contacts to start a chat'**
  String get goContactsToChat;

  /// No description provided for @friendInitial.
  ///
  /// In en_US, this message translates to:
  /// **'F'**
  String get friendInitial;

  /// No description provided for @noMessagesYetShort.
  ///
  /// In en_US, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYetShort;

  /// No description provided for @previewEmoji.
  ///
  /// In en_US, this message translates to:
  /// **'[Emoji] {key}'**
  String previewEmoji(String key);

  /// No description provided for @previewSharedPost.
  ///
  /// In en_US, this message translates to:
  /// **'[Shared post]'**
  String get previewSharedPost;

  /// No description provided for @previewOrder.
  ///
  /// In en_US, this message translates to:
  /// **'[Product order]'**
  String get previewOrder;

  /// No description provided for @emojiMessage.
  ///
  /// In en_US, this message translates to:
  /// **'Emoji message'**
  String get emojiMessage;

  /// No description provided for @me.
  ///
  /// In en_US, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @sharedPost.
  ///
  /// In en_US, this message translates to:
  /// **'Shared post'**
  String get sharedPost;

  /// No description provided for @productOrder.
  ///
  /// In en_US, this message translates to:
  /// **'Product order'**
  String get productOrder;

  /// No description provided for @cannotOpenPostMissingId.
  ///
  /// In en_US, this message translates to:
  /// **'Cannot open post: missing post id in share'**
  String get cannotOpenPostMissingId;

  /// No description provided for @cannotOpenProductMissingId.
  ///
  /// In en_US, this message translates to:
  /// **'Cannot open product: missing product id in share'**
  String get cannotOpenProductMissingId;

  /// No description provided for @chengeUser.
  ///
  /// In en_US, this message translates to:
  /// **'Chenge user'**
  String get chengeUser;

  /// No description provided for @signInToPurchase.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in to purchase'**
  String get signInToPurchase;

  /// No description provided for @typeMessage.
  ///
  /// In en_US, this message translates to:
  /// **'Type a message…'**
  String get typeMessage;

  /// No description provided for @sendMessage.
  ///
  /// In en_US, this message translates to:
  /// **'Send message'**
  String get sendMessage;

  /// No description provided for @emoji.
  ///
  /// In en_US, this message translates to:
  /// **'Emoji'**
  String get emoji;

  /// No description provided for @previewEmojiOnly.
  ///
  /// In en_US, this message translates to:
  /// **'[Emoji]'**
  String get previewEmojiOnly;

  /// No description provided for @enterGroupNameKeyword.
  ///
  /// In en_US, this message translates to:
  /// **'Enter a group name keyword'**
  String get enterGroupNameKeyword;

  /// No description provided for @enterUserSearchHint.
  ///
  /// In en_US, this message translates to:
  /// **'Enter username, nickname, or email'**
  String get enterUserSearchHint;

  /// No description provided for @friendAddedBack.
  ///
  /// In en_US, this message translates to:
  /// **'Added back — you are friends now'**
  String get friendAddedBack;

  /// No description provided for @friendRequestSent.
  ///
  /// In en_US, this message translates to:
  /// **'Friend request sent'**
  String get friendRequestSent;

  /// No description provided for @rejectFriendRequest.
  ///
  /// In en_US, this message translates to:
  /// **'Reject friend request'**
  String get rejectFriendRequest;

  /// No description provided for @removeFriend.
  ///
  /// In en_US, this message translates to:
  /// **'Remove friend'**
  String get removeFriend;

  /// No description provided for @confirmRejectFriendRequest.
  ///
  /// In en_US, this message translates to:
  /// **'Reject friend request from {name}?'**
  String confirmRejectFriendRequest(String name);

  /// No description provided for @confirmRemoveFriend.
  ///
  /// In en_US, this message translates to:
  /// **'Remove {name} from friends?'**
  String confirmRemoveFriend(String name);

  /// No description provided for @reject.
  ///
  /// In en_US, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @remove.
  ///
  /// In en_US, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @friendRequestRejected.
  ///
  /// In en_US, this message translates to:
  /// **'Friend request rejected'**
  String get friendRequestRejected;

  /// No description provided for @friendRemoved.
  ///
  /// In en_US, this message translates to:
  /// **'Friend removed'**
  String get friendRemoved;

  /// No description provided for @remarkCleared.
  ///
  /// In en_US, this message translates to:
  /// **'Remark cleared'**
  String get remarkCleared;

  /// No description provided for @remarkSaved.
  ///
  /// In en_US, this message translates to:
  /// **'Remark saved'**
  String get remarkSaved;

  /// No description provided for @joinedGroup.
  ///
  /// In en_US, this message translates to:
  /// **'Joined “{name}”'**
  String joinedGroup(String name);

  /// No description provided for @enterGroupName.
  ///
  /// In en_US, this message translates to:
  /// **'Please enter a group name'**
  String get enterGroupName;

  /// No description provided for @groupCreated.
  ///
  /// In en_US, this message translates to:
  /// **'Group “{name}” created'**
  String groupCreated(String name);

  /// No description provided for @createGroupChat.
  ///
  /// In en_US, this message translates to:
  /// **'Create group chat'**
  String get createGroupChat;

  /// No description provided for @signInToManageContacts.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in to manage contacts'**
  String get signInToManageContacts;

  /// No description provided for @contactsSubtitle.
  ///
  /// In en_US, this message translates to:
  /// **'Search users, join groups, handle friend requests'**
  String get contactsSubtitle;

  /// No description provided for @friendsTab.
  ///
  /// In en_US, this message translates to:
  /// **'Friends {count}'**
  String friendsTab(int count);

  /// No description provided for @groupsTab.
  ///
  /// In en_US, this message translates to:
  /// **'Groups {count}'**
  String groupsTab(int count);

  /// No description provided for @requestsTab.
  ///
  /// In en_US, this message translates to:
  /// **'Requests {count}'**
  String requestsTab(int count);

  /// No description provided for @searchUsers.
  ///
  /// In en_US, this message translates to:
  /// **'Users'**
  String get searchUsers;

  /// No description provided for @searchGroups.
  ///
  /// In en_US, this message translates to:
  /// **'Groups'**
  String get searchGroups;

  /// No description provided for @groupNameKeyword.
  ///
  /// In en_US, this message translates to:
  /// **'Group name keyword'**
  String get groupNameKeyword;

  /// No description provided for @userSearchHint.
  ///
  /// In en_US, this message translates to:
  /// **'Username, nickname, or email'**
  String get userSearchHint;

  /// No description provided for @searchGroupsTooltip.
  ///
  /// In en_US, this message translates to:
  /// **'Search groups'**
  String get searchGroupsTooltip;

  /// No description provided for @searchUsersTooltip.
  ///
  /// In en_US, this message translates to:
  /// **'Search users'**
  String get searchUsersTooltip;

  /// No description provided for @searchPublicGroups.
  ///
  /// In en_US, this message translates to:
  /// **'Search public groups'**
  String get searchPublicGroups;

  /// No description provided for @searchChengeUsers.
  ///
  /// In en_US, this message translates to:
  /// **'Search ChengeWorld users'**
  String get searchChengeUsers;

  /// No description provided for @searchPublicGroupsHint.
  ///
  /// In en_US, this message translates to:
  /// **'Enter a group name to join groups you like'**
  String get searchPublicGroupsHint;

  /// No description provided for @searchUsersHint.
  ///
  /// In en_US, this message translates to:
  /// **'Username, nickname, or email supported'**
  String get searchUsersHint;

  /// No description provided for @noMatchingGroups.
  ///
  /// In en_US, this message translates to:
  /// **'No matching groups'**
  String get noMatchingGroups;

  /// No description provided for @noMatchingPeople.
  ///
  /// In en_US, this message translates to:
  /// **'No matching people'**
  String get noMatchingPeople;

  /// No description provided for @tryOtherKeywords.
  ///
  /// In en_US, this message translates to:
  /// **'Try other keywords'**
  String get tryOtherKeywords;

  /// No description provided for @noGroupsYet.
  ///
  /// In en_US, this message translates to:
  /// **'No groups yet'**
  String get noGroupsYet;

  /// No description provided for @noGroupsHint.
  ///
  /// In en_US, this message translates to:
  /// **'Create a group, or join a public one from search'**
  String get noGroupsHint;

  /// No description provided for @noFriendsYet.
  ///
  /// In en_US, this message translates to:
  /// **'No friends yet'**
  String get noFriendsYet;

  /// No description provided for @noFriendsHint.
  ///
  /// In en_US, this message translates to:
  /// **'Search by username or nickname to meet people'**
  String get noFriendsHint;

  /// No description provided for @noPendingRequests.
  ///
  /// In en_US, this message translates to:
  /// **'No pending requests'**
  String get noPendingRequests;

  /// No description provided for @noPendingRequestsHint.
  ///
  /// In en_US, this message translates to:
  /// **'New friend requests will show up here'**
  String get noPendingRequestsHint;

  /// No description provided for @groupTapToJoin.
  ///
  /// In en_US, this message translates to:
  /// **'Group · tap to join'**
  String get groupTapToJoin;

  /// No description provided for @join.
  ///
  /// In en_US, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @enterGroup.
  ///
  /// In en_US, this message translates to:
  /// **'Enter group'**
  String get enterGroup;

  /// No description provided for @requestAddYou.
  ///
  /// In en_US, this message translates to:
  /// **'@{username} · wants to add you'**
  String requestAddYou(String username);

  /// No description provided for @onlineWithRemark.
  ///
  /// In en_US, this message translates to:
  /// **'{status} · remark: {remark} · @{username}'**
  String onlineWithRemark(String status, String remark, String username);

  /// No description provided for @friend.
  ///
  /// In en_US, this message translates to:
  /// **'Friend'**
  String get friend;

  /// No description provided for @addBack.
  ///
  /// In en_US, this message translates to:
  /// **'Add back'**
  String get addBack;

  /// No description provided for @requested.
  ///
  /// In en_US, this message translates to:
  /// **'Requested'**
  String get requested;

  /// No description provided for @add.
  ///
  /// In en_US, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @acceptAndAddBack.
  ///
  /// In en_US, this message translates to:
  /// **'Accept and add back'**
  String get acceptAndAddBack;

  /// No description provided for @rejectRequest.
  ///
  /// In en_US, this message translates to:
  /// **'Reject request'**
  String get rejectRequest;

  /// No description provided for @friendActions.
  ///
  /// In en_US, this message translates to:
  /// **'Friend actions'**
  String get friendActions;

  /// No description provided for @sendMessageAction.
  ///
  /// In en_US, this message translates to:
  /// **'Message'**
  String get sendMessageAction;

  /// No description provided for @editRemark.
  ///
  /// In en_US, this message translates to:
  /// **'Edit remark'**
  String get editRemark;

  /// No description provided for @setRemark.
  ///
  /// In en_US, this message translates to:
  /// **'Set remark'**
  String get setRemark;

  /// No description provided for @removeFriendRelation.
  ///
  /// In en_US, this message translates to:
  /// **'Remove friend'**
  String get removeFriendRelation;

  /// No description provided for @setFriendRemark.
  ///
  /// In en_US, this message translates to:
  /// **'Set friend remark'**
  String get setFriendRemark;

  /// No description provided for @remarkName.
  ///
  /// In en_US, this message translates to:
  /// **'Remark name'**
  String get remarkName;

  /// No description provided for @remarkHintClear.
  ///
  /// In en_US, this message translates to:
  /// **'Leave empty to clear remark'**
  String get remarkHintClear;

  /// No description provided for @save.
  ///
  /// In en_US, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @groupName.
  ///
  /// In en_US, this message translates to:
  /// **'Group name'**
  String get groupName;

  /// No description provided for @groupNameHint.
  ///
  /// In en_US, this message translates to:
  /// **'Give the group a name'**
  String get groupNameHint;

  /// No description provided for @selectMembersOptional.
  ///
  /// In en_US, this message translates to:
  /// **'Select members (optional)'**
  String get selectMembersOptional;

  /// No description provided for @create.
  ///
  /// In en_US, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @newConversation.
  ///
  /// In en_US, this message translates to:
  /// **'New chat'**
  String get newConversation;

  /// No description provided for @deleteSession.
  ///
  /// In en_US, this message translates to:
  /// **'Delete session'**
  String get deleteSession;

  /// No description provided for @confirmDeleteSession.
  ///
  /// In en_US, this message translates to:
  /// **'Delete “{name}”? Chat history will be removed.'**
  String confirmDeleteSession(String name);

  /// No description provided for @delete.
  ///
  /// In en_US, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @newChat.
  ///
  /// In en_US, this message translates to:
  /// **'New chat'**
  String get newChat;

  /// No description provided for @refreshSessions.
  ///
  /// In en_US, this message translates to:
  /// **'Refresh sessions'**
  String get refreshSessions;

  /// No description provided for @signInToUseAiAgent.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in to use AI Agent'**
  String get signInToUseAiAgent;

  /// No description provided for @aiAgentSubtitle.
  ///
  /// In en_US, this message translates to:
  /// **'Multi-session, streaming replies, and MCP tools'**
  String get aiAgentSubtitle;

  /// No description provided for @selectOrCreateAiSession.
  ///
  /// In en_US, this message translates to:
  /// **'Select or create an AI session'**
  String get selectOrCreateAiSession;

  /// No description provided for @aiSessions.
  ///
  /// In en_US, this message translates to:
  /// **'AI sessions'**
  String get aiSessions;

  /// No description provided for @noAiChatsYet.
  ///
  /// In en_US, this message translates to:
  /// **'No AI chats yet'**
  String get noAiChatsYet;

  /// No description provided for @tapNewToStartChat.
  ///
  /// In en_US, this message translates to:
  /// **'Tap New below to start chatting'**
  String get tapNewToStartChat;

  /// No description provided for @thinking.
  ///
  /// In en_US, this message translates to:
  /// **'Thinking…'**
  String get thinking;

  /// No description provided for @aiRequestFailed.
  ///
  /// In en_US, this message translates to:
  /// **'AI request failed'**
  String get aiRequestFailed;

  /// No description provided for @noTextReply.
  ///
  /// In en_US, this message translates to:
  /// **'(No text reply)'**
  String get noTextReply;

  /// No description provided for @waitingConfirm.
  ///
  /// In en_US, this message translates to:
  /// **'Waiting for confirmation…'**
  String get waitingConfirm;

  /// No description provided for @receivedType.
  ///
  /// In en_US, this message translates to:
  /// **'Received {type}'**
  String receivedType(String type);

  /// No description provided for @backToSessionList.
  ///
  /// In en_US, this message translates to:
  /// **'Back to sessions'**
  String get backToSessionList;

  /// No description provided for @sendMessageToStart.
  ///
  /// In en_US, this message translates to:
  /// **'Send a message to start chatting'**
  String get sendMessageToStart;

  /// No description provided for @askAiAgent.
  ///
  /// In en_US, this message translates to:
  /// **'Ask AI Agent…'**
  String get askAiAgent;

  /// No description provided for @emojiPackTitle.
  ///
  /// In en_US, this message translates to:
  /// **'Emoji pack {id}'**
  String emojiPackTitle(Object id);

  /// No description provided for @noEmojiPacksBuyInShop.
  ///
  /// In en_US, this message translates to:
  /// **'No emoji packs yet — buy some in the store'**
  String get noEmojiPacksBuyInShop;

  /// No description provided for @replyToUser.
  ///
  /// In en_US, this message translates to:
  /// **'Reply @{name}'**
  String replyToUser(String name);

  /// No description provided for @user.
  ///
  /// In en_US, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @anonymousUser.
  ///
  /// In en_US, this message translates to:
  /// **'Anonymous'**
  String get anonymousUser;

  /// No description provided for @timeUnknown.
  ///
  /// In en_US, this message translates to:
  /// **'Unknown time'**
  String get timeUnknown;

  /// No description provided for @dateYmd.
  ///
  /// In en_US, this message translates to:
  /// **'{year}-{month}-{day}'**
  String dateYmd(int year, int month, int day);

  /// No description provided for @tasksInProgress.
  ///
  /// In en_US, this message translates to:
  /// **'In progress'**
  String get tasksInProgress;

  /// No description provided for @tasksNoInProgress.
  ///
  /// In en_US, this message translates to:
  /// **'No tasks in progress'**
  String get tasksNoInProgress;

  /// No description provided for @tasksCompletedSection.
  ///
  /// In en_US, this message translates to:
  /// **'Completed'**
  String get tasksCompletedSection;

  /// No description provided for @tasksRewardHint.
  ///
  /// In en_US, this message translates to:
  /// **'Rewards must be claimed manually · Tasks refresh by cycle'**
  String get tasksRewardHint;

  /// No description provided for @tasksTodayGoal.
  ///
  /// In en_US, this message translates to:
  /// **'Today\'s goals'**
  String get tasksTodayGoal;

  /// No description provided for @tasksTodayGoalSubtitle.
  ///
  /// In en_US, this message translates to:
  /// **'Complete community tasks and claim ChengeCoin'**
  String get tasksTodayGoalSubtitle;

  /// No description provided for @tasksProgressSummary.
  ///
  /// In en_US, this message translates to:
  /// **'Pending · {completed} completed'**
  String tasksProgressSummary(int completed);

  /// No description provided for @taskClaimable.
  ///
  /// In en_US, this message translates to:
  /// **'Claimable'**
  String get taskClaimable;

  /// No description provided for @taskCompletedBadge.
  ///
  /// In en_US, this message translates to:
  /// **'Done'**
  String get taskCompletedBadge;

  /// No description provided for @taskCheckinStreak.
  ///
  /// In en_US, this message translates to:
  /// **'Checked in {streak} days in a row · {totalDays} days total'**
  String taskCheckinStreak(int streak, int totalDays);

  /// No description provided for @checkIn.
  ///
  /// In en_US, this message translates to:
  /// **'Check in'**
  String get checkIn;

  /// No description provided for @claim.
  ///
  /// In en_US, this message translates to:
  /// **'Claim'**
  String get claim;

  /// No description provided for @statusBarTopHideMask.
  ///
  /// In en_US, this message translates to:
  /// **'Status bar mask when top bar is hidden'**
  String get statusBarTopHideMask;

  /// No description provided for @statusBarTopHideMaskDescription.
  ///
  /// In en_US, this message translates to:
  /// **'When the top bar can auto-hide, use a translucent theme background for the status bar so content does not go under it (on by default)'**
  String get statusBarTopHideMaskDescription;

  /// No description provided for @siteAndToken.
  ///
  /// In en_US, this message translates to:
  /// **'Site & token'**
  String get siteAndToken;

  /// No description provided for @officialSite.
  ///
  /// In en_US, this message translates to:
  /// **'Official site'**
  String get officialSite;

  /// No description provided for @webViewInitFailed.
  ///
  /// In en_US, this message translates to:
  /// **'WebView failed to initialize ({errorType}): {error}\nWindows requires Edge WebView2 Runtime.'**
  String webViewInitFailed(String errorType, String error);

  /// No description provided for @registerAccount.
  ///
  /// In en_US, this message translates to:
  /// **'Create account'**
  String get registerAccount;

  /// No description provided for @registerTitle.
  ///
  /// In en_US, this message translates to:
  /// **'Sign up for ChengeWorld'**
  String get registerTitle;

  /// No description provided for @registerSuccess.
  ///
  /// In en_US, this message translates to:
  /// **'Registration successful. Please sign in.'**
  String get registerSuccess;

  /// No description provided for @nicknameOptional.
  ///
  /// In en_US, this message translates to:
  /// **'Nickname (optional)'**
  String get nicknameOptional;

  /// No description provided for @email.
  ///
  /// In en_US, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en_US, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en_US, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// No description provided for @emailCode.
  ///
  /// In en_US, this message translates to:
  /// **'Email verification code'**
  String get emailCode;

  /// No description provided for @enterEmailCode.
  ///
  /// In en_US, this message translates to:
  /// **'Enter verification code'**
  String get enterEmailCode;

  /// No description provided for @getEmailCode.
  ///
  /// In en_US, this message translates to:
  /// **'Get code'**
  String get getEmailCode;

  /// No description provided for @sendingCode.
  ///
  /// In en_US, this message translates to:
  /// **'Sending'**
  String get sendingCode;

  /// No description provided for @emailCodeSent.
  ///
  /// In en_US, this message translates to:
  /// **'Code sent (check backend logs in development)'**
  String get emailCodeSent;

  /// No description provided for @fillEmailFirst.
  ///
  /// In en_US, this message translates to:
  /// **'Please enter your email first'**
  String get fillEmailFirst;

  /// No description provided for @passwordMinSix.
  ///
  /// In en_US, this message translates to:
  /// **'Password (min 6 characters)'**
  String get passwordMinSix;

  /// No description provided for @passwordTooShort.
  ///
  /// In en_US, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @register.
  ///
  /// In en_US, this message translates to:
  /// **'Sign up'**
  String get register;

  /// No description provided for @registering.
  ///
  /// In en_US, this message translates to:
  /// **'Signing up…'**
  String get registering;

  /// No description provided for @clearCache.
  ///
  /// In en_US, this message translates to:
  /// **'Clear cache'**
  String get clearCache;

  /// No description provided for @clearCacheDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Clear local image cache without signing you out'**
  String get clearCacheDescription;

  /// No description provided for @clearCacheConfirm.
  ///
  /// In en_US, this message translates to:
  /// **'Clear local cache?'**
  String get clearCacheConfirm;

  /// No description provided for @clearCacheDone.
  ///
  /// In en_US, this message translates to:
  /// **'Cache cleared'**
  String get clearCacheDone;

  /// No description provided for @clearingCache.
  ///
  /// In en_US, this message translates to:
  /// **'Clearing…'**
  String get clearingCache;

  /// No description provided for @accessTokenCleared.
  ///
  /// In en_US, this message translates to:
  /// **'Access token cleared'**
  String get accessTokenCleared;

  /// No description provided for @createPost.
  ///
  /// In en_US, this message translates to:
  /// **'New post'**
  String get createPost;

  /// No description provided for @publishPost.
  ///
  /// In en_US, this message translates to:
  /// **'Publish'**
  String get publishPost;

  /// No description provided for @postTitle.
  ///
  /// In en_US, this message translates to:
  /// **'Title'**
  String get postTitle;

  /// No description provided for @postContent.
  ///
  /// In en_US, this message translates to:
  /// **'Content (Markdown)'**
  String get postContent;

  /// No description provided for @markdownHint.
  ///
  /// In en_US, this message translates to:
  /// **'Markdown supported. You can insert images.'**
  String get markdownHint;

  /// No description provided for @insertImage.
  ///
  /// In en_US, this message translates to:
  /// **'Insert image'**
  String get insertImage;

  /// No description provided for @coverImage.
  ///
  /// In en_US, this message translates to:
  /// **'Cover image'**
  String get coverImage;

  /// No description provided for @chooseCover.
  ///
  /// In en_US, this message translates to:
  /// **'Choose cover'**
  String get chooseCover;

  /// No description provided for @removeCover.
  ///
  /// In en_US, this message translates to:
  /// **'Remove cover'**
  String get removeCover;

  /// No description provided for @category.
  ///
  /// In en_US, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategoryHint.
  ///
  /// In en_US, this message translates to:
  /// **'Please select a category'**
  String get selectCategoryHint;

  /// No description provided for @noCategories.
  ///
  /// In en_US, this message translates to:
  /// **'No categories available'**
  String get noCategories;

  /// No description provided for @titleRequired.
  ///
  /// In en_US, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// No description provided for @contentRequired.
  ///
  /// In en_US, this message translates to:
  /// **'Content is required'**
  String get contentRequired;

  /// No description provided for @postPublished.
  ///
  /// In en_US, this message translates to:
  /// **'Post published'**
  String get postPublished;

  /// No description provided for @signInToCreatePost.
  ///
  /// In en_US, this message translates to:
  /// **'Sign in to create a post'**
  String get signInToCreatePost;

  /// No description provided for @tagsOptional.
  ///
  /// In en_US, this message translates to:
  /// **'Tags (optional)'**
  String get tagsOptional;

  /// No description provided for @tagsHint.
  ///
  /// In en_US, this message translates to:
  /// **'Separate with commas or spaces'**
  String get tagsHint;

  /// No description provided for @saveDraft.
  ///
  /// In en_US, this message translates to:
  /// **'Save draft'**
  String get saveDraft;

  /// No description provided for @draftSaved.
  ///
  /// In en_US, this message translates to:
  /// **'Draft saved'**
  String get draftSaved;

  /// No description provided for @draftAutoSaved.
  ///
  /// In en_US, this message translates to:
  /// **'Draft auto-saved at {time}'**
  String draftAutoSaved(String time);

  /// No description provided for @restoreDraftTitle.
  ///
  /// In en_US, this message translates to:
  /// **'Restore draft?'**
  String get restoreDraftTitle;

  /// No description provided for @restoreDraftMessage.
  ///
  /// In en_US, this message translates to:
  /// **'An unpublished draft was found. Restore it?'**
  String get restoreDraftMessage;

  /// No description provided for @restoreDraft.
  ///
  /// In en_US, this message translates to:
  /// **'Restore'**
  String get restoreDraft;

  /// No description provided for @discardDraft.
  ///
  /// In en_US, this message translates to:
  /// **'Discard'**
  String get discardDraft;

  /// No description provided for @hotTags.
  ///
  /// In en_US, this message translates to:
  /// **'Hot tags'**
  String get hotTags;

  /// No description provided for @attachmentUrls.
  ///
  /// In en_US, this message translates to:
  /// **'Attachment URLs'**
  String get attachmentUrls;

  /// No description provided for @attachmentUrlsHint.
  ///
  /// In en_US, this message translates to:
  /// **'Any attachment URL; Bilibili video links are also supported'**
  String get attachmentUrlsHint;

  /// No description provided for @attachmentUrlHint.
  ///
  /// In en_US, this message translates to:
  /// **'https://…'**
  String get attachmentUrlHint;

  /// No description provided for @addAttachmentUrl.
  ///
  /// In en_US, this message translates to:
  /// **'Add attachment URL'**
  String get addAttachmentUrl;

  /// No description provided for @removeAttachment.
  ///
  /// In en_US, this message translates to:
  /// **'Remove attachment'**
  String get removeAttachment;

  /// No description provided for @maxImagesReached.
  ///
  /// In en_US, this message translates to:
  /// **'Up to {count} images'**
  String maxImagesReached(int count);

  /// No description provided for @articleImages.
  ///
  /// In en_US, this message translates to:
  /// **'Article images'**
  String get articleImages;

  /// No description provided for @articleImagesHint.
  ///
  /// In en_US, this message translates to:
  /// **'Up to 5 images for the article gallery (not Markdown). First image is used as cover if none is set.'**
  String get articleImagesHint;

  /// No description provided for @deleteImage.
  ///
  /// In en_US, this message translates to:
  /// **'Delete image'**
  String get deleteImage;

  /// No description provided for @bilibiliVideo.
  ///
  /// In en_US, this message translates to:
  /// **'Bilibili video'**
  String get bilibiliVideo;

  /// No description provided for @attachmentLink.
  ///
  /// In en_US, this message translates to:
  /// **'Attachment link'**
  String get attachmentLink;

  /// No description provided for @cannotOpenLink.
  ///
  /// In en_US, this message translates to:
  /// **'Cannot open link'**
  String get cannotOpenLink;

  /// No description provided for @editMarkdown.
  ///
  /// In en_US, this message translates to:
  /// **'Edit'**
  String get editMarkdown;

  /// No description provided for @previewMarkdown.
  ///
  /// In en_US, this message translates to:
  /// **'Preview'**
  String get previewMarkdown;

  /// No description provided for @previewEmpty.
  ///
  /// In en_US, this message translates to:
  /// **'Nothing to preview yet'**
  String get previewEmpty;

  /// No description provided for @editProfile.
  ///
  /// In en_US, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @editProfileDescription.
  ///
  /// In en_US, this message translates to:
  /// **'Update nickname, avatar and bio'**
  String get editProfileDescription;

  /// No description provided for @saveProfile.
  ///
  /// In en_US, this message translates to:
  /// **'Save'**
  String get saveProfile;

  /// No description provided for @profileUpdated.
  ///
  /// In en_US, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @changeAvatar.
  ///
  /// In en_US, this message translates to:
  /// **'Change avatar'**
  String get changeAvatar;

  /// No description provided for @nickname.
  ///
  /// In en_US, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @gender.
  ///
  /// In en_US, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @genderSecret.
  ///
  /// In en_US, this message translates to:
  /// **'Private'**
  String get genderSecret;

  /// No description provided for @genderMale.
  ///
  /// In en_US, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en_US, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @birthday.
  ///
  /// In en_US, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @bio.
  ///
  /// In en_US, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @website.
  ///
  /// In en_US, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @phone.
  ///
  /// In en_US, this message translates to:
  /// **'Phone'**
  String get phone;
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
