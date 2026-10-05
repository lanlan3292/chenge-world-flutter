// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get communityTitle => 'ChengeWorld 커뮤니티';

  @override
  String get discover => '둘러보기';

  @override
  String get social => '소셜';

  @override
  String get store => '스토어';

  @override
  String get account => '내 정보';

  @override
  String get settings => '설정';

  @override
  String get appearance => '화면 설정';

  @override
  String get themeMode => '테마 모드';

  @override
  String get followSystem => '시스템 설정 따르기';

  @override
  String get light => '라이트';

  @override
  String get dark => '다크';

  @override
  String get language => '언어';

  @override
  String get dynamicColor => '동적 색상';

  @override
  String get dynamicColorDescription => 'Android 12+ 배경화면 색상 사용(Material You)';

  @override
  String get themeColor => '테마 색상';

  @override
  String get systemBars => '시스템 바';

  @override
  String get statusBarImmersive => '상태 표시줄 투명';

  @override
  String get statusBarDescription => '콘텐츠가 투명한 상태 표시줄 뒤까지 확장됩니다';

  @override
  String get navigationBarImmersive => '내비게이션 바 투명';

  @override
  String get navigationBarDescription => '콘텐츠가 투명한 내비게이션 바 뒤까지 확장됩니다';

  @override
  String get scrollBehavior => '스크롤 동작';

  @override
  String get autoHideTopBar => '상단 바 자동 숨기기';

  @override
  String get autoHideTopDescription => '둘러보기/스토어에서 아래로 스크롤할 때 앱 바를 숨깁니다(기본 켜짐)';

  @override
  String get autoHideBottomBar => '하단 바 자동 숨기기';

  @override
  String get autoHideBottomDescription =>
      '아래로 스크롤할 때 하단 내비게이션을 숨깁니다. 넓은 화면에서는 레일이 계속 표시됩니다';

  @override
  String get chat => '채팅';

  @override
  String get showSelfAvatar => '채팅에서 내 아바타 표시';

  @override
  String get showSelfAvatarDescription => '보낸 메시지 옆에 내 아바타를 표시합니다(기본 꺼짐)';

  @override
  String get showPeerAvatar => '개인 채팅에서 상대방 아바타 표시';

  @override
  String get showPeerAvatarDescription =>
      '개인 메시지 옆에 상대방 아바타를 표시합니다. 그룹 아바타는 항상 표시됩니다(기본 꺼짐)';

  @override
  String get systemGestures => '시스템 제스처';

  @override
  String get predictiveBack => '예측형 뒤로 가기';

  @override
  String get predictiveBackDescription =>
      'Android 13+에서 예측형 뒤로 가기 애니메이션을 사용합니다(기본 꺼짐)';

  @override
  String get layout => '레이아웃';

  @override
  String get feedColumns => '둘러보기 그리드 열 수';

  @override
  String get shopColumns => '스토어 그리드 열 수';

  @override
  String columnRange(int min, int max) {
    return '현재: $min–$max열(공간이 허용하면 이 범위 내에서 자동 조정)';
  }

  @override
  String minimumColumns(int count) {
    return '최소 $count';
  }

  @override
  String maximumColumns(int count) {
    return '최대 $count';
  }

  @override
  String postCount(int count) {
    return '게시물 $count개';
  }

  @override
  String pageCount(int page, int total) {
    return '$total페이지 중 $page페이지';
  }

  @override
  String itemCount(int count) {
    return '상품 $count개';
  }

  @override
  String get rightNow => '지금 이야기 중';

  @override
  String get freshDiscussions => '커뮤니티의 새로운 이야기를 확인하세요';

  @override
  String get searchPostsAndTopics => '게시물 및 주제 검색';

  @override
  String get search => '검색';

  @override
  String get refreshPosts => '게시물 새로고침';

  @override
  String get latest => '최신';

  @override
  String get popular => '인기';

  @override
  String get featured => '추천';

  @override
  String get noPosts => '아직 게시물이 없습니다';

  @override
  String get noPostsHint => '다른 키워드를 입력하거나 나중에 다시 확인하세요';

  @override
  String get retry => '다시 시도';

  @override
  String get previousPage => '이전 페이지';

  @override
  String get nextPage => '다음 페이지';

  @override
  String get signOut => '로그아웃';

  @override
  String get confirmSignOut => 'ChengeWorld에서 로그아웃하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get exit => '로그아웃';

  @override
  String get signedOut => '로그아웃되었습니다';

  @override
  String get accountSettingsSignIn => '계정 설정을 관리하려면 로그인하세요';

  @override
  String get signedIn => '로그인됨';

  @override
  String get welcome => '커뮤니티에 오신 것을 환영합니다';

  @override
  String get accountConnected => '계정이 ChengeWorld에 연결되었습니다';

  @override
  String get signInForPersonalized => '로그인하여 맞춤형 콘텐츠를 둘러보세요';

  @override
  String get taskCenter => '작업 센터';

  @override
  String get taskCenterDescription => '출석하고 작업을 완료하여 ChengeCoin을 받으세요';

  @override
  String get signIn => '로그인';

  @override
  String get signInAccount => '로그인';

  @override
  String get signInSuccess => '로그인 성공';

  @override
  String get signInToChengeWorld => 'ChengeWorld에 로그인';

  @override
  String get username => '사용자 이름';

  @override
  String get enterUsername => '사용자 이름 입력';

  @override
  String get password => '비밀번호';

  @override
  String get showPassword => '비밀번호 표시';

  @override
  String get hidePassword => '비밀번호 숨기기';

  @override
  String get enterPassword => '비밀번호 입력';

  @override
  String get signingIn => '로그인 중…';

  @override
  String get contacts => '연락처';

  @override
  String get productDetails => '상품 상세';

  @override
  String get post => '게시물';

  @override
  String get shopNow => '스토어';

  @override
  String get myAssets => '내 자산';

  @override
  String get orders => '주문';

  @override
  String get discoverItems => '상품 둘러보기';

  @override
  String get searchProducts => '상품 검색';

  @override
  String get sortProducts => '상품 정렬';

  @override
  String get newestArrivals => '최신 등록';

  @override
  String get popularProducts => '인기 상품';

  @override
  String get priceLowToHigh => '가격: 낮은 순';

  @override
  String get priceHighToLow => '가격: 높은 순';

  @override
  String get ratingFirst => '평점 높은 순';

  @override
  String get all => '전체';

  @override
  String get files => '파일';

  @override
  String get emojiPacks => '이모티콘 팩';

  @override
  String get components => '컴포넌트';

  @override
  String get applications => '애플리케이션';

  @override
  String get executables => '실행 파일';

  @override
  String get libraries => '라이브러리';

  @override
  String get functionLibraries => '함수 라이브러리';

  @override
  String get noAssetsOrOrdersSignIn => '자산과 주문을 보려면 로그인하세요';

  @override
  String get goSignIn => '로그인';

  @override
  String get shopUnavailable => '스토어를 일시적으로 사용할 수 없습니다';

  @override
  String get checkNetworkAndRetry => '연결을 확인한 후 다시 시도하세요';

  @override
  String get noProducts => '아직 상품이 없습니다';

  @override
  String get tryOtherSearch => '다른 키워드나 카테고리를 시도해 보세요';

  @override
  String get noAssets => '아직 자산이 없습니다';

  @override
  String get noOrders => '아직 주문이 없습니다';

  @override
  String get purchasesShowHere => '스토어 구매 내역이 여기에 표시됩니다';

  @override
  String get refresh => '새로고침';

  @override
  String get refreshTasks => '작업 새로고침';

  @override
  String get claimComplete => '완료하기';

  @override
  String rewardClaimed(String coins) {
    return '보상 수령: +$coins CC';
  }

  @override
  String get productPurchaseSuccess => '구매 완료. 자산에 추가되었습니다';

  @override
  String get signInToLike => '이 게시물을 좋아하려면 로그인하세요';

  @override
  String get signInToComment => '댓글을 작성하려면 로그인하세요';

  @override
  String get commentPublished => '댓글이 게시되었습니다';

  @override
  String get noComments => '아직 댓글이 없습니다';

  @override
  String get back => '뒤로';

  @override
  String commentCount(int count) {
    return '댓글 · $count';
  }

  @override
  String get refreshComments => '댓글 새로고침';

  @override
  String get cancelReply => '답글 취소';

  @override
  String get writeComment => '댓글을 작성하세요…';

  @override
  String get reply => '답글';

  @override
  String get publishing => '게시 중…';

  @override
  String get publishComment => '댓글 게시';

  @override
  String get liked => '좋아요함';

  @override
  String get like => '좋아요';

  @override
  String commentsWithCount(int count) {
    return '댓글 ($count)';
  }

  @override
  String get noMessages => '아직 메시지가 없습니다. 인사해 보세요!';

  @override
  String get online => '온라인';

  @override
  String get offline => '오프라인';

  @override
  String get groupChat => '그룹 채팅';

  @override
  String get loadOlderMessages => '이전 메시지 불러오기';

  @override
  String get backToConversations => '대화 목록으로 돌아가기';

  @override
  String get searchConversation => '대화 검색';

  @override
  String get addressBook => '연락처';

  @override
  String get noFriendsToInvite => '초대할 친구가 아직 없습니다';

  @override
  String get selectConversation => '대화를 선택하여 채팅을 시작하세요';

  @override
  String get refreshConversations => '대화 새로고침';

  @override
  String get signInToStartChat => '채팅을 시작하려면 로그인하세요';

  @override
  String get chengeCore => 'ChengeCore';

  @override
  String get signInWithToken => 'Token으로 로그인';

  @override
  String get openOfficialSiteWithWebView => 'WebView로 공식 사이트 열기';

  @override
  String get close => '닫기';

  @override
  String get raising => '육성';

  @override
  String get copy => '복사';

  @override
  String get webViewNotSupportedOnAllOs => '모든 운영 체제에서 WebView를 지원하는 것은 아닙니다';

  @override
  String get platformWebViewNotSupported => '이 플랫폼에서는 내장 웹 보기를 지원하지 않습니다';

  @override
  String get openCoreEcosystem => '핵심 생태계 열기';

  @override
  String get openRaisingSystem => '육성 시스템 열기';

  @override
  String get cannotOpenSiteMissingConfig => '사이트를 열 수 없음: 서비스 구성이 누락되었습니다';

  @override
  String get accessTokenDescription => '신원 확인에 사용되는 액세스 토큰';

  @override
  String get confirm => '확인';

  @override
  String get confirmSignIn => '로그인 확인';

  @override
  String get pasteJwtToken => 'JWT Token 붙여넣기';

  @override
  String get accessToken => '액세스 토큰';

  @override
  String get accessTokenCopied => '액세스 토큰이 복사되었습니다';

  @override
  String get accessTokenUpdated => '액세스 토큰이 업데이트되었습니다';

  @override
  String get signInToUseChengeCore => 'ChengeCore를 사용하려면 로그인하세요';

  @override
  String get signInToUseRaising => '육성을 사용하려면 로그인하세요';

  @override
  String get enterToken => 'Token을 입력하세요';

  @override
  String get communityMerchant => '커뮤니티 판매자';

  @override
  String get product => '상품';

  @override
  String get productInitial => '상';

  @override
  String stockCount(int count) {
    return '재고 $count';
  }

  @override
  String soldCount(int count) {
    return '판매됨 $count';
  }

  @override
  String ratingReviews(String rating, int count) {
    return '$rating · 리뷰 $count개';
  }

  @override
  String get productDescription => '설명';

  @override
  String get purchasedContent => '구매한 콘텐츠';

  @override
  String get purchaseToViewContent => '전체 콘텐츠를 보려면 구매하세요';

  @override
  String get openOrDownloadFile => '파일 열기/다운로드';

  @override
  String balanceCc(String amount) {
    return '잔액 $amount CC';
  }

  @override
  String get buying => '구매 중…';

  @override
  String get buy => '구매';

  @override
  String get yourListedProduct => '내가 등록한 상품입니다';

  @override
  String get backToShop => '스토어로 돌아가기';

  @override
  String holdingQuantityType(Object quantity, String type) {
    return '보유 $quantity개 · $type';
  }

  @override
  String get orderPending => '결제 대기';

  @override
  String get orderPaid => '결제 완료';

  @override
  String get orderRefunded => '환불됨';

  @override
  String get statusUnknown => '알 수 없는 상태';

  @override
  String get conversationNotFound => '대화를 찾을 수 없습니다. 새로고침 후 다시 시도하세요';

  @override
  String get noMatchingConversations => '일치하는 대화가 없습니다';

  @override
  String get noConversationsYet => '아직 대화가 없습니다';

  @override
  String get goContactsToChat => '연락처로 이동하여 채팅을 시작하세요';

  @override
  String get friendInitial => '친';

  @override
  String get noMessagesYetShort => '아직 메시지가 없습니다';

  @override
  String previewEmoji(String key) {
    return '[이모티콘] $key';
  }

  @override
  String get previewSharedPost => '[공유 게시물]';

  @override
  String get previewOrder => '[상품 주문]';

  @override
  String get emojiMessage => '이모티콘 메시지';

  @override
  String get me => '나';

  @override
  String get sharedPost => '공유 게시물';

  @override
  String get productOrder => '상품 주문';

  @override
  String get cannotOpenPostMissingId => '게시물을 열 수 없음: 공유에 게시물 ID가 없습니다';

  @override
  String get cannotOpenProductMissingId => '상품을 열 수 없음: 공유에 상품 ID가 없습니다';

  @override
  String get chengeUser => 'Chenge 사용자';

  @override
  String get signInToPurchase => '구매하려면 로그인하세요';

  @override
  String get typeMessage => '메시지를 입력하세요…';

  @override
  String get sendMessage => '메시지 보내기';

  @override
  String get emoji => '이모티콘';

  @override
  String get previewEmojiOnly => '[이모티콘]';

  @override
  String get enterGroupNameKeyword => '그룹 이름 키워드 입력';

  @override
  String get enterUserSearchHint => '사용자 이름, 닉네임 또는 이메일 입력';

  @override
  String get friendAddedBack => '맞추가됨 — 이제 친구입니다';

  @override
  String get friendRequestSent => '친구 요청을 보냈습니다';

  @override
  String get rejectFriendRequest => '친구 요청 거절';

  @override
  String get removeFriend => '친구 삭제';

  @override
  String confirmRejectFriendRequest(String name) {
    return '$name님의 친구 요청을 거절하시겠습니까?';
  }

  @override
  String confirmRemoveFriend(String name) {
    return '$name님을 친구에서 삭제하시겠습니까?';
  }

  @override
  String get reject => '거절';

  @override
  String get remove => '삭제';

  @override
  String get friendRequestRejected => '친구 요청을 거절했습니다';

  @override
  String get friendRemoved => '친구를 삭제했습니다';

  @override
  String get remarkCleared => '메모가 지워졌습니다';

  @override
  String get remarkSaved => '메모가 저장되었습니다';

  @override
  String joinedGroup(String name) {
    return '「$name」에 가입했습니다';
  }

  @override
  String get enterGroupName => '그룹 이름을 입력하세요';

  @override
  String groupCreated(String name) {
    return '그룹 채팅 「$name」이(가) 생성되었습니다';
  }

  @override
  String get createGroupChat => '그룹 채팅 만들기';

  @override
  String get signInToManageContacts => '연락처를 관리하려면 로그인하세요';

  @override
  String get contactsSubtitle => '사용자 검색, 그룹 가입, 친구 요청 관리';

  @override
  String friendsTab(int count) {
    return '친구 $count';
  }

  @override
  String groupsTab(int count) {
    return '그룹 $count';
  }

  @override
  String requestsTab(int count) {
    return '요청 $count';
  }

  @override
  String get searchUsers => '사용자';

  @override
  String get searchGroups => '그룹';

  @override
  String get groupNameKeyword => '그룹 이름 키워드';

  @override
  String get userSearchHint => '사용자 이름, 닉네임 또는 이메일';

  @override
  String get searchGroupsTooltip => '그룹 검색';

  @override
  String get searchUsersTooltip => '사용자 검색';

  @override
  String get searchPublicGroups => '공개 그룹 검색';

  @override
  String get searchChengeUsers => 'ChengeWorld 사용자 검색';

  @override
  String get searchPublicGroupsHint => '그룹 이름을 입력하여 원하는 그룹에 가입하세요';

  @override
  String get searchUsersHint => '사용자 이름, 닉네임 또는 이메일 지원';

  @override
  String get noMatchingGroups => '일치하는 그룹이 없습니다';

  @override
  String get noMatchingPeople => '일치하는 사람이 없습니다';

  @override
  String get tryOtherKeywords => '다른 키워드를 시도해 보세요';

  @override
  String get noGroupsYet => '아직 그룹이 없습니다';

  @override
  String get noGroupsHint => '그룹을 만들거나 검색에서 공개 그룹에 가입하세요';

  @override
  String get noFriendsYet => '아직 친구가 없습니다';

  @override
  String get noFriendsHint => '사용자 이름이나 닉네임으로 검색하여 새로운 사람을 만나보세요';

  @override
  String get noPendingRequests => '대기 중인 요청이 없습니다';

  @override
  String get noPendingRequestsHint => '새 친구 요청이 여기에 표시됩니다';

  @override
  String get groupTapToJoin => '그룹 · 탭하여 가입';

  @override
  String get join => '가입';

  @override
  String get enterGroup => '그룹 들어가기';

  @override
  String requestAddYou(String username) {
    return '@$username · 친구 추가를 요청함';
  }

  @override
  String onlineWithRemark(String status, String remark, String username) {
    return '$status · 메모: $remark · @$username';
  }

  @override
  String get friend => '친구';

  @override
  String get addBack => '맞추가';

  @override
  String get requested => '요청됨';

  @override
  String get add => '추가';

  @override
  String get acceptAndAddBack => '수락 및 맞추가';

  @override
  String get rejectRequest => '요청 거절';

  @override
  String get friendActions => '친구 작업';

  @override
  String get sendMessageAction => '메시지';

  @override
  String get editRemark => '메모 편집';

  @override
  String get setRemark => '메모 설정';

  @override
  String get removeFriendRelation => '친구 삭제';

  @override
  String get setFriendRemark => '친구 메모 설정';

  @override
  String get remarkName => '메모 이름';

  @override
  String get remarkHintClear => '비워 두면 메모가 지워집니다';

  @override
  String get save => '저장';

  @override
  String get groupName => '그룹 이름';

  @override
  String get groupNameHint => '그룹에 이름을 지정하세요';

  @override
  String get selectMembersOptional => '멤버 선택(선택 사항)';

  @override
  String get create => '만들기';

  @override
  String get newConversation => '새 채팅';

  @override
  String get deleteSession => '대화 삭제';

  @override
  String confirmDeleteSession(String name) {
    return '「$name」을(를) 삭제하시겠습니까? 채팅 기록도 삭제됩니다.';
  }

  @override
  String get delete => '삭제';

  @override
  String get newChat => '새 채팅';

  @override
  String get refreshSessions => '대화 새로고침';

  @override
  String get signInToUseAiAgent => 'AI Agent를 사용하려면 로그인하세요';

  @override
  String get aiAgentSubtitle => '다중 세션, 스트리밍 답변 및 MCP 도구';

  @override
  String get selectOrCreateAiSession => 'AI 세션을 선택하거나 새로 만드세요';

  @override
  String get aiSessions => 'AI 세션';

  @override
  String get noAiChatsYet => '아직 AI 채팅이 없습니다';

  @override
  String get tapNewToStartChat => '아래의 새로 만들기를 눌러 채팅을 시작하세요';

  @override
  String get thinking => '생각 중…';

  @override
  String get aiRequestFailed => 'AI 요청 실패';

  @override
  String get noTextReply => '(텍스트 답변 없음)';

  @override
  String get waitingConfirm => '확인 대기 중…';

  @override
  String receivedType(String type) {
    return '$type 수신';
  }

  @override
  String get backToSessionList => '세션 목록으로 돌아가기';

  @override
  String get sendMessageToStart => '메시지를 보내 대화를 시작하세요';

  @override
  String get askAiAgent => 'AI Agent에게 질문…';

  @override
  String emojiPackTitle(Object id) {
    return '이모티콘 팩 $id';
  }

  @override
  String get noEmojiPacksBuyInShop => '아직 이모티콘 팩이 없습니다 — 스토어에서 구매하세요';

  @override
  String replyToUser(String name) {
    return '@$name에게 답글';
  }

  @override
  String get user => '사용자';

  @override
  String get anonymousUser => '익명';

  @override
  String get timeUnknown => '알 수 없는 시간';

  @override
  String dateYmd(int year, int month, int day) {
    return '$year년 $month월 $day일';
  }

  @override
  String get tasksInProgress => '진행 중';

  @override
  String get tasksNoInProgress => '진행 중인 작업이 없습니다';

  @override
  String get tasksCompletedSection => '완료됨';

  @override
  String get tasksRewardHint => '보상은 수동으로 수령해야 합니다 · 작업은 주기적으로 새로고침됩니다';

  @override
  String get tasksTodayGoal => '오늘의 목표';

  @override
  String get tasksTodayGoalSubtitle => '커뮤니티 작업을 완료하고 ChengeCoin을 받으세요';

  @override
  String tasksProgressSummary(int completed) {
    return '대기 중 · $completed개 완료';
  }

  @override
  String get taskClaimable => '수령 가능';

  @override
  String get taskCompletedBadge => '완료';

  @override
  String taskCheckinStreak(int streak, int totalDays) {
    return '$streak일 연속 출석 · 총 $totalDays일';
  }

  @override
  String get checkIn => '출석';

  @override
  String get claim => '수령';

  @override
  String get statusBarTopHideMask => '상단 바 숨김 시 상태 표시줄 마스크';

  @override
  String get statusBarTopHideMaskDescription =>
      '상단 바가 자동으로 숨겨질 수 있을 때 콘텐츠가 상태 표시줄 아래로 들어가지 않도록 반투명 테마 배경을 사용합니다(기본 켜짐)';

  @override
  String get siteAndToken => '사이트 및 토큰';

  @override
  String get officialSite => '공식 사이트';

  @override
  String webViewInitFailed(String errorType, String error) {
    return 'WebView 초기화 실패($errorType): $error\nWindows에는 Edge WebView2 Runtime이 필요합니다.';
  }

  @override
  String get registerAccount => '계정 만들기';

  @override
  String get registerTitle => 'ChengeWorld 가입';

  @override
  String get registerSuccess => '가입 성공. 로그인해 주세요.';

  @override
  String get nicknameOptional => '닉네임(선택 사항)';

  @override
  String get email => '이메일';

  @override
  String get enterEmail => '이메일 입력';

  @override
  String get invalidEmail => '이메일 형식이 올바르지 않습니다';

  @override
  String get emailCode => '이메일 인증 코드';

  @override
  String get enterEmailCode => '인증 코드 입력';

  @override
  String get getEmailCode => '코드 받기';

  @override
  String get sendingCode => '전송 중';

  @override
  String get emailCodeSent => '코드가 전송되었습니다(개발 환경에서는 백엔드 로그를 확인하세요)';

  @override
  String get fillEmailFirst => '먼저 이메일을 입력하세요';

  @override
  String get passwordMinSix => '비밀번호(최소 6자)';

  @override
  String get passwordTooShort => '비밀번호는 최소 6자 이상이어야 합니다';

  @override
  String get register => '가입';

  @override
  String get registering => '가입 중…';

  @override
  String get clearCache => '캐시 지우기';

  @override
  String get clearCacheDescription => '로그아웃하지 않고 로컬 이미지 캐시를 지웁니다';

  @override
  String get clearCacheConfirm => '로컬 캐시를 지우시겠습니까?';

  @override
  String get clearCacheDone => '캐시가 지워졌습니다';

  @override
  String get clearingCache => '지우는 중…';

  @override
  String get accessTokenCleared => '액세스 토큰이 지워졌습니다';

  @override
  String get createPost => '새 게시물';

  @override
  String get publishPost => '게시';

  @override
  String get postTitle => '제목';

  @override
  String get postContent => '내용(Markdown)';

  @override
  String get markdownHint => 'Markdown을 지원합니다. 이미지를 삽입할 수 있습니다.';

  @override
  String get insertImage => '이미지 삽입';

  @override
  String get coverImage => '커버 이미지';

  @override
  String get chooseCover => '커버 선택';

  @override
  String get removeCover => '커버 제거';

  @override
  String get category => '카테고리';

  @override
  String get selectCategoryHint => '카테고리를 선택하세요';

  @override
  String get noCategories => '사용 가능한 카테고리가 없습니다';

  @override
  String get titleRequired => '제목을 입력하세요';

  @override
  String get contentRequired => '내용을 입력하세요';

  @override
  String get postPublished => '게시물이 게시되었습니다';

  @override
  String get signInToCreatePost => '게시물을 작성하려면 로그인하세요';

  @override
  String get tagsOptional => '태그(선택 사항)';

  @override
  String get tagsHint => '쉼표 또는 공백으로 구분';

  @override
  String get saveDraft => '임시 저장';

  @override
  String get draftSaved => '임시 저장되었습니다';

  @override
  String draftAutoSaved(String time) {
    return '$time에 임시 저장되었습니다';
  }

  @override
  String get restoreDraftTitle => '임시 저장 복원?';

  @override
  String get restoreDraftMessage => '게시되지 않은 임시 저장이 있습니다. 복원하시겠습니까?';

  @override
  String get restoreDraft => '복원';

  @override
  String get discardDraft => '버리기';

  @override
  String get hotTags => '인기 태그';

  @override
  String get attachmentUrls => '첨부 파일 URL';

  @override
  String get attachmentUrlsHint => '모든 첨부 파일 URL; Bilibili 동영상 링크도 지원';

  @override
  String get attachmentUrlHint => 'https://…';

  @override
  String get addAttachmentUrl => '첨부 URL 추가';

  @override
  String get removeAttachment => '첨부 제거';

  @override
  String maxImagesReached(int count) {
    return '이미지는 최대 $count장까지 가능합니다';
  }

  @override
  String get articleImages => '글 이미지';

  @override
  String get articleImagesHint =>
      '글 갤러리에 최대 5장(Markdown 아님). 커버가 없으면 첫 번째 이미지가 커버로 사용됩니다.';

  @override
  String get deleteImage => '이미지 삭제';

  @override
  String get bilibiliVideo => 'B 站视频';

  @override
  String get attachmentLink => '附件链接';

  @override
  String get cannotOpenLink => '无法打开链接';

  @override
  String get editMarkdown => '编辑';

  @override
  String get previewMarkdown => '预览';

  @override
  String get previewEmpty => '暂无内容可预览';

  @override
  String get editProfile => '编辑资料';

  @override
  String get editProfileDescription => '修改昵称、头像与个人简介';

  @override
  String get saveProfile => '保存';

  @override
  String get profileUpdated => '资料已更新';

  @override
  String get changeAvatar => '更换头像';

  @override
  String get nickname => '昵称';

  @override
  String get gender => '性别';

  @override
  String get genderSecret => '保密';

  @override
  String get genderMale => '男';

  @override
  String get genderFemale => '女';

  @override
  String get birthday => '生日';

  @override
  String get bio => '简介';

  @override
  String get website => '网站';

  @override
  String get phone => '手机号';
}

