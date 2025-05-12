import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import '../models/article_model.dart';
import '../models/slider_model.dart';
import '../models/show_category.dart';
import 'dart:developer' as developer;

class ChatbotService {
  final GenerativeModel _model;
  final _uuid = const Uuid();
  List<ArticleModel> _articles = [];
  List<SliderModel> _sliders = [];
  List<ShowModel> _categoryArticles = [];
  final List<Content> _chatHistory = [];


  ChatbotService({required String apiKey}) 
      : _model = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: apiKey,
        );

  void updateArticles(List<ArticleModel> articles) {
    _articles = articles;
  }

  void updateSliders(List<SliderModel> sliders) {
    _sliders = sliders;
  }

  void updateCategoryArticles(List<ShowModel> categoryArticles) {
    _categoryArticles = categoryArticles;
  }

  String _getNewsContext() {
    String context = "Here are the current news articles I have access to:\n\n";
    
    if (_sliders.isNotEmpty) {
      context += "Breaking News:\n";
      for (var slider in _sliders) {
        context += "- ${slider.title}\n";
        if (slider.description != null) {
          context += "  ${slider.description}\n";
        }
      }
      context += "\n";
    }

    if (_articles.isNotEmpty) {
      context += "Trending News:\n";
      for (var article in _articles) {
        context += "- ${article.title}\n";
        if (article.description != null) {
          context += "  ${article.description}\n";
        }
      }
      context += "\n";
    }

    if (_categoryArticles.isNotEmpty) {
      context += "Category News:\n";
      for (var article in _categoryArticles) {
        context += "- ${article.title}\n";
        if (article.description != null) {
          context += "  ${article.description}\n";
        }
      }
    }

    return context;
  }

  Future<types.TextMessage> getResponse(String message) async {
    try {
      final newsContext = _getNewsContext();
      developer.log('News Context: $newsContext', name: 'ChatbotService');
      
      // Add system message to chat history if it's empty
      if (_chatHistory.isEmpty) {
        final systemMessage = '''You are a helpful news assistant. You can help users find news articles, explain current events, and provide information about various topics. Keep your responses concise and informative.

Current News Context:
$newsContext

Use this context to provide more relevant and specific answers about the news articles available.''';
        
        developer.log('Adding system message to chat history', name: 'ChatbotService');
        _chatHistory.add(Content.text(systemMessage));
      }

      // Add user message to chat history
      developer.log('Adding user message: $message', name: 'ChatbotService');
      _chatHistory.add(Content.text(message));

      // Generate response
      developer.log('Generating response from Gemini...', name: 'ChatbotService');
      final response = await _model.generateContent(_chatHistory);
      
      // Log the response
      developer.log('Gemini Response: ${response.text}', name: 'ChatbotService');
      
      // Add assistant's response to chat history
      if (response.text != null) {
        _chatHistory.add(Content.text(response.text!));
      } else {
        developer.log('Warning: Gemini returned null response', name: 'ChatbotService');
      }

      return types.TextMessage(
        author: const types.User(id: 'bot'),
        id: _uuid.v4(),
        text: response.text ?? 'Sorry, I couldn\'t generate a response. Please try again.',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error in ChatbotService.getResponse',
        name: 'ChatbotService',
        error: e,
        stackTrace: stackTrace,
      );
      return types.TextMessage(
        author: const types.User(id: 'bot'),
        id: _uuid.v4(),
        text: 'Sorry, I encountered an error: ${e.toString()}. Please try again later.',
      );
    }
  }
} 