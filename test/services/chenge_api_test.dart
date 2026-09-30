import 'dart:convert';

import 'package:chenge_world_app/models/shop_item.dart';
import 'package:chenge_world_app/services/chenge_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('requests the server pagination contract and parses records', () async {
    http.Request? captured;
    final client = MockClient((request) async {
      captured = request;
      return http.Response(
        jsonEncode({
          'code': 200,
          'msg': 'success',
          'data': {
            'records': [
              {
                'id': 56,
                'title': '服务端帖子',
                'summary': '帖子摘要',
                'content': '正文',
                'authorName': '社区用户',
                'viewCount': 4,
                'likeCount': 2,
                'commentCount': 1,
              },
            ],
            'total': 21,
            'pages': 2,
            'pageNum': 2,
            'pageSize': 12,
          },
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    final api = ChengeApi(client: client, baseUrl: 'http://example.test/');

    final page = await api.listPosts(page: 2, sort: 'hot', keyword: 'Flutter', token: 'session-token');

    expect(captured!.url.path, '/blog/post/list');
    expect(captured!.url.queryParameters, {
      'pageNum': '2',
      'pageSize': '12',
      'sort': 'hot',
      'keyword': 'Flutter',
    });
    expect(captured!.headers['Authorization'], 'Bearer session-token');
    expect(page.total, 21);
    expect(page.pages, 2);
    expect(page.posts.single.title, '服务端帖子');
  });

  test('sends username and password to the login endpoint', () async {
    http.Request? captured;
    final client = MockClient((request) async {
      captured = request;
      return http.Response(
        jsonEncode({'code': 200, 'data': {'token': 'signed-token', 'user': {'username': 'lan'}}}),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    final api = ChengeApi(client: client, baseUrl: 'http://example.test');

    final result = await api.login('lan', 'secret');

    expect(captured!.url.path, '/home/login');
    expect(jsonDecode(captured!.body), {'username': 'lan', 'password': 'secret'});
    expect(result['token'], 'signed-token');
  });

  test('searches friends with the session token', () async {
    http.Request? captured;
    final client = MockClient((request) async {
      captured = request;
      return http.Response(
        jsonEncode({
          'code': 200,
          'data': [
            {
              'userId': 42,
              'username': 'chenge-user',
              'nickname': '社区朋友',
              'mutual': false,
              'iReceived': true,
            },
          ],
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    final api = ChengeApi(client: client, baseUrl: 'http://example.test');

    final users = await api.searchUsers(' 社区 ', 'session-token');

    expect(captured!.url.path, '/friend/search');
    expect(captured!.url.queryParameters, {'keyword': '社区'});
    expect(captured!.headers['Authorization'], 'Bearer session-token');
    expect(users.single.userId, 42);
    expect(users.single.displayName, '社区朋友');
    expect(users.single.iReceived, isTrue);
  });

  test('accepting and rejecting requests use the server relationship semantics', () async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(jsonEncode({'code': 200, 'data': 'ok'}), 200);
    });
    final api = ChengeApi(client: client, baseUrl: 'http://example.test');

    await api.applyFriend(42, 'session-token');
    await api.removeFriend(42, 'session-token');

    expect(requests[0].method, 'POST');
    expect(requests[0].url.path, '/friend/apply');
    expect(requests[0].url.queryParameters, {'friendId': '42'});
    expect(requests[1].method, 'DELETE');
    expect(requests[1].url.path, '/friend/42');
  });

  test('opens a private conversation with the selected friend', () async {
    http.Request? captured;
    final client = MockClient((request) async {
      captured = request;
      return http.Response(
        jsonEncode({'code': 200, 'data': {'id': 18, 'type': 'single'}}),
        200,
      );
    });
    final api = ChengeApi(client: client, baseUrl: 'http://example.test');

    final conversation = await api.openSingleChat(42, 'session-token');

    expect(captured!.url.path, '/chat/single');
    expect(captured!.url.queryParameters, {'peerId': '42'});
    expect(captured!.headers['Authorization'], 'Bearer session-token');
    expect(conversation.id, 18);
    expect(conversation.peerId, 42);
  });

  test('parses shop prices in cents and buys an item', () async {
    http.Request? captured;
    final client = MockClient((request) async {
      captured = request;
      return http.Response(jsonEncode({'code': 200, 'data': {'orderId': 93, 'quantity': 2}}), 200);
    });
    final api = ChengeApi(client: client, baseUrl: 'http://example.test');

    final item = ShopItem.fromJson({'id': 4, 'title': '头像框', 'type': 'file', 'price': 1250, 'stock': 3});
    final purchase = await api.buyShopItem(4, 2, 'session-token');

    expect(item.priceCoins, 12.5);
    expect(captured!.url.path, '/shop/buy');
    expect(captured!.headers['Authorization'], 'Bearer session-token');
    expect(jsonDecode(captured!.body), {'itemId': 4, 'quantity': 2});
    expect(purchase['orderId'], 93);
  });

  test('loads shop items with server filters and pagination metadata', () async {
    http.Request? captured;
    final client = MockClient((request) async {
      captured = request;
      return http.Response(
        jsonEncode({
          'code': 200,
          'data': {
            'records': [
              {'id': 5, 'title': '社区图标', 'type': 'file', 'price': 300, 'stock': 4},
            ],
            'total': 37,
          },
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    final api = ChengeApi(client: client, baseUrl: 'http://example.test');

    final page = await api.shopItems(page: 2, type: 'file', keyword: '图标', sort: 'price_asc');

    expect(captured!.url.path, '/shop/items');
    expect(captured!.url.queryParameters, {
      'pageNum': '2',
      'pageSize': '12',
      'sort': 'price_asc',
      'type': 'file',
      'keyword': '图标',
    });
    expect(page.total, 37);
    expect(page.items.single.priceCoins, 3);
  });

  test('sends a chat message with an idempotency key', () async {
    http.Request? captured;
    final client = MockClient((request) async {
      captured = request;
      return http.Response(
        jsonEncode({
          'code': 200,
          'data': {'id': 27, 'conversationId': 18, 'senderId': 7, 'type': 'text', 'content': '你好'},
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    final api = ChengeApi(client: client, baseUrl: 'http://example.test');

    final message = await api.sendChatMessage(18, '你好', 'session-token');
    final body = jsonDecode(captured!.body) as Map<String, dynamic>;

    expect(captured!.url.path, '/chat/18/send');
    expect(captured!.headers['Authorization'], 'Bearer session-token');
    expect(body['type'], 'text');
    expect(body['content'], '你好');
    expect(body['clientMsgId'], startsWith('android-'));
    expect(message.id, 27);
  });

  test('loads task progress and claims a task with the session token', () async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      if (request.url.path == '/task/list') {
        return http.Response(
          jsonEncode({
            'code': 200,
            'data': [
              {
                'code': 'daily_checkin',
                'name': '每日签到',
                'type': 'checkin',
                'progress': 0,
                'target': 1,
                'rewardCoins': 1.5,
                'claimable': true,
                'rewarded': false,
                'streak': 3,
              },
            ],
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }
      return http.Response(
        jsonEncode({'code': 200, 'data': {'code': 'daily_checkin', 'coins': 1.5}}),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    final api = ChengeApi(client: client, baseUrl: 'http://example.test');

    final tasks = await api.tasks(token: 'session-token');
    final reward = await api.claimTask('daily_checkin', 'session-token');

    expect(requests[0].url.path, '/task/list');
    expect(tasks.single.progressRatio, 0);
    expect(tasks.single.streak, 3);
    expect(requests[1].url.path, '/task/claim');
    expect(requests[1].headers['Authorization'], 'Bearer session-token');
    expect(jsonDecode(requests[1].body), {'code': 'daily_checkin'});
    expect(reward['coins'], 1.5);
  });
}