/// The translations for Korean, as used in Republic of Korea (`ko_KR`).
class AppLocalizationsKoKr extends AppLocalizationsKo {
  AppLocalizationsKoKr() : super('ko_KR');

  @override
  String get communityTitle => 'ChengeWorld 커뮤니티';

  @override
  String get discover => '둘러보기';

  @override
  String get social => '소셜';

  @override
  String get store => '스토어';

  @override
  String get account => '내 정보';

  @override
  String get settings => '설정';

  @override
  String get appearance => '화면 설정';

  @override
  String get themeMode => '테마 모드';

  @override
  String get followSystem => '시스템 설정 따르기';

  @override
  String get light => '라이트';

  @override
  String get dark => '다크';

  @override
  String get language => '언어';

  @override
  String get dynamicColor => '동적 색상';

  @override
  String get dynamicColorDescription => 'Android 12+ 배경화면 색상 사용(Material You)';

  @override
  String get themeColor => '테마 색상';

  @override
  String get systemBars => '시스템 바';

  @override
  String get statusBarImmersive => '상태 표시줄 투명';

  @override
  String get statusBarDescription => '콘텐츠가 투명한 상태 표시줄 뒤까지 확장됩니다';

  @override
  String get navigationBarImmersive => '내비게이션 바 투명';

