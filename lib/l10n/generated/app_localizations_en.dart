// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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

  @override
  String get createPost => '发帖';

  @override
  String get publishPost => '发布';

  @override
  String get postTitle => '标题';

  @override
  String get postContent => '正文（Markdown）';

  @override
  String get markdownHint => '支持 Markdown，可插入图片';

  @override
  String get insertImage => '插入图片';

  @override
  String get coverImage => '封面图';

  @override
  String get chooseCover => '选择封面';

  @override
  String get removeCover => '移除封面';

  @override
  String get category => '板块';

  @override
  String get selectCategoryHint => '请选择板块';

  @override
  String get noCategories => '暂无可用板块';

  @override
  String get titleRequired => '请填写标题';

  @override
  String get contentRequired => '请填写正文';

  @override
  String get postPublished => '发布成功';

  @override
  String get signInToCreatePost => '登录后即可发帖';

  @override
  String get tagsOptional => '标签（可选）';

  @override
  String get tagsHint => '用逗号或空格分隔';
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

  @override
  String get createPost => 'New post';

  @override
  String get publishPost => 'Publish';

  @override
  String get postTitle => 'Title';

  @override
  String get postContent => 'Content (Markdown)';

  @override
  String get markdownHint => 'Markdown supported. You can insert images.';

  @override
  String get insertImage => 'Insert image';

  @override
  String get coverImage => 'Cover image';

  @override
  String get chooseCover => 'Choose cover';

  @override
  String get removeCover => 'Remove cover';

  @override
  String get category => 'Category';

  @override
  String get selectCategoryHint => 'Please select a category';

  @override
  String get noCategories => 'No categories available';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get contentRequired => 'Content is required';

  @override
  String get postPublished => 'Post published';

  @override
  String get signInToCreatePost => 'Sign in to create a post';

  @override
  String get tagsOptional => 'Tags (optional)';

  @override
  String get tagsHint => 'Separate with commas or spaces';
}
