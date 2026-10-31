// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get communityTitle => 'ChengeWorld コミュニティ';

  @override
  String get discover => '発見';

  @override
  String get social => 'ソーシャル';

  @override
  String get store => 'ストア';

  @override
  String get account => 'アカウント';

  @override
  String get settings => '設定';

  @override
  String get appearance => '外観';

  @override
  String get themeMode => 'テーマモード';

  @override
  String get followSystem => 'システムに従う';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get language => '言語';

  @override
  String get dynamicColor => 'ダイナミックカラー';

  @override
  String get dynamicColorDescription => 'Android 12+ の壁紙の色を使用（Material You）';

  @override
  String get themeColor => 'テーマカラー';

  @override
  String get systemBars => 'システムバー';

  @override
  String get statusBarImmersive => 'ステータスバーを透過';

  @override
  String get statusBarDescription => 'コンテンツを透過ステータスバーの背後まで拡張します';

  @override
  String get navigationBarImmersive => 'ナビゲーションバーを透過';

  @override
  String get navigationBarDescription => 'コンテンツを透過ナビゲーションバーの背後まで拡張します';

  @override
  String get scrollBehavior => 'スクロール動作';

  @override
  String get autoHideTopBar => 'トップバーを自動非表示';

  @override
  String get autoHideTopDescription => '発見/ストアで下にスクロールするとアプリバーを非表示にします（既定でオン）';

  @override
  String get autoHideBottomBar => 'ボトムバーを自動非表示';

  @override
  String get autoHideBottomDescription =>
      '下にスクロールするとボトムナビゲーションを非表示にします。ワイド画面ではレールは表示されたままです';

  @override
  String get chat => 'チャット';

  @override
  String get showSelfAvatar => 'チャットで自分のアバターを表示';

  @override
  String get showSelfAvatarDescription => '送信メッセージの横に自分のアバターを表示します（既定でオフ）';

  @override
  String get showPeerAvatar => '個人チャットで相手のアバターを表示';

  @override
  String get showPeerAvatarDescription =>
      '個人メッセージの横に相手のアバターを表示します。グループのアバターは常に表示されます（既定でオフ）';

  @override
  String get systemGestures => 'システムジェスチャー';

  @override
  String get predictiveBack => '予測型戻る';

  @override
  String get predictiveBackDescription =>
      'Android 13+ で予測型戻るアニメーションを使用します（既定でオフ）';

  @override
  String get layout => 'レイアウト';

  @override
  String get feedColumns => '発見グリッドの列数';

  @override
  String get shopColumns => 'ストアグリッドの列数';

  @override
  String columnRange(int min, int max) {
    return '現在: $min～$max 列（スペースがある場合はこの範囲内で自動調整）';
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
    return '投稿 $count 件';
  }

  @override
  String pageCount(int page, int total) {
    return '$total ページ中 $page ページ';
  }

  @override
  String itemCount(int count) {
    return '商品 $count 件';
  }

  @override
  String get rightNow => '今話していること';

  @override
  String get freshDiscussions => 'コミュニティの新しい話題をチェック';

  @override
  String get searchPostsAndTopics => '投稿とトピックを検索';

  @override
  String get search => '検索';

  @override
  String get refreshPosts => '投稿を更新';

  @override
  String get latest => '最新';

  @override
  String get popular => '人気';

  @override
  String get featured => '注目';

  @override
  String get noPosts => 'まだ投稿がありません';

  @override
  String get noPostsHint => '別のキーワードを試すか、後でもう一度確認してください';

  @override
  String get retry => '再試行';

  @override
  String get previousPage => '前のページ';

  @override
  String get nextPage => '次のページ';

  @override
  String get signOut => 'ログアウト';

  @override
  String get confirmSignOut => 'ChengeWorld からログアウトしてもよろしいですか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get exit => 'ログアウト';

  @override
  String get signedOut => 'ログアウトしました';

  @override
  String get accountSettingsSignIn => 'アカウント設定を管理するにはログインしてください';

  @override
  String get signedIn => 'ログイン済み';

  @override
  String get welcome => 'コミュニティへようこそ';

  @override
  String get accountConnected => 'アカウントは ChengeWorld に接続されています';

  @override
  String get signInForPersonalized => 'ログインしてパーソナライズされたコンテンツを探索';

  @override
  String get taskCenter => 'タスクセンター';

  @override
  String get taskCenterDescription => 'チェックイン、タスク完了で ChengeCoin を獲得';

  @override
  String get signIn => 'ログイン';

  @override
  String get signInAccount => 'ログイン';

  @override
  String get signInSuccess => 'ログインに成功しました';

  @override
  String get signInToChengeWorld => 'ChengeWorld にログイン';

  @override
  String get username => 'ユーザー名';

  @override
  String get enterUsername => 'ユーザー名を入力';

  @override
  String get password => 'パスワード';

  @override
  String get showPassword => 'パスワードを表示';

  @override
  String get hidePassword => 'パスワードを非表示';

  @override
  String get enterPassword => 'パスワードを入力';

  @override
  String get signingIn => 'ログイン中…';

  @override
  String get contacts => '連絡先';

  @override
  String get productDetails => '商品詳細';

  @override
  String get post => '投稿';

  @override
  String get shopNow => 'ストア';

  @override
  String get myAssets => 'マイ資産';

  @override
  String get orders => '注文';

  @override
  String get discoverItems => '商品を発見';

  @override
  String get searchProducts => '商品を検索';

  @override
  String get sortProducts => '商品を並べ替え';

  @override
  String get newestArrivals => '新着';

  @override
  String get popularProducts => '人気商品';

  @override
  String get priceLowToHigh => '価格: 安い順';

  @override
  String get priceHighToLow => '価格: 高い順';

  @override
  String get ratingFirst => '評価が高い順';

  @override
  String get all => 'すべて';

  @override
  String get files => 'ファイル';

  @override
  String get emojiPacks => '絵文字パック';

  @override
  String get components => 'コンポーネント';

  @override
  String get applications => 'アプリケーション';

  @override
  String get executables => '実行ファイル';

  @override
  String get libraries => 'ライブラリ';

  @override
  String get functionLibraries => '関数ライブラリ';

  @override
  String get noAssetsOrOrdersSignIn => '資産と注文を表示するにはログインしてください';

  @override
  String get goSignIn => 'ログイン';

  @override
  String get shopUnavailable => 'ストアは一時的に利用できません';

  @override
  String get checkNetworkAndRetry => '接続を確認して再試行してください';

  @override
  String get noProducts => 'まだ商品がありません';

  @override
  String get tryOtherSearch => '別のキーワードやカテゴリを試してください';

  @override
  String get noAssets => 'まだ資産がありません';

  @override
  String get noOrders => 'まだ注文がありません';

  @override
  String get purchasesShowHere => 'ストアでの購入内容がここに表示されます';

  @override
  String get refresh => '更新';

  @override
  String get refreshTasks => 'タスクを更新';

  @override
  String get claimComplete => '完了する';

  @override
  String rewardClaimed(String coins) {
    return '報酬を受け取りました: +$coins CC';
  }

  @override
  String get productPurchaseSuccess => '購入が完了しました。資産に追加されました';

  @override
  String get signInToLike => 'この投稿にいいねするにはログインしてください';

  @override
  String get signInToComment => 'コメントするにはログインしてください';

  @override
  String get commentPublished => 'コメントを投稿しました';

  @override
  String get noComments => 'まだコメントがありません';

  @override
  String get back => '戻る';

  @override
  String commentCount(int count) {
    return 'コメント · $count';
  }

  @override
  String get refreshComments => 'コメントを更新';

  @override
  String get cancelReply => '返信をキャンセル';

  @override
  String get writeComment => 'コメントを書く…';

  @override
  String get reply => '返信';

  @override
  String get publishing => '投稿中…';

  @override
  String get publishComment => 'コメントを投稿';

  @override
  String get liked => 'いいね済み';

  @override
  String get like => 'いいね';

  @override
  String commentsWithCount(int count) {
    return 'コメント ($count)';
  }

  @override
  String get noMessages => 'まだメッセージがありません。挨拶してみましょう！';

  @override
  String get online => 'オンライン';

  @override
  String get offline => 'オフライン';

  @override
  String get groupChat => 'グループチャット';

  @override
  String get loadOlderMessages => '以前のメッセージを読み込む';

  @override
  String get backToConversations => '会話一覧に戻る';

  @override
  String get searchConversation => '会話を検索';

  @override
  String get addressBook => '連絡先';

  @override
  String get noFriendsToInvite => '招待できる友達がまだいません';

  @override
  String get selectConversation => '会話を選択してチャットを開始';

  @override
  String get refreshConversations => '会話を更新';

  @override
  String get signInToStartChat => 'チャットを開始するにはログインしてください';

  @override
  String get chengeCore => 'ChengeCore';

  @override
  String get signInWithToken => 'Token でログイン';

  @override
  String get openOfficialSiteWithWebView => 'WebView で公式サイトを開く';

  @override
  String get close => '閉じる';

  @override
  String get raising => '育成';

  @override
  String get copy => 'コピー';

  @override
  String get webViewNotSupportedOnAllOs =>
      'すべての OS で WebView がサポートされているわけではありません';

  @override
  String get platformWebViewNotSupported =>
      'このプラットフォームでは内蔵 Web ビューはサポートされていません';

  @override
  String get openCoreEcosystem => 'コアエコシステムを開く';

  @override
  String get openRaisingSystem => '育成システムを開く';

  @override
  String get cannotOpenSiteMissingConfig => 'サイトを開けません: サービス設定がありません';

  @override
  String get accessTokenDescription => '本人確認に使用するアクセストークン';

  @override
  String get confirm => 'OK';

  @override
  String get confirmSignIn => 'ログインを確認';

  @override
  String get pasteJwtToken => 'JWT Token を貼り付け';

  @override
  String get accessToken => 'アクセストークン';

  @override
  String get accessTokenCopied => 'アクセストークンをコピーしました';

  @override
  String get accessTokenUpdated => 'アクセストークンを更新しました';

  @override
  String get signInToUseChengeCore => 'ChengeCore を使用するにはログインしてください';

  @override
  String get signInToUseRaising => '育成を使用するにはログインしてください';

  @override
  String get enterToken => 'Token を入力してください';

  @override
  String get communityMerchant => 'コミュニティ販売者';

  @override
  String get product => '商品';

  @override
  String get productInitial => '商';

  @override
  String get productUnderReview => '商品を審査中です';

  @override
  String get productRejected => '商品が審査を通りませんでした';

  @override
  String get productSoldOut => '売り切れ';

  @override
  String get productUnavailable => '商品は現在購入できません';

  @override
  String stockCount(int count) {
    return '在庫 $count';
  }

  @override
  String soldCount(int count) {
    return '販売済み $count';
  }

  @override
  String ratingReviews(String rating, int count) {
    return '$rating · $count 件のレビュー';
  }

  @override
  String get productDescription => '説明';

  @override
  String get purchasedContent => '購入済みコンテンツ';

  @override
  String get purchaseToViewContent => '完全なコンテンツを表示するには購入してください';

  @override
  String get openOrDownloadFile => 'ファイルを開く/ダウンロード';

  @override
  String balanceCc(String amount) {
    return '残高 $amount CC';
  }

  @override
  String get buying => '購入中…';

  @override
  String get buy => '購入';

  @override
  String get yourListedProduct => 'これはあなたが出品した商品です';

  @override
  String get backToShop => 'ストアに戻る';

  @override
  String holdingQuantityType(Object quantity, String type) {
    return '所持 $quantity 件 · $type';
  }

  @override
  String get orderPending => '支払い待ち';

  @override
  String get orderPaid => '支払い済み';

  @override
  String get orderRefunded => '返金済み';

  @override
  String get statusUnknown => '不明なステータス';

  @override
  String get conversationNotFound => '会話が見つかりません。更新して再試行してください';

  @override
  String get noMatchingConversations => '一致する会話がありません';

  @override
  String get noConversationsYet => 'まだ会話がありません';

  @override
  String get goContactsToChat => '連絡先に移動してチャットを開始';

  @override
  String get friendInitial => '友';

  @override
  String get noMessagesYetShort => 'まだメッセージがありません';

  @override
  String previewEmoji(String key) {
    return '[絵文字] $key';
  }

  @override
  String get previewSharedPost => '[共有投稿]';

  @override
  String get previewOrder => '[商品注文]';

  @override
  String get emojiMessage => '絵文字メッセージ';

  @override
  String get me => '自分';

  @override
  String get sharedPost => '共有投稿';

  @override
  String get productOrder => '商品注文';

  @override
  String get cannotOpenPostMissingId => '投稿を開けません: 共有に投稿 ID がありません';

  @override
  String get cannotOpenProductMissingId => '商品を開けません: 共有に商品 ID がありません';

  @override
  String get chengeUser => 'Chenge ユーザー';

  @override
  String get signInToPurchase => '購入するにはログインしてください';

  @override
  String get typeMessage => 'メッセージを入力…';

  @override
  String get sendMessage => 'メッセージを送信';

  @override
  String get emoji => '絵文字';

  @override
  String get previewEmojiOnly => '[絵文字]';

  @override
  String get enterGroupNameKeyword => 'グループ名のキーワードを入力';

  @override
  String get enterUserSearchHint => 'ユーザー名、ニックネーム、またはメールを入力';

  @override
  String get friendAddedBack => '追加し返しました — これで友達です';

  @override
  String get friendRequestSent => '友達リクエストを送信しました';

  @override
  String get rejectFriendRequest => '友達リクエストを拒否';

  @override
  String get removeFriend => '友達を削除';

  @override
  String confirmRejectFriendRequest(String name) {
    return '$name からの友達リクエストを拒否しますか？';
  }

  @override
  String confirmRemoveFriend(String name) {
    return '$name を友達から削除しますか？';
  }

  @override
  String get reject => '拒否';

  @override
  String get remove => '削除';

  @override
  String get friendRequestRejected => '友達リクエストを拒否しました';

  @override
  String get friendRemoved => '友達を削除しました';

  @override
  String get remarkCleared => 'メモをクリアしました';

  @override
  String get remarkSaved => 'メモを保存しました';

  @override
  String joinedGroup(String name) {
    return '「$name」に参加しました';
  }

  @override
  String get enterGroupName => 'グループ名を入力してください';

  @override
  String groupCreated(String name) {
    return 'グループチャット「$name」を作成しました';
  }

  @override
  String get createGroupChat => 'グループチャットを作成';

  @override
  String get signInToManageContacts => '連絡先を管理するにはログインしてください';

  @override
  String get contactsSubtitle => 'ユーザー検索、グループ参加、友達リクエストの管理';

  @override
  String friendsTab(int count) {
    return '友達 $count';
  }

  @override
  String groupsTab(int count) {
    return 'グループ $count';
  }

  @override
  String requestsTab(int count) {
    return 'リクエスト $count';
  }

  @override
  String get searchUsers => 'ユーザー';

  @override
  String get searchGroups => 'グループ';

  @override
  String get groupNameKeyword => 'グループ名キーワード';

  @override
  String get userSearchHint => 'ユーザー名、ニックネーム、またはメール';

  @override
  String get searchGroupsTooltip => 'グループを検索';

  @override
  String get searchUsersTooltip => 'ユーザーを検索';

  @override
  String get searchPublicGroups => '公開グループを検索';

  @override
  String get searchChengeUsers => 'ChengeWorld ユーザーを検索';

  @override
  String get searchPublicGroupsHint => 'グループ名を入力して、気になるグループに参加';

  @override
  String get searchUsersHint => 'ユーザー名、ニックネーム、またはメールに対応';

  @override
  String get noMatchingGroups => '一致するグループがありません';

  @override
  String get noMatchingPeople => '一致する人がいません';

  @override
  String get tryOtherKeywords => '別のキーワードを試してください';

  @override
  String get noGroupsYet => 'まだグループがありません';

  @override
  String get noGroupsHint => 'グループを作成するか、検索から公開グループに参加してください';

  @override
  String get noFriendsYet => 'まだ友達がいません';

  @override
  String get noFriendsHint => 'ユーザー名やニックネームで検索して新しい人と出会いましょう';

  @override
  String get noPendingRequests => '保留中のリクエストはありません';

  @override
  String get noPendingRequestsHint => '新しい友達リクエストはここに表示されます';

  @override
  String get groupTapToJoin => 'グループ · タップして参加';

  @override
  String get join => '参加';

  @override
  String get enterGroup => 'グループに入る';

  @override
  String requestAddYou(String username) {
    return '@$username · 友達追加をリクエスト';
  }

  @override
  String onlineWithRemark(String status, String remark, String username) {
    return '$status · メモ: $remark · @$username';
  }

  @override
  String get friend => '友達';

  @override
  String get addBack => '追加し返す';

  @override
  String get requested => 'リクエスト済み';

  @override
  String get add => '追加';

  @override
  String get acceptAndAddBack => '承認して追加し返す';

  @override
  String get rejectRequest => 'リクエストを拒否';

  @override
  String get friendActions => '友達操作';

  @override
  String get sendMessageAction => 'メッセージ';

  @override
  String get editRemark => 'メモを編集';

  @override
  String get setRemark => 'メモを設定';

  @override
  String get removeFriendRelation => '友達を削除';

  @override
  String get setFriendRemark => '友達メモを設定';

  @override
  String get remarkName => 'メモ名';

  @override
  String get remarkHintClear => '空欄にするとメモをクリアします';

  @override
  String get save => '保存';

  @override
  String get groupName => 'グループ名';

  @override
  String get groupNameHint => 'グループに名前を付けてください';

  @override
  String get selectMembersOptional => 'メンバーを選択（任意）';

  @override
  String get create => '作成';

  @override
  String get newConversation => '新しいチャット';

  @override
  String get deleteSession => 'セッションを削除';

  @override
  String confirmDeleteSession(String name) {
    return '「$name」を削除しますか？チャット履歴も削除されます。';
  }

  @override
  String get delete => '削除';

  @override
  String get newChat => '新しいチャット';

  @override
  String get refreshSessions => 'セッションを更新';

  @override
  String get signInToUseAiAgent => 'AI Agent を使用するにはログインしてください';

  @override
  String get aiAgentSubtitle => 'マルチセッション、ストリーミング返信、MCP ツール';

  @override
  String get selectOrCreateAiSession => 'AI セッションを選択または作成';

  @override
  String get aiSessions => 'AI セッション';

  @override
  String get noAiChatsYet => 'まだ AI チャットがありません';

  @override
  String get tapNewToStartChat => '下の新規をタップしてチャットを開始';

  @override
  String get thinking => '考え中…';

  @override
  String get aiRequestFailed => 'AI リクエストに失敗しました';

  @override
  String get noTextReply => '（テキスト返信なし）';

  @override
  String get waitingConfirm => '確認待ち…';

  @override
  String receivedType(String type) {
    return '$type を受信';
  }

  @override
  String get backToSessionList => 'セッション一覧に戻る';

  @override
  String get sendMessageToStart => 'メッセージを送信してチャットを開始';

  @override
  String get askAiAgent => 'AI Agent に質問…';

  @override
  String emojiPackTitle(Object id) {
    return '絵文字パック $id';
  }

  @override
  String get noEmojiPacksBuyInShop => 'まだ絵文字パックがありません — ストアで購入してください';

  @override
  String replyToUser(String name) {
    return '@$name に返信';
  }

  @override
  String get user => 'ユーザー';

  @override
  String get anonymousUser => '匿名';

  @override
  String get timeUnknown => '不明な時刻';

  @override
  String dateYmd(int year, int month, int day) {
    return '$year年$month月$day日';
  }

  @override
  String get tasksInProgress => '進行中';

  @override
  String get tasksNoInProgress => '進行中のタスクはありません';

  @override
  String get tasksCompletedSection => '完了';

  @override
  String get tasksRewardHint => '報酬は手動で受け取る必要があります · タスクは周期ごとに更新されます';

  @override
  String get tasksTodayGoal => '今日の目標';

  @override
  String get tasksTodayGoalSubtitle => 'コミュニティタスクを完了して ChengeCoin を獲得';

  @override
  String tasksProgressSummary(int completed) {
    return '保留中 · $completed 完了';
  }

  @override
  String get taskClaimable => '受け取り可能';

  @override
  String get taskCompletedBadge => '完了';

  @override
  String taskCheckinStreak(int streak, int totalDays) {
    return '$streak 日連続チェックイン · 合計 $totalDays 日';
  }

  @override
  String get checkIn => 'チェックイン';

  @override
  String get claim => '受け取る';

  @override
  String get statusBarTopHideMask => 'トップバー非表示時のステータスバーマスク';

  @override
  String get statusBarTopHideMaskDescription =>
      'トップバーが自動非表示になる場合、コンテンツがステータスバーに重ならないよう半透明のテーマ背景をステータスバーに使用します（既定でオン）';

  @override
  String get siteAndToken => 'サイトとトークン';

  @override
  String get officialSite => '公式サイト';

  @override
  String webViewInitFailed(String errorType, String error) {
    return 'WebView の初期化に失敗しました（$errorType）: $error\nWindows には Edge WebView2 Runtime が必要です。';
  }

  @override
  String get registerAccount => 'アカウント作成';

  @override
  String get registerTitle => 'ChengeWorld に登録';

  @override
  String get registerSuccess => '登録に成功しました。ログインしてください。';

  @override
  String get nicknameOptional => 'ニックネーム（任意）';

  @override
  String get email => 'メール';

  @override
  String get enterEmail => 'メールを入力';

  @override
  String get invalidEmail => 'メール形式が正しくありません';

  @override
  String get emailCode => 'メール認証コード';

  @override
  String get enterEmailCode => '認証コードを入力';

  @override
  String get getEmailCode => 'コードを取得';

  @override
  String get sendingCode => '送信中';

  @override
  String get emailCodeSent => 'コードを送信しました（開発環境ではバックエンドログを確認してください）';

  @override
  String get fillEmailFirst => '先にメールを入力してください';

  @override
  String get passwordMinSix => 'パスワード（6文字以上）';

  @override
  String get passwordTooShort => 'パスワードは6文字以上である必要があります';

  @override
  String get register => '登録';

  @override
  String get registering => '登録中…';

  @override
  String get clearCache => 'キャッシュをクリア';

  @override
  String get clearCacheDescription => 'ログアウトせずにローカル画像キャッシュをクリアします';

  @override
  String get clearCacheConfirm => 'ローカルキャッシュをクリアしますか？';

  @override
  String get clearCacheDone => 'キャッシュをクリアしました';

  @override
  String get clearingCache => 'クリア中…';

  @override
  String get accessTokenCleared => 'アクセストークンをクリアしました';

  @override
  String get createPost => '新規投稿';

  @override
  String get publishPost => '公開';

  @override
  String get postTitle => 'タイトル';

  @override
  String get postContent => '本文（Markdown）';

  @override
  String get markdownHint => 'Markdown に対応。画像を挿入できます。';

  @override
  String get insertImage => '画像を挿入';

  @override
  String get coverImage => 'カバー画像';

  @override
  String get chooseCover => 'カバーを選択';

  @override
  String get removeCover => 'カバーを削除';

  @override
  String get category => 'カテゴリ';

  @override
  String get selectCategoryHint => 'カテゴリを選択してください';

  @override
  String get noCategories => '利用可能なカテゴリがありません';

  @override
  String get titleRequired => 'タイトルを入力してください';

  @override
  String get contentRequired => '本文を入力してください';

  @override
  String get postPublished => '投稿しました';

  @override
  String get signInToCreatePost => '投稿を作成するにはログインしてください';

  @override
  String get tagsOptional => 'タグ（任意）';

  @override
  String get tagsHint => 'カンマまたはスペースで区切る';

  @override
  String get saveDraft => '下書きを保存';

  @override
  String get draftSaved => '下書きを保存しました';

  @override
  String draftAutoSaved(String time) {
    return '$time に下書きを自動保存しました';
  }

  @override
  String get restoreDraftTitle => '下書きを復元しますか？';

  @override
  String get restoreDraftMessage => '未公開の下書きが見つかりました。復元しますか？';

  @override
  String get restoreDraft => '復元';

  @override
  String get discardDraft => '破棄';

  @override
  String get hotTags => '人気タグ';

  @override
  String get attachmentUrls => '添付ファイル URL';

  @override
  String get attachmentUrlsHint => '任意の添付ファイル URL。Bilibili 動画リンクも対応';

  @override
  String get attachmentUrlHint => 'https://…';

  @override
  String get addAttachmentUrl => '添付 URL を追加';

  @override
  String get removeAttachment => '添付を削除';

  @override
  String maxImagesReached(int count) {
    return '画像は最大 $count 枚までです';
  }

  @override
  String get articleImages => '記事画像';

  @override
  String get articleImagesHint =>
      '記事ギャラリー用に最大5枚（Markdown ではありません）。カバー未設定の場合は最初の画像がカバーとして使用されます。';

  @override
  String get deleteImage => '画像を削除';

  @override
  String get bilibiliVideo => 'Bilibili video';

  @override
  String get attachmentLink => 'Attachment link';

  @override
  String get cannotOpenLink => 'Cannot open link';

  @override
  String get editMarkdown => 'Edit';

  @override
  String get previewMarkdown => 'Preview';

  @override
  String get previewEmpty => 'Nothing to preview yet';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get editProfileDescription => 'Update nickname, avatar and bio';

  @override
  String get saveProfile => 'Save';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get changeAvatar => 'Change avatar';

  @override
  String get nickname => 'Nickname';

  @override
  String get gender => 'Gender';

  @override
  String get genderSecret => 'Private';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get birthday => 'Birthday';

  @override
  String get bio => 'Bio';

  @override
  String get website => 'Website';

  @override
  String get phone => 'Phone';

  @override
  String get hideExternalPosts => 'Hide external';

  @override
  String get hideExternalPostsDescription =>
      'Hide posts synced from external RSS (on by default)';

  @override
  String get tasksSection => 'Tasks';

  @override
  String get autoCheckin => 'Auto check-in on launch';

  @override
  String get autoCheckinDescription =>
      'Try the daily check-in each time the app starts (skipped if already done today)';

  @override
  String get groupNoChannels => 'This group has no channels yet';

  @override
  String get channelReadOnly => 'You cannot post in this channel';

  @override
  String get shopTypeAppPack => 'APP package';

  @override
  String get shopType3d => '3D model';

  @override
  String get shopTypeAnimation => 'Animation';

  @override
  String get shopTypeArchive => 'Archive';

  @override
  String get shopTypeMusic => 'Music';

  @override
  String get shopTypeMp2 => 'MP2 music';

  @override
  String get shopTypeLiba2 => 'LIBA2 music';

  @override
  String get shopTypeSkill => 'Skill';

  @override
  String get shopTypeNurture => 'Nurture item';

  @override
  String get shopTypeNurtureTicket => 'Nurture ticket';

  @override
  String get aiWebSearch => 'Web search';

  @override
  String get aiDrawing => 'Draw';

  @override
  String get aiDrawModel => 'Draw model';

  @override
  String get aiDrawNoModels => 'No drawing model available';

  @override
  String get aiDrawAspect => 'Aspect ratio';

  @override
  String get aiDrawQuality => 'Quality';

  @override
  String get aiFeedbackThanks => 'Thanks for your feedback';

  @override
  String get aiFeedbackHelpful => 'Helpful';

  @override
  String get aiFeedbackNotHelpful => 'Not helpful';

  @override
  String get aiImages => 'Image';

  @override
  String get shopMusicHint =>
      'Audio resource. The file is downloadable after purchase (in-app playback is not supported yet).';

  @override
  String get shop3dHint =>
      '3D model resource. The file is downloadable after purchase.';

  @override
  String get shopAnimationHint =>
      'Animation resource. The file is downloadable after purchase.';

  @override
  String get shopArchiveHint =>
      'Archived resource. The archive is downloadable after purchase.';

  @override
  String get shopAppPackHint =>
      'APP package resource. The package is downloadable after purchase.';

  @override
  String get shopSkillHint =>
      'Skill resource. After purchase it can be enabled in AI sessions.';

  @override
  String get shopNurtureHint =>
      'Nurture item. After purchase it can be used in the nurture gameplay.';

  @override
  String get chatImage => 'Image';

  @override
  String get chatImageUnavailable => '[Image unavailable]';

  @override
  String get chatImageLoading => '[Loading image]';

  @override
  String get chatSourceQq => 'QQ';

  @override
  String get chatSourceGame => 'Game';

  @override
  String get chatInteropFallback => '[Cross-platform message]';

  @override
  String get sendImage => 'Send image';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get helpSubtitle =>
      'Find official tutorials, step-by-step guides and troubleshooting by module.';

  @override
  String get searchGuides => 'Search tutorials';

  @override
  String get allModules => 'All modules';

  @override
  String get noGuides => 'No tutorials match your search.';

  @override
  String get clear => 'Clear';

  @override
  String guideRevision(Object revision) {
    return 'revision $revision';
  }

  @override
  String get guideUnavailable =>
      'This tutorial is unavailable or has been taken offline.';

  @override
  String guideActionUnavailable(Object action) {
    return '$action is not supported in the app yet.';
  }

  @override
  String get officialGuide => 'Official tutorial';

  @override
  String get guideAppliesTo => 'Applies to';

  @override
  String get guideBeforeStart => 'Before you start';

  @override
  String get guideSteps => 'Steps';

  @override
  String get guideTroubleshooting => 'Troubleshooting';

  @override
  String get guideRelated => 'Related tutorials';

  @override
  String guideStableLink(Object key, Object revision) {
    return 'Stable link: /help/$key?revision=$revision';
  }

  @override
  String get guideCheck => 'Check';

  @override
  String get notifications => 'Notifications';

  @override
  String get announcements => 'Announcements';

  @override
  String get notificationsEmpty => 'No notifications yet.';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get clearNotifications => 'Clear';

  @override
  String get clearNotificationsConfirm => 'Clear all notifications?';

  @override
  String notificationCount(Object count) {
    return '$count notifications';
  }

  @override
  String get noAnnouncements => 'No announcements yet.';

  @override
  String get markAnnouncementRead => 'Mark as read';

  @override
  String get gotIt => 'Got it';

  @override
  String announcementCount(Object count) {
    return '$count announcements';
  }

  @override
  String get notificationsTabMessages => 'Messages';

  @override
  String get notificationsTabAnnouncements => 'Announcements';

  @override
  String get notifyFriendRequest => 'Friend request';

  @override
  String get notifyFriendAccept => 'Friend accepted';

  @override
  String get notifyMessage => 'New message';

  @override
  String get notifyLike => 'Like';

  @override
  String get notifyComment => 'Comment';

  @override
  String get notifyMention => 'Mention';

  @override
  String get notifyFollow => 'Follow';

  @override
  String get notifyShare => 'Share';

  @override
  String get notifyGroupInvite => 'Group invite';

  @override
  String get notifySystem => 'System';

  @override
  String get notifyDraw => 'AI drawing';

  @override
  String get notifyBill => 'Balance';

  @override
  String get systemAnnouncement => 'System announcement';

  @override
  String groupInvitePrompt(Object group) {
    return 'Invitation to join \"$group\". You will join only after accepting.';
  }

  @override
  String get conversationUnavailable =>
      'This conversation is no longer available.';

  @override
  String get decline => 'Decline';

  @override
  String get accept => 'Accept';

  @override
  String get resources => 'Resources';

  @override
  String get resourcesDescription =>
      'Document library, gallery and experience base';

  @override
  String get notificationsDescription =>
      'In-app notifications and announcements';

  @override
  String get resourceLibrary => 'Library';

  @override
  String get gallery => 'Gallery';

  @override
  String get experience => 'Experience';

  @override
  String get experiencePositive => 'Positive';

  @override
  String get experienceNegative => 'Negative';

  @override
  String get resourceSearch => 'Search file name';

  @override
  String get resourceLibraryEmpty => 'The shelf is empty.';

  @override
  String get resourceLoginRequired => 'Sign in to open the library.';

  @override
  String get resourceTypeAll => 'All';

  @override
  String get resourceTypeDoc => 'Document';

  @override
  String get resourceTypeMd => 'Markdown';

  @override
  String get resourceTypeWord => 'Word';

  @override
  String get resourceTypePpt => 'PPT';

  @override
  String get resourceTypePdf => 'PDF';

  @override
  String get resourceTypeSheet => 'Sheet';

  @override
  String get resourceTypeImage => 'Image';

  @override
  String get galleryEmpty => 'No photos in the gallery yet.';

  @override
  String galleryDayCount(Object count) {
    return '$count photos';
  }

  @override
  String get experienceSearch => 'Search problems or experience';

  @override
  String get experienceEmpty => 'No approved experience yet.';

  @override
  String get experienceLoginRequired => 'Sign in to view the experience base.';

  @override
  String experienceTotal(Object count) {
    return '$count entries';
  }

  @override
  String get sceneNormal => 'Chat';

  @override
  String get sceneNurture => 'Nurture';

  @override
  String get sceneGlobal => 'General';

  @override
  String get skillLabel => 'Skill';

  @override
  String get openOriginal => 'Open original';

  @override
  String get docPreviewUnavailable =>
      'Preview is not available for this file; open the original instead.';

  @override
  String get aiModeChat => 'Chat';

  @override
  String get aiModeHistorian => 'Historian';

  @override
  String get aiHistorianWorking => 'Researching and organizing…';

  @override
  String get aiHistorianHint =>
      'Historian mode: compare records, verify events, order the timeline.';

  @override
  String get aiHistorianPlaceholder =>
      'Enter a person, event or era to research…';

  @override
  String get aiArchivePreview => 'Content ready, adding entity covers…';

  @override
  String get aiArchiveSaving => 'Covers filled, saving…';

  @override
  String get aiSkillsTitle => 'Skills';

  @override
  String get aiSkillsEmpty => 'No skills available.';

  @override
  String get aiSkillPurchased => 'Purchased';

  @override
  String get aiTasksTitle => 'Task list';

  @override
  String get aiTasksEmpty => 'No tasks in this conversation.';

  @override
  String aiTasksFooter(Object count) {
    return '$count task(s) this batch · collapsing is not consent';
  }

  @override
  String get aiTasksCancel => 'Cancel tasks';

  @override
  String get aiTasksConfirm => 'Confirm';

  @override
  String get aiTasksReady => 'AI is waiting for your answer';

  @override
  String get aiTaskPending => 'Pending';

  @override
  String get aiTaskRunning => 'Running';

  @override
  String get aiTaskDone => 'Done';

  @override
  String get aiTaskFailed => 'Failed';

  @override
  String get aiTaskCancelled => 'Cancelled';

  @override
  String get aiTaskApproved => 'Handled';

  @override
  String get aiQuestionMultiHint =>
      'Choose one or more, or write your own idea';

  @override
  String get aiQuestionSingleHint => 'Pick an answer, or write your own idea';

  @override
  String get aiQuestionCustomHint => 'Say it your way';

  @override
  String aiPendingTitle(Object count) {
    return 'Operations awaiting confirmation ($count)';
  }

  @override
  String get aiPendingApprove => 'Confirm';

  @override
  String get aiPendingReject => 'Reject';

  @override
  String get aiPendingSubmitted => 'Submitted';

  @override
  String get addAttachment => 'Add photo';

  @override
  String get attachmentFailed => 'Could not read the selected image.';

  @override
  String get docImages => 'Document images';

  @override
  String get chatQuote => 'Quote';

  @override
  String get chatCancelQuote => 'Cancel quote';

  @override
  String get chatQuoting => 'Quoting';

  @override
  String get chatCopy => 'Copy';

  @override
  String get chatCopied => 'Copied';

  @override
  String get chatRecall => 'Recall';

  @override
  String get chatRecalled => 'Message recalled';

  @override
  String get chatReaction => 'React';

  @override
  String get chatViewOriginal => 'View original';

  @override
  String get chatHdr => 'HDR';

  @override
  String get chatChartUnavailable => 'Chart data unavailable';

  @override
  String get chatMessageActions => 'Message actions';

  @override
  String get chatQuotedMessage => 'Quoted message';
}