  @override
  String get navigationBarDescription => '콘텐츠가 투명한 내비게이션 바 뒤까지 확장됩니다';

  @override
  String get scrollBehavior => '스크롤 동작';

  @override
  String get autoHideTopBar => '상단 바 자동 숨기기';

  @override
  String get autoHideTopDescription => '둘러보기/스토어에서 아래로 스크롤할 때 앱 바를 숨깁니다(기본 켜짐)';

  @override
  String get autoHideBottomBar => '하단 바 자동 숨기기';

  @override
  String get autoHideBottomDescription =>
      '아래로 스크롤할 때 하단 내비게이션을 숨깁니다. 넓은 화면에서는 레일이 계속 표시됩니다';

  @override
  String get chat => '채팅';

  @override
  String get showSelfAvatar => '채팅에서 내 아바타 표시';

  @override
  String get showSelfAvatarDescription => '보낸 메시지 옆에 내 아바타를 표시합니다(기본 꺼짐)';

  @override
  String get showPeerAvatar => '개인 채팅에서 상대방 아바타 표시';

  @override
  String get showPeerAvatarDescription =>
      '개인 메시지 옆에 상대방 아바타를 표시합니다. 그룹 아바타는 항상 표시됩니다(기본 꺼짐)';

  @override
  String get systemGestures => '시스템 제스처';

