import 'package:chenge_world_app/models/chat_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses the server emoji message payload', () {
    final message = ChatMessage.fromJson({
      'id': 9,
      'conversationId': 3,
      'senderId': 7,
      'type': 'emoji',
      'content': '{"itemId":185,"key":"TSQ","fileId":984,"url":"https://example.test/emoji.png"}',
    });

    expect(message.emoji?.itemId, 185);
    expect(message.emoji?.key, 'TSQ');
    expect(message.emoji?.fileId, 984);
    expect(message.emoji?.url, 'https://example.test/emoji.png');
  });

  test('handles invalid emoji content without throwing', () {
    expect(EmojiMessageContent.tryParse('not-json'), isNull);
  });
}