/// The translations for Japanese, as used in Japan (`ja_JP`).
class AppLocalizationsJaJp extends AppLocalizationsJa {
  AppLocalizationsJaJp() : super('ja_JP');

  @override
  String get communityTitle => 'ChengeWorld コミュニティ';

  @override
  String get discover => '発見';

  @override
  String get social => 'ソーシャル';

  @override
  String get store => 'ストア';

  @override
  String get account => 'アカウント';

  @override
  String get settings => '設定';

  @override
  String get appearance => '外観';

  @override
  String get themeMode => 'テーマモード';

  @override
  String get followSystem => 'システムに従う';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get language => '言語';

  @override
  String get dynamicColor => 'ダイナミックカラー';

  @override
  String get dynamicColorDescription => 'Android 12+ の壁紙の色を使用（Material You）';

  @override
  String get themeColor => 'テーマカラー';

  @override
  String get systemBars => 'システムバー';

  @override
  String get statusBarImmersive => 'ステータスバーを透過';

  @override
  String get statusBarDescription => 'コンテンツを透過ステータスバーの背後まで拡張します';

  @override
  String get navigationBarImmersive => 'ナビゲーションバーを透過';

  @override
  String get navigationBarDescription => 'コンテンツを透過ナビゲーションバーの背後まで拡張します';