  @override
  String get predictiveBack => '예측형 뒤로 가기';

  @override
  String get predictiveBackDescription =>
      'Android 13+에서 예측형 뒤로 가기 애니메이션을 사용합니다(기본 꺼짐)';

  @override
  String get layout => '레이아웃';

  @override
  String get feedColumns => '둘러보기 그리드 열 수';

  @override
  String get shopColumns => '스토어 그리드 열 수';

  @override
  String columnRange(int min, int max) {
    return '현재: $min–$max열(공간이 허용하면 이 범위 내에서 자동 조정)';
  }

  @override
  String minimumColumns(int count) {
    return '최소 $count';
  }

  @override
  String maximumColumns(int count) {
    return '최대 $count';
  }

  @override
  String postCount(int count) {
    return '게시물 $count개';
  }

  @override
  String pageCount(int page, int total) {
    return '$total페이지 중 $page페이지';
  }

  @override
  String itemCount(int count) {
    return '상품 $count개';
  }

  @override
  String get rightNow => '지금 이야기 중';

  @override
  String get freshDiscussions => '커뮤니티의 새로운 이야기를 확인하세요';

  @override
  String get searchPostsAndTopics => '게시물 및 주제 검색';

  @override
  String get search => '검색';

  @override
  String get refreshPosts => '게시물 새로고침';

