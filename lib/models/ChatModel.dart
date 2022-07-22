import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../utils/Utils.dart';

part 'ChatModel.g.dart';

@HiveType(typeId: 55)
class ChatModel extends HiveObject {
  static Future<void> save_to_local_db(
    List<ChatModel> data,
    bool clear_db,
    bool is_threads,
  ) async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = null;
    if (!Hive.isBoxOpen("ChatModel")) {
      box = await Hive.openBox<ChatModel>("ChatModel");
    }
    if (box == null) {
      box = await Hive.openBox<ChatModel>("ChatModel");
    }
    if (box == null) {
      return;
    }

    if (clear_db) {
      await box.clear();
    }

    List<ChatModel> current_data = [];
    List<int> thread_ids = [];
    data.forEach((element) {
      thread_ids.add(element.id);
    });
    current_data = await ChatModel.get_local_items();

    for (int x = 0; x < current_data.length; x++) {
      if (thread_ids.contains(current_data[x].id)) {
        await current_data[x].delete();
      } else {
        if (is_threads) {
          current_data[x].file == "0";
          await current_data[x].save();
        }
      }
    }

    //box.addAll(data);

    for (int y = 0; y < data.length; y++) {
      if (is_threads) {
        data[y].file == "1";
      } else {
        data[y].file == "0";
      }
      await box.add(data[y]);
    }

    return;
  }

  static Future<List<ChatModel>> get_items(int user_id,
      {String thread_id: ""}) async {
    List<ChatModel> items = [];
    get_threads(user_id);

    (await get_local_items()).forEach((element) {
      if (thread_id.isEmpty) {
        if (element.file == "1") {
          items.add(element);
        }
      } else {
        if (thread_id == element.thread) {
          items.add(element);
        }
      }
    });

    return items;
  }

  static Future<List<ChatModel>> get_local_items() async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<ChatModel>("ChatModel");
    if (box.values.isEmpty) {
      return [];
    }

    List<ChatModel> items = [];
    box.values.forEach((element) {
      items.add(element);
    });

    return items;
  }

  Future<void> send_this_message(BuildContext _context) async {
    if (!(await Utils.is_connected())) {
      Utils.showSnackBar(
          "Failed to send message because of poor internet connection.",
          _context,
          Colors.white,
          background_color: Colors.red);
      return;
    }

    String resp = await Utils.http_post('api/chats', {
      'sender': sender,
      'receiver': receiver,
      'product_id': product_id,
      'body': body,
    });

    if (resp == null && resp.isEmpty) {
      Utils.showSnackBar("Failed to send message.", _context, Colors.white,
          background_color: Colors.red);
      return;
    }
    Map<String, dynamic> _resp = jsonDecode(resp);

    if (_resp['status'] == 0) {
      Utils.showSnackBar("Failed to send message because ${_resp['message']}.",
          _context, Colors.white,
          background_color: Colors.red);
    }
  }

  static Future<List<ChatModel>> get_local_chats(
      String thread_id, int user_id) async {
    if ((await Utils.is_connected())) {
      get_online_chats(thread_id, user_id);
    }

    List<ChatModel> items = await ChatModel.get_local_items();
    if (items.isEmpty) {
      if ((await Utils.is_connected())) {
        return [];
      }
      await get_online_chats(thread_id, user_id);
      items = await ChatModel.get_local_items();
    }

    List<ChatModel> _items = [];
    items.forEach((element) {
      if (thread_id == element.thread) {
        _items.add(element);
      }
    });
    _items.sort((a, b) => a.id.compareTo(b.id));
    return _items;
  }

  static Future<List<ChatModel>> get_threads(int user_id) async {
    if ((await Utils.is_connected())) {
      get_online_threads(user_id);
    }
    List<ChatModel> items = await ChatModel.get_local_items();
    if (items.isEmpty) {
      await get_online_threads(user_id);
      items = await ChatModel.get_local_items();
    }

    List<ChatModel> _items = [];
    items.forEach((element) {
      if (element.file == "1") {
        _items.add(element);
      }
    });
    _items.sort((b, a) => a.id.compareTo(b.id));
    return _items;
  }

  static Future<List<ChatModel>> get_online_threads(int user_id) async {
    if (!(await Utils.is_connected())) {
      return [];
    }
    List<ChatModel> items = [];

    String resp = await Utils.http_post('api/threads', {'user_id': user_id});

    if (resp != null && !resp.isEmpty) {
      json.decode(resp).map((element) {
        ChatModel item = new ChatModel();
        item = ChatModel.fromJson(element);
        item.file == "1";
        items.add(item);
      }).toList();
    }
    await ChatModel.save_to_local_db(items, false, true);

    return items;
  }

  static Future<List<ChatModel>> get_online_chats(String thread, int user_id,
      {String unread: "0"}) async {
    if (!(await Utils.is_connected())) {
      return [];
    }
    List<ChatModel> items = [];

    String resp = await Utils.http_post('api/get-chats',
        {'thread': thread, 'user_id': "$user_id", unread: unread});

    if (resp != null && !resp.isEmpty) {
      json.decode(resp).map((element) {
        ChatModel item = new ChatModel();
        item = ChatModel.fromJson(element);
        item.file == "0";
        items.add(item);
      }).toList();
    }
    await ChatModel.save_to_local_db(items, false, false);

    return items;
  }

  @HiveField(0)
  int id = 0;

  @HiveField(1)
  String created_at = "";

  @HiveField(2)
  String body = "";

  @HiveField(3)
  String sender = "";

  @HiveField(4)
  String receiver = "";

  @HiveField(5)
  String product_id = "";

  @HiveField(6)
  String thread = "";

  @HiveField(7)
  bool received = false;

  @HiveField(8)
  bool seen = false;

  @HiveField(9)
  String type = "";

  @HiveField(10)
  String receiver_pic = "";

  @HiveField(11)
  String contact = "";

  @HiveField(12)
  String gps = "";

  @HiveField(13)
  String file = "";

  @HiveField(14)
  String image = "";

  @HiveField(15)
  String audio = "";

  @HiveField(16)
  String receiver_name = "";

  @HiveField(17)
  String sender_name = "";

  @HiveField(18)
  String product_name = "";

  @HiveField(19)
  String product_pic = "";

  @HiveField(20)
  int unread_count = 0;

  @HiveField(21)
  String sender_pic = "";

  static ChatModel fromJson(data) {
    ChatModel u = new ChatModel();
    u.id = 0;
    if (data['id'] != null) {
      if (!data['id'].toString().toString().isEmpty) {
        try {
          u.id = int.parse(data['id'].toString());
        } catch (e) {
          u.id = 0;
        }
      }
    }

    u.created_at = data['created_at'].toString();
    u.body = data['body'].toString();
    u.sender = data['sender'].toString();
    u.receiver = data['receiver'].toString();
    u.product_id = data['product_id'].toString();
    u.thread = data['thread'].toString();
    u.received = Utils.bool_parse(data['received'].toString());
    u.seen = Utils.bool_parse(data['seen'].toString());
    u.type = data['type'];
    u.receiver_pic = data['receiver_pic'];
    u.sender_pic = data['sender_pic'];
    u.contact = data['contact'];
    u.gps = data['gps'];
    u.file = data['file'];
    u.image = data['image'];
    u.audio = data['audio'];
    u.receiver_name = data['receiver_name'];
    u.sender_name = data['sender_name'];
    u.product_name = data['product_name'];
    u.product_pic = data['product_pic'];
    u.unread_count = data['unread_count'];

    return u;
  }
}