  @override
  String get scrollBehavior => 'スクロール動作';

  @override
  String get autoHideTopBar => 'トップバーを自動非表示';

  @override
  String get autoHideTopDescription => '発見/ストアで下にスクロールするとアプリバーを非表示にします（既定でオン）';

  @override
  String get autoHideBottomBar => 'ボトムバーを自動非表示';

  @override
  String get autoHideBottomDescription =>
      '下にスクロールするとボトムナビゲーションを非表示にします。ワイド画面ではレールは表示されたままです';

  @override
  String get chat => 'チャット';

  @override
  String get showSelfAvatar => 'チャットで自分のアバターを表示';

  @override
  String get showSelfAvatarDescription => '送信メッセージの横に自分のアバターを表示します（既定でオフ）';

  @override
  String get showPeerAvatar => '個人チャットで相手のアバターを表示';

  @override
  String get showPeerAvatarDescription =>
      '個人メッセージの横に相手のアバターを表示します。グループのアバターは常に表示されます（既定でオフ）';

  @override
  String get systemGestures => 'システムジェスチャー';

  @override
  String get predictiveBack => '予測型戻る';

  @override
  String get predictiveBackDescription =>
      'Android 13+ で予測型戻るアニメーションを使用します（既定でオフ）';

  @override
  String get layout => 'レイアウト';

