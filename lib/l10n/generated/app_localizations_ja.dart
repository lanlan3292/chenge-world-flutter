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
}