  @override
  String get latest => '최신';

  @override
  String get popular => '인기';

  @override
  String get featured => '추천';

  @override
  String get noPosts => '아직 게시물이 없습니다';

  @override
  String get noPostsHint => '다른 키워드를 입력하거나 나중에 다시 확인하세요';

  @override
  String get retry => '다시 시도';

  @override
  String get previousPage => '이전 페이지';

  @override
  String get nextPage => '다음 페이지';

  @override
  String get signOut => '로그아웃';

  @override
  String get confirmSignOut => 'ChengeWorld에서 로그아웃하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get exit => '로그아웃';

  @override
  String get signedOut => '로그아웃되었습니다';

  @override
  String get accountSettingsSignIn => '계정 설정을 관리하려면 로그인하세요';

  @override
  String get signedIn => '로그인됨';

  @override
  String get welcome => '커뮤니티에 오신 것을 환영합니다';

  @override
  String get accountConnected => '계정이 ChengeWorld에 연결되었습니다';

  @override
  String get signInForPersonalized => '로그인하여 맞춤형 콘텐츠를 둘러보세요';

  @override
  String get taskCenter => '작업 센터';

  @override
  String get taskCenterDescription => '출석하고 작업을 완료하여 ChengeCoin을 받으세요';

  @override
  String get signIn => '로그인';

  @override
  String get signInAccount => '로그인';

  @override
  String get signInSuccess => '로그인 성공';

  @override
  String get signInToChengeWorld => 'ChengeWorld에 로그인';

  @override
  String get username => '사용자 이름';

  @override
  String get enterUsername => '사용자 이름 입력';

  @override
  String get password => '비밀번호';

  @override
  String get showPassword => '비밀번호 표시';

  @override
  String get hidePassword => '비밀번호 숨기기';

  @override
  String get enterPassword => '비밀번호 입력';

  @override
  String get signingIn => '로그인 중…';

  @override
  String get contacts => '연락처';

  @override
  String get productDetails => '상품 상세';

  @override
  String get post => '게시물';

  @override
  String get shopNow => '스토어';

  @override
  String get myAssets => '내 자산';

  @override
  String get orders => '주문';

  @override
  String get discoverItems => '상품 둘러보기';

  @override
  String get searchProducts => '상품 검색';

  @override
  String get sortProducts => '상품 정렬';

  @override
  String get newestArrivals => '최신 등록';

  @override
  String get popularProducts => '인기 상품';

  @override
  String get priceLowToHigh => '가격: 낮은 순';

  @override
  String get priceHighToLow => '가격: 높은 순';