  @override
  String get feedColumns => '発見グリッドの列数';

  @override
  String get shopColumns => 'ストアグリッドの列数';

  @override
  String columnRange(int min, int max) {
    return '現在: $min～$max 列（スペースがある場合はこの範囲内で自動調整）';
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
    return '投稿 $count 件';
  }

  @override
  String pageCount(int page, int total) {
    return '$total ページ中 $page ページ';
  }

  @override
  String itemCount(int count) {
    return '商品 $count 件';
  }

  @override
  String get rightNow => '今話していること';

  @override
  String get freshDiscussions => 'コミュニティの新しい話題をチェック';

  @override
  String get searchPostsAndTopics => '投稿とトピックを検索';

  @override
  String get search => '検索';

  @override
  String get refreshPosts => '投稿を更新';

  @override
  String get latest => '最新';

  @override
  String get popular => '人気';

  @override
  String get featured => '注目';

  @override
  String get noPosts => 'まだ投稿がありません';

  @override
  String get noPostsHint => '別のキーワードを試すか、後でもう一度確認してください';

  @override
  String get retry => '再試行';

  @override
  String get previousPage => '前のページ';

  @override
  String get nextPage => '次のページ';

  @override
  String get signOut => 'ログアウト';

  @override
  String get confirmSignOut => 'ChengeWorld からログアウトしてもよろしいですか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get exit => 'ログアウト';

