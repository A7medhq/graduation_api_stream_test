import 'dart:convert';

import '../models/ChatMsgModel.dart';
import '../models/ListChatModel.dart';
import '../prefs/prefs.dart';
import 'package:http/http.dart' as http;

class chatApiController {
  Future<List<ListChatModel>> getListChat() async {
    String token = SharedPrefController().getValueFor('token');
    Uri uri =
        Uri.parse('http://ac7a1ae098-001-site1.etempurl.com/chat/GetListChat');
    http.Response response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': token,
    });
    // print('chaattttt${response.body}');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var DecodedData = data['data'] as List;
      List<ListChatModel> chatList =
          DecodedData.map((obj) => ListChatModel.fromJson(obj)).toList();
      return chatList;
    }
    return [];
  }

  Future<void> SendMsg({required String id, required String msg}) async {
    Uri uri =
        Uri.parse('http://ac7a1ae098-001-site1.etempurl.com/chat/sendmessage');
    String token = SharedPrefController().getValueFor('token');

    http.Response response = await http.post(uri, body: {
      'ReceiverUserId': id,
      'Message': msg
    }, headers: {
      'Accept': 'application/json',
      'Authorization': token,
    });

    if (response.statusCode == 200 || response.statusCode == 400) {
      var json = jsonDecode(response.body);
      print('json msg is $json');
    }
  }

  Future<List<ChatMsgModel>> GetChatMassage({required String id}) async {
    String token = SharedPrefController().getValueFor('token');
    // String id = SharedPrefController().getValueFor('id');
    Uri uri = Uri.parse(
        'http://ac7a1ae098-001-site1.etempurl.com/chat/GetChatMassage?uId=$id');
    http.Response response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': token,
    });
    print('GetChatMassage${response.body}');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var DecodedData = data['data'] as List;
      List<ChatMsgModel> chatList =
          DecodedData.map((obj) => ChatMsgModel.fromJson(obj)).toList();
      return chatList;
    }
    return [];
  }
}
