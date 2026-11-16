import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/message_model.dart';
import '../models/profile_model.dart';

class Conversation {
  final String id;
  final String participantId;
  final String name;
  final String imageUrl;
  final List<MessageModel> messages;
  final bool isTyping;
  final bool isOnline;

  const Conversation({
    required this.id,
    required this.participantId,
    required this.name,
    required this.imageUrl,
    required this.messages,
    this.isTyping = false,
    this.isOnline = true,
  });

  String get lastMessage {
    if (isTyping) return 'typing...';
    return messages.isNotEmpty ? messages.last.text : 'Say hi!';
  }

  DateTime get lastTime => messages.isNotEmpty
      ? messages.last.sentAt
      : DateTime.fromMillisecondsSinceEpoch(0);

  Conversation copyWith({
    List<MessageModel>? messages,
    bool? isTyping,
    bool? isOnline,
  }) => Conversation(
    id: id,
    participantId: participantId,
    name: name,
    imageUrl: imageUrl,
    messages: messages ?? this.messages,
    isTyping: isTyping ?? this.isTyping,
    isOnline: isOnline ?? this.isOnline,
  );
}

class ChatProvider extends ChangeNotifier {
  final Map<String, Conversation> _conversations = {};
  final _rand = Random();
  int _msgSeq = 0;

  ChatProvider() {
    _seed();
  }

  void _seed() {
    _ensureSeed(
      'p1',
      'Maya',
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      [
        _msg('p1', 'Hey! How was your day?', false, minutesAgo: 30),
        _msg(
          'p1',
          'Pretty good! Working on a new project.',
          true,
          minutesAgo: 20,
        ),
        _msg(
          'p1',
          'That sounds exciting! Tell me more about it.',
          false,
          minutesAgo: 12,
        ),
      ],
    );
    _ensureSeed(
      'p2',
      'Rafi',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
      [
        _msg('p2', 'That photo spot looks amazing!', false, minutesAgo: 120),
        _msg(
          'p2',
          'Thanks! Found it during a weekend trip.',
          true,
          minutesAgo: 110,
        ),
      ],
    );
  }

  void _ensureSeed(
    String id,
    String name,
    String img,
    List<MessageModel> msgs,
  ) {
    _conversations[id] = Conversation(
      id: id,
      participantId: id,
      name: name,
      imageUrl: img,
      messages: msgs,
      isOnline: id == 'p1',
    );
  }

  MessageModel _msg(
    String chatId,
    String text,
    bool mine, {
    int minutesAgo = 0,
  }) {
    return MessageModel(
      id: 'm${_msgSeq++}',
      chatId: chatId,
      senderId: mine ? 'me' : chatId,
      text: text,
      sentAt: DateTime.now().subtract(Duration(minutes: minutesAgo)),
      isMine: mine,
    );
  }

  List<Conversation> get conversations {
    final list = _conversations.values.toList();
    list.sort((a, b) => b.lastTime.compareTo(a.lastTime));
    return list;
  }

  Conversation? conversationById(String id) => _conversations[id];

  String ensureConversationForProfile(ProfileModel profile) {
    if (_conversations.containsKey(profile.id)) return profile.id;
    _conversations[profile.id] = Conversation(
      id: profile.id,
      participantId: profile.id,
      name: profile.name,
      imageUrl: profile.imageUrl,
      messages: [
        _msg(
          profile.id,
          'You matched with ${profile.name}. Say hi! 👋',
          false,
          minutesAgo: 0,
        ),
      ],
      isOnline: _rand.nextBool(),
    );
    notifyListeners();
    return profile.id;
  }

  void sendMessage(String chatId, String text) {
    final convo = _conversations[chatId];
    if (convo == null) return;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final mine = MessageModel(
      id: 'm${_msgSeq++}',
      chatId: chatId,
      senderId: 'me',
      text: trimmed,
      sentAt: DateTime.now(),
      isMine: true,
    );
    _conversations[chatId] = convo.copyWith(
      messages: [...convo.messages, mine],
    );
    notifyListeners();

    _simulateReply(chatId, trimmed);
  }

  void _simulateReply(String chatId, String incoming) {
    final convo = _conversations[chatId];
    if (convo == null) return;

    // show typing after a short delay, then reply
    final typingDelay = 700 + _rand.nextInt(900);
    final replyDelay = typingDelay + 1200 + _rand.nextInt(1800);

    Timer(Duration(milliseconds: typingDelay), () {
      final current = _conversations[chatId];
      if (current == null) return;
      _conversations[chatId] = current.copyWith(isTyping: true, isOnline: true);
      notifyListeners();
    });

    Timer(Duration(milliseconds: replyDelay), () {
      final current = _conversations[chatId];
      if (current == null) return;
      final reply = MessageModel(
        id: 'm${_msgSeq++}',
        chatId: chatId,
        senderId: chatId,
        text: _autoReply(incoming, current.name),
        sentAt: DateTime.now(),
        isMine: false,
      );
      _conversations[chatId] = current.copyWith(
        isTyping: false,
        messages: [...current.messages, reply],
      );
      notifyListeners();
    });
  }

  String _autoReply(String incoming, String name) {
    final lower = incoming.toLowerCase();
    if (lower.contains('hi') ||
        lower.contains('hello') ||
        lower.contains('hey') ||
        lower.contains('hlw')) {
      final options = [
        'Hey! So nice to hear from you 😊',
        'Hi there! How’s your day going?',
        'Hey hey! I was hoping you’d message.',
      ];
      return options[_rand.nextInt(options.length)];
    }
    if (lower.contains('kemon') ||
        lower.contains('how are') ||
        lower.contains('how r')) {
      final options = [
        'I’m doing great! What about you?',
        'Pretty good actually 😄 what’s up with you?',
        'All good here! Tell me about your day.',
      ];
      return options[_rand.nextInt(options.length)];
    }
    if (lower.contains('name') || lower.contains('nam ki')) {
      return 'I’m $name. Nice to meet you!';
    }
    if (lower.contains('photo') ||
        lower.contains('pic') ||
        lower.contains('chobi')) {
      return 'Haha maybe later 😄 tell me something interesting about you first.';
    }
    if (lower.contains('?')) {
      final options = [
        'Good question! I think it depends — what do you feel?',
        'Hmm, interesting! I’d love to hear your take on it.',
        'Let me think… what made you ask that?',
      ];
      return options[_rand.nextInt(options.length)];
    }
    final options = [
      'That sounds really nice! Tell me more.',
      'Oh wow, I like that. What else do you enjoy?',
      'That’s cool 😄 I’d love to know more about you.',
      'Aww that’s sweet. What do you usually do for fun?',
      'Nice! We should chat more about this.',
    ];
    return options[_rand.nextInt(options.length)];
  }

  String timeLabel(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return 'Yesterday';
    return '${time.day}/${time.month}';
  }

  String messageTime(DateTime time) {
    final h = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final m = time.minute.toString().padLeft(2, '0');
    final ampm = time.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}