  @override
  String get signedOut => 'ログアウトしました';

  @override
  String get accountSettingsSignIn => 'アカウント設定を管理するにはログインしてください';

  @override
  String get signedIn => 'ログイン済み';

  @override
  String get welcome => 'コミュニティへようこそ';

  @override
  String get accountConnected => 'アカウントは ChengeWorld に接続されています';

  @override
  String get signInForPersonalized => 'ログインしてパーソナライズされたコンテンツを探索';

  @override
  String get taskCenter => 'タスクセンター';

  @override
  String get taskCenterDescription => 'チェックイン、タスク完了で ChengeCoin を獲得';

  @override
  String get signIn => 'ログイン';

  @override
  String get signInAccount => 'ログイン';

  @override
  String get signInSuccess => 'ログインに成功しました';

  @override
  String get signInToChengeWorld => 'ChengeWorld にログイン';

  @override
  String get username => 'ユーザー名';

  @override
  String get enterUsername => 'ユーザー名を入力';

  @override
  String get password => 'パスワード';

  @override
  String get showPassword => 'パスワードを表示';

  @override
  String get hidePassword => 'パスワードを非表示';

  @override
  String get enterPassword => 'パスワードを入力';

  @override
  String get signingIn => 'ログイン中…';

  @override
  String get contacts => '連絡先';

  @override
  String get productDetails => '商品詳細';

  @override
  String get post => '投稿';

  @override
  String get shopNow => 'ストア';

  @override
  String get myAssets => 'マイ資産';

  @override
  String get orders => '注文';

  @override
  String get discoverItems => '商品を発見';

  @override
  String get searchProducts => '商品を検索';

  @override
  String get sortProducts => '商品を並べ替え';

  @override
  String get newestArrivals => '新着';

  @override
  String get popularProducts => '人気商品';

  @override
  String get priceLowToHigh => '価格: 安い順';

  @override
  String get priceHighToLow => '価格: 高い順';

  @override
  String get ratingFirst => '評価が高い順';

  @override
  String get all => 'すべて';

  @override
  String get files => 'ファイル';

  @override
  String get emojiPacks => '絵文字パック';

  @override
  String get components => 'コンポーネント';

  @override
  String get applications => 'アプリケーション';

  @override
  String get executables => '実行ファイル';

  @override
  String get libraries => 'ライブラリ';

  @override
  String get functionLibraries => '関数ライブラリ';

  @override
  String get noAssetsOrOrdersSignIn => '資産と注文を表示するにはログインしてください';

  @override
  String get goSignIn => 'ログイン';

  @override
  String get shopUnavailable => 'ストアは一時的に利用できません';

  @override
  String get checkNetworkAndRetry => '接続を確認して再試行してください';

  @override
  String get noProducts => 'まだ商品がありません';

  @override
  String get tryOtherSearch => '別のキーワードやカテゴリを試してください';

  @override
  String get noAssets => 'まだ資産がありません';

  @override
  String get noOrders => 'まだ注文がありません';

  @override
  String get purchasesShowHere => 'ストアでの購入内容がここに表示されます';

  @override
  String get refresh => '更新';

  @override
  String get refreshTasks => 'タスクを更新';

  @override
  String get claimComplete => '完了する';

  @override
  String rewardClaimed(String coins) {
    return '報酬を受け取りました: +$coins CC';
  }

  @override
  String get productPurchaseSuccess => '購入が完了しました。資産に追加されました';

  @override
  String get signInToLike => 'この投稿にいいねするにはログインしてください';

  @override
  String get signInToComment => 'コメントするにはログインしてください';

  @override
  String get commentPublished => 'コメントを投稿しました';

  @override
  String get noComments => 'まだコメントがありません';

  @override
  String get back => '戻る';

  @override
  String commentCount(int count) {
    return 'コメント · $count';
  }

  @override
  String get refreshComments => 'コメントを更新';

  @override
  String get cancelReply => '返信をキャンセル';

  @override
  String get writeComment => 'コメントを書く…';

  @override
  String get reply => '返信';

  @override
  String get publishing => '投稿中…';

  @override
  String get publishComment => 'コメントを投稿';

  @override
  String get liked => 'いいね済み';

  @override
  String get like => 'いいね';

  @override
  String commentsWithCount(int count) {
    return 'コメント ($count)';
  }

  @override
  String get noMessages => 'まだメッセージがありません。挨拶してみましょう！';

  @override
  String get online => 'オンライン';

  @override
  String get offline => 'オフライン';

  @override
  String get groupChat => 'グループチャット';

  @override
  String get loadOlderMessages => '以前のメッセージを読み込む';

  @override
  String get backToConversations => '会話一覧に戻る';

  @override
  String get searchConversation => '会話を検索';

  @override
  String get addressBook => '連絡先';

  @override
  String get noFriendsToInvite => '招待できる友達がまだいません';

  @override
  String get selectConversation => '会話を選択してチャットを開始';

  @override
  String get refreshConversations => '会話を更新';

  @override
  String get signInToStartChat => 'チャットを開始するにはログインしてください';

  @override
  String get chengeCore => 'ChengeCore';

  @override
  String get signInWithToken => 'Token でログイン';

  @override
  String get openOfficialSiteWithWebView => 'WebView で公式サイトを開く';

  @override
  String get close => '閉じる';