  @override
  String get ratingFirst => '평점 높은 순';

  @override
  String get all => '전체';

  @override
  String get files => '파일';

  @override
  String get emojiPacks => '이모티콘 팩';

  @override
  String get components => '컴포넌트';

  @override
  String get applications => '애플리케이션';

  @override
  String get executables => '실행 파일';

  @override
  String get libraries => '라이브러리';

  @override
  String get functionLibraries => '함수 라이브러리';

  @override
  String get noAssetsOrOrdersSignIn => '자산과 주문을 보려면 로그인하세요';

  @override
  String get goSignIn => '로그인';

  @override
  String get shopUnavailable => '스토어를 일시적으로 사용할 수 없습니다';

  @override
  String get checkNetworkAndRetry => '연결을 확인한 후 다시 시도하세요';

  @override
  String get noProducts => '아직 상품이 없습니다';

  @override
  String get tryOtherSearch => '다른 키워드나 카테고리를 시도해 보세요';

  @override
  String get noAssets => '아직 자산이 없습니다';

  @override
  String get noOrders => '아직 주문이 없습니다';

  @override
  String get purchasesShowHere => '스토어 구매 내역이 여기에 표시됩니다';

  @override
  String get refresh => '새로고침';

  @override
  String get refreshTasks => '작업 새로고침';

  @override
  String get claimComplete => '완료하기';

  @override
  String rewardClaimed(String coins) {
    return '보상 수령: +$coins CC';
  }

  @override
  String get productPurchaseSuccess => '구매 완료. 자산에 추가되었습니다';

  @override
  String get signInToLike => '이 게시물을 좋아하려면 로그인하세요';

  @override
  String get signInToComment => '댓글을 작성하려면 로그인하세요';

  @override
  String get commentPublished => '댓글이 게시되었습니다';

  @override
  String get noComments => '아직 댓글이 없습니다';

  @override
  String get back => '뒤로';

  @override
  String commentCount(int count) {
    return '댓글 · $count';
  }

  @override
  String get refreshComments => '댓글 새로고침';

  @override
  String get cancelReply => '답글 취소';

  @override
  String get writeComment => '댓글을 작성하세요…';

  @override
  String get reply => '답글';

  @override
  String get publishing => '게시 중…';

  @override
  String get publishComment => '댓글 게시';

  @override
  String get liked => '좋아요함';

  @override
  String get like => '좋아요';

  @override
  String commentsWithCount(int count) {
    return '댓글 ($count)';
  }

  @override
  String get noMessages => '아직 메시지가 없습니다. 인사해 보세요!';

  @override
  String get online => '온라인';

  @override
  String get offline => '오프라인';

  @override
  String get groupChat => '그룹 채팅';

  @override
  String get loadOlderMessages => '이전 메시지 불러오기';

  @override
  String get backToConversations => '대화 목록으로 돌아가기';

  @override
  String get searchConversation => '대화 검색';

  @override
  String get addressBook => '연락처';

  @override
  String get noFriendsToInvite => '초대할 친구가 아직 없습니다';

  @override
  String get selectConversation => '대화를 선택하여 채팅을 시작하세요';

  @override
  String get refreshConversations => '대화 새로고침';

  @override
  String get signInToStartChat => '채팅을 시작하려면 로그인하세요';

  @override
  String get chengeCore => 'ChengeCore';

  @override
  String get signInWithToken => 'Token으로 로그인';

  @override
  String get openOfficialSiteWithWebView => 'WebView로 공식 사이트 열기';

  @override
  String get close => '닫기';

  @override
  String get raising => '육성';

  @override
  String get copy => '복사';

  @override
  String get webViewNotSupportedOnAllOs => '모든 운영 체제에서 WebView를 지원하는 것은 아닙니다';

  @override
  String get platformWebViewNotSupported => '이 플랫폼에서는 내장 웹 보기를 지원하지 않습니다';

  @override
  String get openCoreEcosystem => '핵심 생태계 열기';

  @override
  String get openRaisingSystem => '육성 시스템 열기';

  @override
  String get cannotOpenSiteMissingConfig => '사이트를 열 수 없음: 서비스 구성이 누락되었습니다';

  @override
  String get accessTokenDescription => '신원 확인에 사용되는 액세스 토큰';

  @override
  String get confirm => '확인';

  @override
  String get confirmSignIn => '로그인 확인';

  @override
  String get pasteJwtToken => 'JWT Token 붙여넣기';

  @override
  String get accessToken => '액세스 토큰';

  @override
  String get accessTokenCopied => '액세스 토큰이 복사되었습니다';

  @override
  String get accessTokenUpdated => '액세스 토큰이 업데이트되었습니다';

  @override
  String get signInToUseChengeCore => 'ChengeCore를 사용하려면 로그인하세요';

  @override
  String get signInToUseRaising => '육성을 사용하려면 로그인하세요';

  @override
  String get enterToken => 'Token을 입력하세요';

  @override
  String get communityMerchant => '커뮤니티 판매자';

  @override
  String get product => '상품';

  @override
  String get productInitial => '상';

  @override
  String stockCount(int count) {
    return '재고 $count';
  }

  @override
  String soldCount(int count) {
    return '판매됨 $count';
  }

  @override
  String ratingReviews(String rating, int count) {
    return '$rating · 리뷰 $count개';
  }

  @override
  String get productDescription => '설명';

  @override
  String get purchasedContent => '구매한 콘텐츠';

  @override
  String get purchaseToViewContent => '전체 콘텐츠를 보려면 구매하세요';

  @override
  String get openOrDownloadFile => '파일 열기/다운로드';

  @override
  String balanceCc(String amount) {
    return '잔액 $amount CC';
  }

  @override
  String get buying => '구매 중…';

  @override
  String get buy => '구매';

  @override
  String get yourListedProduct => '내가 등록한 상품입니다';

  @override
  String get backToShop => '스토어로 돌아가기';

  @override
  String holdingQuantityType(Object quantity, String type) {
    return '보유 $quantity개 · $type';
  }

  @override
  String get orderPending => '결제 대기';

  @override
  String get orderPaid => '결제 완료';

  @override
  String get orderRefunded => '환불됨';

  @override
  String get statusUnknown => '알 수 없는 상태';

  @override
  String get conversationNotFound => '대화를 찾을 수 없습니다. 새로고침 후 다시 시도하세요';

  @override
  String get noMatchingConversations => '일치하는 대화가 없습니다';

  @override
  String get noConversationsYet => '아직 대화가 없습니다';

  @override
  String get goContactsToChat => '연락처로 이동하여 채팅을 시작하세요';

  @override
  String get friendInitial => '친';

  @override
  String get noMessagesYetShort => '아직 메시지가 없습니다';

  @override
  String previewEmoji(String key) {
    return '[이모티콘] $key';
  }

  @override
  String get previewSharedPost => '[공유 게시물]';

