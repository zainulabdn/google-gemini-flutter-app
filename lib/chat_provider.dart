import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:io';
import 'chat.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> chats = [];
  bool isLoading = false;
  bool isError = false;

  void _setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error) {
    isError = error;
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    final gemini = Gemini.instance;
    chats.add(Chat(msg: message, isRequest: true));
    _setLoading(true);

    try {
      final response = await gemini.text(message);
      chats.add(Chat(msg: response!.output.toString(), isRequest: false));
    } catch (e) {
      print(e);
      _setError(true);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendWithImage(String message, File img) async {
    final gemini = Gemini.instance;
    chats.add(Chat(msg: message, isRequest: true, img: img));
    _setLoading(true);

    try {
      final uintList = await img.readAsBytes();
      final response =
          await gemini.textAndImage(text: message, images: [uintList]);
      chats.add(Chat(msg: response!.output.toString(), isRequest: false));
    } catch (e) {
      print(e);
      _setError(true);
    } finally {
      _setLoading(false);
    }
  }
}