  @override
  String get raising => '育成';

  @override
  String get copy => 'コピー';

  @override
  String get webViewNotSupportedOnAllOs =>
      'すべての OS で WebView がサポートされているわけではありません';

  @override
  String get platformWebViewNotSupported =>
      'このプラットフォームでは内蔵 Web ビューはサポートされていません';

  @override
  String get openCoreEcosystem => 'コアエコシステムを開く';

  @override
  String get openRaisingSystem => '育成システムを開く';

  @override
  String get cannotOpenSiteMissingConfig => 'サイトを開けません: サービス設定がありません';

  @override
  String get accessTokenDescription => '本人確認に使用するアクセストークン';

  @override
  String get confirm => 'OK';

  @override
  String get confirmSignIn => 'ログインを確認';

  @override
  String get pasteJwtToken => 'JWT Token を貼り付け';

  @override
  String get accessToken => 'アクセストークン';

  @override
  String get accessTokenCopied => 'アクセストークンをコピーしました';

  @override
  String get accessTokenUpdated => 'アクセストークンを更新しました';

  @override
  String get signInToUseChengeCore => 'ChengeCore を使用するにはログインしてください';

  @override
  String get signInToUseRaising => '育成を使用するにはログインしてください';

  @override
  String get enterToken => 'Token を入力してください';

  @override
  String get communityMerchant => 'コミュニティ販売者';

  @override
  String get product => '商品';

  @override
  String get productInitial => '商';

  @override
  String get productUnderReview => '商品を審査中です';

  @override
  String get productRejected => '商品が審査を通りませんでした';

  @override
  String get productSoldOut => '売り切れ';

  @override
  String get productUnavailable => '商品は現在購入できません';

  @override
  String stockCount(int count) {
    return '在庫 $count';
  }

  @override
  String soldCount(int count) {
    return '販売済み $count';
  }

  @override
  String ratingReviews(String rating, int count) {
    return '$rating · $count 件のレビュー';
  }

  @override
  String get productDescription => '説明';

  @override
  String get purchasedContent => '購入済みコンテンツ';

  @override
  String get purchaseToViewContent => '完全なコンテンツを表示するには購入してください';

  @override
  String get openOrDownloadFile => 'ファイルを開く/ダウンロード';

  @override
  String balanceCc(String amount) {
    return '残高 $amount CC';
  }

  @override
  String get buying => '購入中…';

  @override
  String get buy => '購入';

  @override
  String get yourListedProduct => 'これはあなたが出品した商品です';

  @override
  String get backToShop => 'ストアに戻る';

  @override
  String holdingQuantityType(Object quantity, String type) {
    return '所持 $quantity 件 · $type';
  }

  @override
  String get orderPending => '支払い待ち';

  @override
  String get orderPaid => '支払い済み';

  @override
  String get orderRefunded => '返金済み';

  @override
  String get statusUnknown => '不明なステータス';

  @override
  String get conversationNotFound => '会話が見つかりません。更新して再試行してください';

  @override
  String get noMatchingConversations => '一致する会話がありません';

  @override
  String get noConversationsYet => 'まだ会話がありません';

  @override
  String get goContactsToChat => '連絡先に移動してチャットを開始';

  @override
  String get friendInitial => '友';

  @override
  String get noMessagesYetShort => 'まだメッセージがありません';

  @override
  String previewEmoji(String key) {
    return '[絵文字] $key';
  }

  @override
  String get previewSharedPost => '[共有投稿]';

  @override
  String get previewOrder => '[商品注文]';

  @override
  String get emojiMessage => '絵文字メッセージ';

  @override
  String get me => '自分';

  @override
  String get sharedPost => '共有投稿';

  @override
  String get productOrder => '商品注文';

  @override
  String get cannotOpenPostMissingId => '投稿を開けません: 共有に投稿 ID がありません';

  @override
  String get cannotOpenProductMissingId => '商品を開けません: 共有に商品 ID がありません';

  @override
  String get chengeUser => 'Chenge ユーザー';

  @override
  String get signInToPurchase => '購入するにはログインしてください';

  @override
  String get typeMessage => 'メッセージを入力…';

  @override
  String get sendMessage => 'メッセージを送信';

  @override
  String get emoji => '絵文字';

  @override
  String get previewEmojiOnly => '[絵文字]';

  @override
  String get enterGroupNameKeyword => 'グループ名のキーワードを入力';

  @override
  String get enterUserSearchHint => 'ユーザー名、ニックネーム、またはメールを入力';

  @override
  String get friendAddedBack => '追加し返しました — これで友達です';

  @override
  String get friendRequestSent => '友達リクエストを送信しました';

  @override
  String get rejectFriendRequest => '友達リクエストを拒否';

  @override
  String get removeFriend => '友達を削除';

  @override
  String confirmRejectFriendRequest(String name) {
    return '$name からの友達リクエストを拒否しますか？';
  }

  @override
  String confirmRemoveFriend(String name) {
    return '$name を友達から削除しますか？';
  }

  @override
  String get reject => '拒否';

  @override
  String get remove => '削除';

  @override
  String get friendRequestRejected => '友達リクエストを拒否しました';

  @override
  String get friendRemoved => '友達を削除しました';

  @override
  String get remarkCleared => 'メモをクリアしました';

  @override
  String get remarkSaved => 'メモを保存しました';

  @override
  String joinedGroup(String name) {
    return '「$name」に参加しました';
  }

  @override
  String get enterGroupName => 'グループ名を入力してください';

  @override
  String groupCreated(String name) {
    return 'グループチャット「$name」を作成しました';
  }

  @override
  String get createGroupChat => 'グループチャットを作成';

  @override
  String get signInToManageContacts => '連絡先を管理するにはログインしてください';

  @override
  String get contactsSubtitle => 'ユーザー検索、グループ参加、友達リクエストの管理';

  @override
  String friendsTab(int count) {
    return '友達 $count';
  }

  @override
  String groupsTab(int count) {
    return 'グループ $count';
  }

  @override
  String requestsTab(int count) {
    return 'リクエスト $count';
  }

  @override
  String get searchUsers => 'ユーザー';

  @override
  String get searchGroups => 'グループ';

  @override
  String get groupNameKeyword => 'グループ名キーワード';

  @override
  String get userSearchHint => 'ユーザー名、ニックネーム、またはメール';

  @override
  String get searchGroupsTooltip => 'グループを検索';

  @override
  String get searchUsersTooltip => 'ユーザーを検索';

  @override
  String get searchPublicGroups => '公開グループを検索';

  @override
  String get searchChengeUsers => 'ChengeWorld ユーザーを検索';

  @override
  String get searchPublicGroupsHint => 'グループ名を入力して、気になるグループに参加';

  @override
  String get searchUsersHint => 'ユーザー名、ニックネーム、またはメールに対応';

  @override
  String get noMatchingGroups => '一致するグループがありません';

  @override
  String get noMatchingPeople => '一致する人がいません';

  @override
  String get tryOtherKeywords => '別のキーワードを試してください';

  @override
  String get noGroupsYet => 'まだグループがありません';

  @override
  String get noGroupsHint => 'グループを作成するか、検索から公開グループに参加してください';

  @override
  String get noFriendsYet => 'まだ友達がいません';

  @override
  String get noFriendsHint => 'ユーザー名やニックネームで検索して新しい人と出会いましょう';

  @override
  String get noPendingRequests => '保留中のリクエストはありません';

  @override
  String get noPendingRequestsHint => '新しい友達リクエストはここに表示されます';

  @override
  String get groupTapToJoin => 'グループ · タップして参加';

  @override
  String get join => '参加';

  @override
  String get enterGroup => 'グループに入る';

  @override
  String requestAddYou(String username) {
    return '@$username · 友達追加をリクエスト';
  }

  @override
  String onlineWithRemark(String status, String remark, String username) {
    return '$status · メモ: $remark · @$username';
  }

  @override
  String get friend => '友達';

  @override
  String get addBack => '追加し返す';

  @override
  String get requested => 'リクエスト済み';

  @override
  String get add => '追加';

  @override
  String get acceptAndAddBack => '承認して追加し返す';

  @override
  String get rejectRequest => 'リクエストを拒否';

  @override
  String get friendActions => '友達操作';

  @override
  String get sendMessageAction => 'メッセージ';

  @override
  String get editRemark => 'メモを編集';

  @override
  String get setRemark => 'メモを設定';

  @override
  String get removeFriendRelation => '友達を削除';

  @override
  String get setFriendRemark => '友達メモを設定';

  @override
  String get remarkName => 'メモ名';

  @override
  String get remarkHintClear => '空欄にするとメモをクリアします';

  @override
  String get save => '保存';

  @override
  String get groupName => 'グループ名';

  @override
  String get groupNameHint => 'グループに名前を付けてください';

  @override
  String get selectMembersOptional => 'メンバーを選択（任意）';

  @override
  String get create => '作成';

  @override
  String get newConversation => '新しいチャット';

  @override
  String get deleteSession => 'セッションを削除';

  @override
  String confirmDeleteSession(String name) {
    return '「$name」を削除しますか？チャット履歴も削除されます。';
  }

  @override
  String get delete => '削除';