  @override
  String get previewOrder => '[상품 주문]';

  @override
  String get emojiMessage => '이모티콘 메시지';

  @override
  String get me => '나';

  @override
  String get sharedPost => '공유 게시물';

  @override
  String get productOrder => '상품 주문';

  @override
  String get cannotOpenPostMissingId => '게시물을 열 수 없음: 공유에 게시물 ID가 없습니다';

  @override
  String get cannotOpenProductMissingId => '상품을 열 수 없음: 공유에 상품 ID가 없습니다';

  @override
  String get chengeUser => 'Chenge 사용자';

  @override
  String get signInToPurchase => '구매하려면 로그인하세요';

  @override
  String get typeMessage => '메시지를 입력하세요…';

  @override
  String get sendMessage => '메시지 보내기';

  @override
  String get emoji => '이모티콘';

  @override
  String get previewEmojiOnly => '[이모티콘]';

  @override
  String get enterGroupNameKeyword => '그룹 이름 키워드 입력';

  @override
  String get enterUserSearchHint => '사용자 이름, 닉네임 또는 이메일 입력';

  @override
  String get friendAddedBack => '맞추가됨 — 이제 친구입니다';

  @override
  String get friendRequestSent => '친구 요청을 보냈습니다';

  @override
  String get rejectFriendRequest => '친구 요청 거절';

  @override
  String get removeFriend => '친구 삭제';

  @override
  String confirmRejectFriendRequest(String name) {
    return '$name님의 친구 요청을 거절하시겠습니까?';
  }

  @override
  String confirmRemoveFriend(String name) {
    return '$name님을 친구에서 삭제하시겠습니까?';
  }

  @override
  String get reject => '거절';

  @override
  String get remove => '삭제';

  @override
  String get friendRequestRejected => '친구 요청을 거절했습니다';

  @override
  String get friendRemoved => '친구를 삭제했습니다';

  @override
  String get remarkCleared => '메모가 지워졌습니다';

  @override
  String get remarkSaved => '메모가 저장되었습니다';

  @override
  String joinedGroup(String name) {
    return '「$name」에 가입했습니다';
  }

  @override
  String get enterGroupName => '그룹 이름을 입력하세요';

  @override
  String groupCreated(String name) {
    return '그룹 채팅 「$name」이(가) 생성되었습니다';
  }

  @override
  String get createGroupChat => '그룹 채팅 만들기';

  @override
  String get signInToManageContacts => '연락처를 관리하려면 로그인하세요';

  @override
  String get contactsSubtitle => '사용자 검색, 그룹 가입, 친구 요청 관리';

  @override
  String friendsTab(int count) {
    return '친구 $count';
  }

  @override
  String groupsTab(int count) {
    return '그룹 $count';
  }

  @override
  String requestsTab(int count) {
    return '요청 $count';
  }

  @override
  String get searchUsers => '사용자';

  @override
  String get searchGroups => '그룹';

  @override
  String get groupNameKeyword => '그룹 이름 키워드';

  @override
  String get userSearchHint => '사용자 이름, 닉네임 또는 이메일';

  @override
  String get searchGroupsTooltip => '그룹 검색';

  @override
  String get searchUsersTooltip => '사용자 검색';

  @override
  String get searchPublicGroups => '공개 그룹 검색';

  @override
  String get searchChengeUsers => 'ChengeWorld 사용자 검색';

  @override
  String get searchPublicGroupsHint => '그룹 이름을 입력하여 원하는 그룹에 가입하세요';

  @override
  String get searchUsersHint => '사용자 이름, 닉네임 또는 이메일 지원';

  @override
  String get noMatchingGroups => '일치하는 그룹이 없습니다';

  @override
  String get noMatchingPeople => '일치하는 사람이 없습니다';

  @override
  String get tryOtherKeywords => '다른 키워드를 시도해 보세요';

  @override
  String get noGroupsYet => '아직 그룹이 없습니다';

  @override
  String get noGroupsHint => '그룹을 만들거나 검색에서 공개 그룹에 가입하세요';

  @override
  String get noFriendsYet => '아직 친구가 없습니다';

  @override
  String get noFriendsHint => '사용자 이름이나 닉네임으로 검색하여 새로운 사람을 만나보세요';

  @override
  String get noPendingRequests => '대기 중인 요청이 없습니다';

  @override
  String get noPendingRequestsHint => '새 친구 요청이 여기에 표시됩니다';

  @override
  String get groupTapToJoin => '그룹 · 탭하여 가입';

  @override
  String get join => '가입';

  @override
  String get enterGroup => '그룹 들어가기';

  @override
  String requestAddYou(String username) {
    return '@$username · 친구 추가를 요청함';
  }

  @override
  String onlineWithRemark(String status, String remark, String username) {
    return '$status · 메모: $remark · @$username';
  }

  @override
  String get friend => '친구';

  @override
  String get addBack => '맞추가';

  @override
  String get requested => '요청됨';

  @override
  String get add => '추가';

  @override
  String get acceptAndAddBack => '수락 및 맞추가';

  @override
  String get rejectRequest => '요청 거절';

  @override
  String get friendActions => '친구 작업';

  @override
  String get sendMessageAction => '메시지';

  @override
  String get editRemark => '메모 편집';

  @override
  String get setRemark => '메모 설정';

  @override
  String get removeFriendRelation => '친구 삭제';

  @override
  String get setFriendRemark => '친구 메모 설정';

  @override
  String get remarkName => '메모 이름';

  @override
  String get remarkHintClear => '비워 두면 메모가 지워집니다';

  @override
  String get save => '저장';

  @override
  String get groupName => '그룹 이름';

  @override
  String get groupNameHint => '그룹에 이름을 지정하세요';

  @override
  String get selectMembersOptional => '멤버 선택(선택 사항)';

  @override
  String get create => '만들기';

  @override
  String get newConversation => '새 채팅';

  @override
  String get deleteSession => '대화 삭제';

  @override
  String confirmDeleteSession(String name) {
    return '「$name」을(를) 삭제하시겠습니까? 채팅 기록도 삭제됩니다.';
  }

  @override
  String get delete => '삭제';

  @override
  String get newChat => '새 채팅';

  @override
  String get refreshSessions => '대화 새로고침';

  @override
  String get signInToUseAiAgent => 'AI Agent를 사용하려면 로그인하세요';

  @override
  String get aiAgentSubtitle => '다중 세션, 스트리밍 답변 및 MCP 도구';

  @override
  String get selectOrCreateAiSession => 'AI 세션을 선택하거나 새로 만드세요';

  @override
  String get aiSessions => 'AI 세션';

  @override
  String get noAiChatsYet => '아직 AI 채팅이 없습니다';

  @override
  String get tapNewToStartChat => '아래의 새로 만들기를 눌러 채팅을 시작하세요';

  @override
  String get thinking => '생각 중…';

