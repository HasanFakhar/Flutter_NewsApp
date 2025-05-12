import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';
import '../services/chatbot_service.dart';
import '../models/article_model.dart';
import '../models/slider_model.dart';
import '../models/show_category.dart';

class ChatScreen extends StatefulWidget {
  final String apiKey;
  final List<ArticleModel> articles;
  final List<SliderModel> sliders;
  final List<ShowModel> categoryArticles;

  const ChatScreen({
    Key? key, 
    required this.apiKey,
    this.articles = const [],
    this.sliders = const [],
    this.categoryArticles = const [],
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _user = const types.User(id: 'user');
  final _uuid = const Uuid();
  late final ChatbotService _chatbotService;
  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _chatbotService = ChatbotService(apiKey: widget.apiKey);
    _updateNewsContext();
    _addMessage(
      types.TextMessage(
        author: const types.User(id: 'bot'),
        id: _uuid.v4(),
        text: 'Hello! I\'m your news assistant. I have access to the latest news articles and can help you find information about them. How can I help you today?',
      ),
    );
  }

  void _updateNewsContext() {
    _chatbotService.updateArticles(widget.articles);
    _chatbotService.updateSliders(widget.sliders);
    _chatbotService.updateCategoryArticles(widget.categoryArticles);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      id: _uuid.v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    _chatbotService.getResponse(message.text).then((response) {
      _addMessage(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Assistant'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        showUserAvatars: true,
        showUserNames: true,
        user: _user,
      ),
    );
  }
} 