  @override
  String get newChat => '新しいチャット';

  @override
  String get refreshSessions => 'セッションを更新';

  @override
  String get signInToUseAiAgent => 'AI Agent を使用するにはログインしてください';

  @override
  String get aiAgentSubtitle => 'マルチセッション、ストリーミング返信、MCP ツール';

  @override
  String get selectOrCreateAiSession => 'AI セッションを選択または作成';

  @override
  String get aiSessions => 'AI セッション';

  @override
  String get noAiChatsYet => 'まだ AI チャットがありません';

  @override
  String get tapNewToStartChat => '下の新規をタップしてチャットを開始';

  @override
  String get thinking => '考え中…';

  @override
  String get aiRequestFailed => 'AI リクエストに失敗しました';

  @override
  String get noTextReply => '（テキスト返信なし）';

  @override
  String get waitingConfirm => '確認待ち…';

  @override
  String receivedType(String type) {
    return '$type を受信';
  }

  @override
  String get backToSessionList => 'セッション一覧に戻る';

  @override
  String get sendMessageToStart => 'メッセージを送信してチャットを開始';

  @override
  String get askAiAgent => 'AI Agent に質問…';

  @override
  String emojiPackTitle(Object id) {
    return '絵文字パック $id';
  }

  @override
  String get noEmojiPacksBuyInShop => 'まだ絵文字パックがありません — ストアで購入してください';

  @override
  String replyToUser(String name) {
    return '@$name に返信';
  }

  @override
  String get user => 'ユーザー';

  @override
  String get anonymousUser => '匿名';

  @override
  String get timeUnknown => '不明な時刻';

  @override
  String dateYmd(int year, int month, int day) {
    return '$year年$month月$day日';
  }

  @override
  String get tasksInProgress => '進行中';

  @override
  String get tasksNoInProgress => '進行中のタスクはありません';

  @override
  String get tasksCompletedSection => '完了';

  @override
  String get tasksRewardHint => '報酬は手動で受け取る必要があります · タスクは周期ごとに更新されます';

  @override
  String get tasksTodayGoal => '今日の目標';

  @override
  String get tasksTodayGoalSubtitle => 'コミュニティタスクを完了して ChengeCoin を獲得';

  @override
  String tasksProgressSummary(int completed) {
    return '保留中 · $completed 完了';
  }

  @override
  String get taskClaimable => '受け取り可能';

  @override
  String get taskCompletedBadge => '完了';

  @override
  String taskCheckinStreak(int streak, int totalDays) {
    return '$streak 日連続チェックイン · 合計 $totalDays 日';
  }

  @override
  String get checkIn => 'チェックイン';

  @override
  String get claim => '受け取る';

  @override
  String get statusBarTopHideMask => 'トップバー非表示時のステータスバーマスク';

  @override
  String get statusBarTopHideMaskDescription =>
      'トップバーが自動非表示になる場合、コンテンツがステータスバーに重ならないよう半透明のテーマ背景をステータスバーに使用します（既定でオン）';

  @override
  String get siteAndToken => 'サイトとトークン';

  @override
  String get officialSite => '公式サイト';

  @override
  String webViewInitFailed(String errorType, String error) {
    return 'WebView の初期化に失敗しました（$errorType）: $error\nWindows には Edge WebView2 Runtime が必要です。';
  }

  @override
  String get registerAccount => 'アカウント作成';

  @override
  String get registerTitle => 'ChengeWorld に登録';

  @override
  String get registerSuccess => '登録に成功しました。ログインしてください。';

  @override
  String get nicknameOptional => 'ニックネーム（任意）';

  @override
  String get email => 'メール';

  @override
  String get enterEmail => 'メールを入力';

  @override
  String get invalidEmail => 'メール形式が正しくありません';

  @override
  String get emailCode => 'メール認証コード';

  @override
  String get enterEmailCode => '認証コードを入力';

  @override
  String get getEmailCode => 'コードを取得';

  @override
  String get sendingCode => '送信中';

  @override
  String get emailCodeSent => 'コードを送信しました（開発環境ではバックエンドログを確認してください）';

  @override
  String get fillEmailFirst => '先にメールを入力してください';

  @override
  String get passwordMinSix => 'パスワード（6文字以上）';

  @override
  String get passwordTooShort => 'パスワードは6文字以上である必要があります';

  @override
  String get register => '登録';

  @override
  String get registering => '登録中…';

  @override
  String get clearCache => 'キャッシュをクリア';

  @override
  String get clearCacheDescription => 'ログアウトせずにローカル画像キャッシュをクリアします';

  @override
  String get clearCacheConfirm => 'ローカルキャッシュをクリアしますか？';

  @override
  String get clearCacheDone => 'キャッシュをクリアしました';

  @override
  String get clearingCache => 'クリア中…';

  @override
  String get accessTokenCleared => 'アクセストークンをクリアしました';

  @override
  String get createPost => '新規投稿';

  @override
  String get publishPost => '公開';

  @override
  String get postTitle => 'タイトル';

  @override
  String get postContent => '本文（Markdown）';

  @override
  String get markdownHint => 'Markdown に対応。画像を挿入できます。';

  @override
  String get insertImage => '画像を挿入';

  @override
  String get coverImage => 'カバー画像';

  @override
  String get chooseCover => 'カバーを選択';

  @override
  String get removeCover => 'カバーを削除';

  @override
  String get category => 'カテゴリ';

  @override
  String get selectCategoryHint => 'カテゴリを選択してください';

  @override
  String get noCategories => '利用可能なカテゴリがありません';

  @override
  String get titleRequired => 'タイトルを入力してください';

  @override
  String get contentRequired => '本文を入力してください';

  @override
  String get postPublished => '投稿しました';

  @override
  String get signInToCreatePost => '投稿を作成するにはログインしてください';

  @override
  String get tagsOptional => 'タグ（任意）';

  @override
  String get tagsHint => 'カンマまたはスペースで区切る';

  @override
  String get saveDraft => '下書きを保存';

  @override
  String get draftSaved => '下書きを保存しました';

  @override
  String draftAutoSaved(String time) {
    return '$time に下書きを自動保存しました';
  }

  @override
  String get restoreDraftTitle => '下書きを復元しますか？';

  @override
  String get restoreDraftMessage => '未公開の下書きが見つかりました。復元しますか？';

  @override
  String get restoreDraft => '復元';

  @override
  String get discardDraft => '破棄';

  @override
  String get hotTags => '人気タグ';

  @override
  String get attachmentUrls => '添付ファイル URL';

  @override
  String get attachmentUrlsHint => '任意の添付ファイル URL。Bilibili 動画リンクも対応';

  @override
  String get attachmentUrlHint => 'https://…';

  @override
  String get addAttachmentUrl => '添付 URL を追加';

  @override
  String get removeAttachment => '添付を削除';

  @override
  String maxImagesReached(int count) {
    return '画像は最大 $count 枚までです';
  }

  @override
  String get articleImages => '記事画像';

  @override
  String get articleImagesHint =>
      '記事ギャラリー用に最大5枚（Markdown ではありません）。カバー未設定の場合は最初の画像がカバーとして使用されます。';

  @override
  String get deleteImage => '画像を削除';

  @override
  String get hideExternalPosts => '外部フィードを非表示';

  @override
  String get hideExternalPostsDescription => '外部 RSS から取り込んだ投稿を非表示にします（既定でオン）';

  @override
  String get tasksSection => 'タスク';

  @override
  String get autoCheckin => '起動時に自動チェックイン';

  @override
  String get autoCheckinDescription =>
      'アプリを起動するたびにデイリーチェックインを試します（本日分済みならスキップ）';

  @override
  String get groupNoChannels => 'このグループにはまだチャンネルがありません';

  @override
  String get channelReadOnly => 'このチャンネルには投稿できません';

  @override
  String get shopTypeAppPack => 'APP パッケージ';

  @override
  String get shopType3d => '3D モデル';

  @override
  String get shopTypeAnimation => 'アニメーション';

  @override
  String get shopTypeArchive => 'アーカイブ';

  @override
  String get shopTypeMusic => '音楽';

  @override
  String get shopTypeMp2 => 'MP2 音楽';

  @override
  String get shopTypeLiba2 => 'LIBA2 音楽';

  @override
  String get shopTypeSkill => 'スキル';

  @override
  String get shopTypeNurture => '育成アイテム';

  @override
  String get shopTypeNurtureTicket => '育成チケット';

  @override
  String get aiWebSearch => 'ウェブ検索';

  @override
  String get aiDrawing => '画像生成';

  @override
  String get aiDrawModel => '画像生成モデル';

  @override
  String get aiDrawNoModels => '利用可能な画像生成モデルがありません';

  @override
  String get aiDrawAspect => 'アスペクト比';

  @override
  String get aiDrawQuality => '画質';

  @override
  String get aiFeedbackThanks => 'フィードバックありがとうございます';

  @override
  String get aiFeedbackHelpful => '役に立った';

  @override
  String get aiFeedbackNotHelpful => '役に立たなかった';

  @override
  String get aiImages => '画像';

  @override
  String get shopMusicHint => '音声リソースです。購入後にファイルをダウンロードできます（アプリ内再生は未対応）。';