  @override
  String get aiRequestFailed => 'AI 요청 실패';

  @override
  String get noTextReply => '(텍스트 답변 없음)';

  @override
  String get waitingConfirm => '확인 대기 중…';

  @override
  String receivedType(String type) {
    return '$type 수신';
  }

  @override
  String get backToSessionList => '세션 목록으로 돌아가기';

  @override
  String get sendMessageToStart => '메시지를 보내 대화를 시작하세요';

  @override
  String get askAiAgent => 'AI Agent에게 질문…';

  @override
  String emojiPackTitle(Object id) {
    return '이모티콘 팩 $id';
  }

  @override
  String get noEmojiPacksBuyInShop => '아직 이모티콘 팩이 없습니다 — 스토어에서 구매하세요';

  @override
  String replyToUser(String name) {
    return '@$name에게 답글';
  }

  @override
  String get user => '사용자';

  @override
  String get anonymousUser => '익명';

  @override
  String get timeUnknown => '알 수 없는 시간';

  @override
  String dateYmd(int year, int month, int day) {
    return '$year년 $month월 $day일';
  }

  @override
  String get tasksInProgress => '진행 중';

  @override
  String get tasksNoInProgress => '진행 중인 작업이 없습니다';

  @override
  String get tasksCompletedSection => '완료됨';

  @override
  String get tasksRewardHint => '보상은 수동으로 수령해야 합니다 · 작업은 주기적으로 새로고침됩니다';

  @override
  String get tasksTodayGoal => '오늘의 목표';

  @override
  String get tasksTodayGoalSubtitle => '커뮤니티 작업을 완료하고 ChengeCoin을 받으세요';

  @override
  String tasksProgressSummary(int completed) {
    return '대기 중 · $completed개 완료';
  }

  @override
  String get taskClaimable => '수령 가능';

  @override
  String get taskCompletedBadge => '완료';

  @override
  String taskCheckinStreak(int streak, int totalDays) {
    return '$streak일 연속 출석 · 총 $totalDays일';
  }

  @override
  String get checkIn => '출석';

  @override
  String get claim => '수령';

  @override
  String get statusBarTopHideMask => '상단 바 숨김 시 상태 표시줄 마스크';

  @override
  String get statusBarTopHideMaskDescription =>
      '상단 바가 자동으로 숨겨질 수 있을 때 콘텐츠가 상태 표시줄 아래로 들어가지 않도록 반투명 테마 배경을 사용합니다(기본 켜짐)';

  @override
  String get siteAndToken => '사이트 및 토큰';

  @override
  String get officialSite => '공식 사이트';

  @override
  String webViewInitFailed(String errorType, String error) {
    return 'WebView 초기화 실패($errorType): $error\nWindows에는 Edge WebView2 Runtime이 필요합니다.';
  }

  @override
  String get registerAccount => '계정 만들기';

  @override
  String get registerTitle => 'ChengeWorld 가입';

  @override
  String get registerSuccess => '가입 성공. 로그인해 주세요.';

  @override
  String get nicknameOptional => '닉네임(선택 사항)';

  @override
  String get email => '이메일';

  @override
  String get enterEmail => '이메일 입력';

  @override
  String get invalidEmail => '이메일 형식이 올바르지 않습니다';

  @override
  String get emailCode => '이메일 인증 코드';

  @override
  String get enterEmailCode => '인증 코드 입력';

  @override
  String get getEmailCode => '코드 받기';

  @override
  String get sendingCode => '전송 중';

  @override
  String get emailCodeSent => '코드가 전송되었습니다(개발 환경에서는 백엔드 로그를 확인하세요)';

  @override
  String get fillEmailFirst => '먼저 이메일을 입력하세요';

  @override
  String get passwordMinSix => '비밀번호(최소 6자)';

  @override
  String get passwordTooShort => '비밀번호는 최소 6자 이상이어야 합니다';

  @override
  String get register => '가입';

  @override
  String get registering => '가입 중…';

  @override
  String get clearCache => '캐시 지우기';

  @override
  String get clearCacheDescription => '로그아웃하지 않고 로컬 이미지 캐시를 지웁니다';

  @override
  String get clearCacheConfirm => '로컬 캐시를 지우시겠습니까?';

  @override
  String get clearCacheDone => '캐시가 지워졌습니다';

  @override
  String get clearingCache => '지우는 중…';

  @override
  String get accessTokenCleared => '액세스 토큰이 지워졌습니다';

  @override
  String get createPost => '새 게시물';

  @override
  String get publishPost => '게시';

  @override
  String get postTitle => '제목';

  @override
  String get postContent => '내용(Markdown)';

  @override
  String get markdownHint => 'Markdown을 지원합니다. 이미지를 삽입할 수 있습니다.';

  @override
  String get insertImage => '이미지 삽입';

  @override
  String get coverImage => '커버 이미지';

  @override
  String get chooseCover => '커버 선택';

  @override
  String get removeCover => '커버 제거';

  @override
  String get category => '카테고리';

  @override
  String get selectCategoryHint => '카테고리를 선택하세요';

  @override
  String get noCategories => '사용 가능한 카테고리가 없습니다';

  @override
  String get titleRequired => '제목을 입력하세요';

  @override
  String get contentRequired => '내용을 입력하세요';

  @override
  String get postPublished => '게시물이 게시되었습니다';

  @override
  String get signInToCreatePost => '게시물을 작성하려면 로그인하세요';

  @override
  String get tagsOptional => '태그(선택 사항)';

  @override
  String get tagsHint => '쉼표 또는 공백으로 구분';

  @override
  String get saveDraft => '임시 저장';

  @override
  String get draftSaved => '임시 저장되었습니다';

  @override
  String draftAutoSaved(String time) {
    return '$time에 임시 저장되었습니다';
  }

  @override
  String get restoreDraftTitle => '임시 저장 복원?';

  @override
  String get restoreDraftMessage => '게시되지 않은 임시 저장이 있습니다. 복원하시겠습니까?';

  @override
  String get restoreDraft => '복원';

  @override
  String get discardDraft => '버리기';

  @override
  String get hotTags => '인기 태그';

  @override
  String get attachmentUrls => '첨부 파일 URL';

  @override
  String get attachmentUrlsHint => '모든 첨부 파일 URL; Bilibili 동영상 링크도 지원';

  @override
  String get attachmentUrlHint => 'https://…';

  @override
  String get addAttachmentUrl => '첨부 URL 추가';

  @override
  String get removeAttachment => '첨부 제거';

  @override
  String maxImagesReached(int count) {
    return '이미지는 최대 $count장까지 가능합니다';
  }

  @override
  String get articleImages => '글 이미지';

  @override
  String get articleImagesHint =>
      '글 갤러리에 최대 5장(Markdown 아님). 커버가 없으면 첫 번째 이미지가 커버로 사용됩니다.';

  @override
  String get deleteImage => '이미지 삭제';
}