  @override
  String get shop3dHint => '3D モデルリソースです。購入後にファイルをダウンロードできます。';

  @override
  String get shopAnimationHint => 'アニメーションリソースです。購入後にファイルをダウンロードできます。';

  @override
  String get shopArchiveHint => 'アーカイブリソースです。購入後にダウンロードできます。';

  @override
  String get shopAppPackHint => 'APP パッケージリソースです。購入後にダウンロードできます。';

  @override
  String get shopSkillHint => 'スキルリソースです。購入後、AI セッションで有効化できます。';

  @override
  String get shopNurtureHint => '育成アイテムです。購入後、育成コンテンツで使用できます。';

  @override
  String get chatImage => '画像';

  @override
  String get chatImageUnavailable => '[画像を読み込めません]';

  @override
  String get chatImageLoading => '[画像を読み込み中]';

  @override
  String get chatSourceQq => 'QQ';

  @override
  String get chatSourceGame => 'ゲーム';

  @override
  String get chatInteropFallback => '[クロスプラットフォームメッセージ]';

  @override
  String get sendImage => '画像を送信';

  @override
  String get helpCenter => 'ヘルプセンター';

  @override
  String get helpSubtitle => 'モジュール別に公式チュートリアル・手順・トラブル対処を探せます。';

  @override
  String get searchGuides => 'チュートリアルを検索';

  @override
  String get allModules => 'すべてのモジュール';

  @override
  String get noGuides => '一致するチュートリアルがありません。';

  @override
  String get clear => 'クリア';

  @override
  String guideRevision(Object revision) {
    return '改訂 $revision';
  }

  @override
  String get guideUnavailable => 'このチュートリアルは表示できません（非公開・オフライン・権限なし）。';

  @override
  String guideActionUnavailable(Object action) {
    return '「$action」はアプリ未対応です。';
  }

  @override
  String get officialGuide => '公式チュートリアル';

  @override
  String get guideAppliesTo => '対象';

  @override
  String get guideBeforeStart => 'はじめる前に';

  @override
  String get guideSteps => '手順';

  @override
  String get guideTroubleshooting => '困ったときは';

  @override
  String get guideRelated => '関連チュートリアル';

  @override
  String guideStableLink(Object key, Object revision) {
    return '固定リンク: /help/$key?revision=$revision';
  }

  @override
  String get guideCheck => '確認';

  @override
  String get notifications => '通知';

  @override
  String get announcements => 'お知らせ';

  @override
  String get notificationsEmpty => '通知はまだありません。';

  @override
  String get markAllRead => 'すべて既読';

  @override
  String get clearNotifications => '消去';

  @override
  String get clearNotificationsConfirm => '通知をすべて消去しますか？';

  @override
  String notificationCount(Object count) {
    return '通知 $count 件';
  }

  @override
  String get noAnnouncements => 'お知らせはまだありません。';

  @override
  String get markAnnouncementRead => '既読にする';

  @override
  String get gotIt => '了解';

  @override
  String announcementCount(Object count) {
    return 'お知らせ $count 件';
  }

  @override
  String get notificationsTabMessages => '通知';

  @override
  String get notificationsTabAnnouncements => 'お知らせ';

  @override
  String get notifyFriendRequest => 'フレンド申請';

  @override
  String get notifyFriendAccept => 'フレンド承認';

  @override
  String get notifyMessage => '新着メッセージ';

  @override
  String get notifyLike => 'いいね';

  @override
  String get notifyComment => 'コメント';

  @override
  String get notifyMention => 'メンション';

  @override
  String get notifyFollow => 'フォロー';

  @override
  String get notifyShare => 'シェア';

  @override
  String get notifyGroupInvite => 'グループ招待';

  @override
  String get notifySystem => 'システム';

  @override
  String get notifyDraw => '画像生成';

  @override
  String get notifyBill => '残高';

  @override
  String get systemAnnouncement => 'システムお知らせ';

  @override
  String groupInvitePrompt(Object group) {
    return '「$group」への招待です。承認すると参加します。';
  }

  @override
  String get conversationUnavailable => 'この会話は利用できません。';

  @override
  String get decline => '拒否';

  @override
  String get accept => '承認';

  @override
  String get resources => '資料';

  @override
  String get resourcesDescription => '資料ライブラリ・ギャラリー・経験ベース';

  @override
  String get notificationsDescription => 'サイト内通知とお知らせを確認';

  @override
  String get resourceLibrary => '資料ライブラリ';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get experience => '経験ベース';

  @override
  String get experiencePositive => '肯定的な経験';

  @override
  String get experienceNegative => '否定的な経験';

  @override
  String get resourceSearch => 'ファイル名を検索';

  @override
  String get resourceLibraryEmpty => '本棚はまだ空です。';

  @override
  String get resourceLoginRequired => '資料ライブラリにはログインが必要です。';

  @override
  String get resourceTypeAll => 'すべて';

  @override
  String get resourceTypeDoc => '文書';

  @override
  String get resourceTypeMd => 'Markdown';

  @override
  String get resourceTypeWord => 'Word';

  @override
  String get resourceTypePpt => 'PPT';

  @override
  String get resourceTypePdf => 'PDF';

  @override
  String get resourceTypeSheet => '表計算';

  @override
  String get resourceTypeImage => '画像';

  @override
  String get galleryEmpty => 'ギャラリーにはまだ写真がありません。';

  @override
  String galleryDayCount(Object count) {
    return '$count 枚';
  }

  @override
  String get experienceSearch => '当てはまる問題や経験内容を検索';

  @override
  String get experienceEmpty => '有効な経験はまだありません。';

  @override
  String get experienceLoginRequired => 'ログインすると経験ベースを閲覧できます。';

  @override
  String experienceTotal(Object count) {
    return '全 $count 件';
  }

  @override
  String get sceneNormal => '通常チャット';

  @override
  String get sceneNurture => '育成';

  @override
  String get sceneGlobal => '共通';

  @override
  String get skillLabel => 'スキル';

  @override
  String get openOriginal => '原図を開く';

  @override
  String get docPreviewUnavailable => 'この資料はプレビューできません。元ファイルを開いてください。';

  @override
  String get aiModeChat => 'チャット';

  @override
  String get aiModeHistorian => '史官';

  @override
  String get aiHistorianWorking => '考証と整理をしています…';

  @override
  String get aiHistorianHint => '史官モード：記録を照合し、出来事を考証し、年代を整理します。';

  @override
  String get aiHistorianPlaceholder => '人物・出来事・年代を入力して考証を開始…';

  @override
  String get aiArchivePreview => '本文の準備ができました。実体の表紙を補完中…';

  @override
  String get aiArchiveSaving => '表紙を補完しました。保存中…';

  @override
  String get aiSkillsTitle => 'スキル';

  @override
  String get aiSkillsEmpty => '利用できるスキルはありません。';

  @override
  String get aiSkillPurchased => '購入済み';

  @override
  String get aiTasksTitle => 'タスクリスト';

  @override
  String get aiTasksEmpty => 'この会話にタスクはありません。';

  @override
  String aiTasksFooter(Object count) {
    return 'このバッチは $count 件 · 折りたたみは同意ではありません';
  }

  @override
  String get aiTasksCancel => 'タスクをキャンセル';

  @override
  String get aiTasksConfirm => '実行を確認';

  @override
  String get aiTasksReady => 'AI が回答を待っています';

  @override
  String get aiTaskPending => '確認待ち';

  @override
  String get aiTaskRunning => '実行中';

  @override
  String get aiTaskDone => '完了';

  @override
  String get aiTaskFailed => '失敗';

  @override
  String get aiTaskCancelled => 'キャンセル';

  @override
  String get aiTaskApproved => '処理済み';

  @override
  String get aiQuestionMultiHint => '複数選択も、自分の考えの追記もできます';

  @override
  String get aiQuestionSingleHint => '答えを一つ選ぶか、自分の考えを書いてください';

  @override
  String get aiQuestionCustomHint => '自分の言葉で';

  @override
  String aiPendingTitle(Object count) {
    return '確認待ちの操作（$count）';
  }

  @override
  String get aiPendingApprove => '実行を確認';

  @override
  String get aiPendingReject => '拒否';

  @override
  String get aiPendingSubmitted => '送信しました';

  @override
  String get addAttachment => '画像を追加';

  @override
  String get attachmentFailed => '選択した画像を読み込めません。';

  @override
  String get docImages => '資料の画像';

  @override
  String get chatQuote => '引用';

  @override
  String get chatCancelQuote => '引用をキャンセル';

  @override
  String get chatQuoting => '引用中';

  @override
  String get chatCopy => 'コピー';

  @override
  String get chatCopied => 'コピーしました';

  @override
  String get chatRecall => '取り消し';

  @override
  String get chatRecalled => 'メッセージを取り消しました';

  @override
  String get chatReaction => 'リアクション';

  @override
  String get chatViewOriginal => '元画像を表示';

  @override
  String get chatHdr => 'HDR 原画';

  @override
  String get chatChartUnavailable => 'グラフを表示できません';

  @override
  String get chatMessageActions => 'メッセージ操作';

  @override
  String get chatQuotedMessage => '引用されたメッセージ';
}
