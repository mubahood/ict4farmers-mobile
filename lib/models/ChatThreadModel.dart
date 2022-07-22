import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../utils/Utils.dart';

part 'ChatThreadModel.g.dart';

@HiveType(typeId: 59)
class ChatThreadModel extends HiveObject {
  static Future<void> save_to_local_db(
    List<ChatThreadModel> data,
    bool clear_db,
    bool is_threads,
  ) async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = null;
    if (!Hive.isBoxOpen("ChatThreadModel")) {
      box = await Hive.openBox<ChatThreadModel>("ChatThreadModel");
    }
    if (box == null) {
      box = await Hive.openBox<ChatThreadModel>("ChatThreadModel");
    }
    if (box == null) {
      return;
    }

    if (clear_db) {
      await box.clear();
    }

    List<ChatThreadModel> current_data = [];
    List<int> thread_ids = [];
    data.forEach((element) {
      thread_ids.add(element.id);
    });
    current_data = await ChatThreadModel.get_local_items();

    for (int x = 0; x < current_data.length; x++) {
      if (thread_ids.contains(current_data[x].id)) {
        await current_data[x].delete();
      } else {
        if (is_threads) {
          current_data[x].file == "1";
          await current_data[x].save();
        }
      }
    }

    //box.addAll(data);

    for (int y = 0; y < data.length; y++) {
      if (is_threads) {
        data[y].file == "1";
      } else {
        data[y].file == "1";
      }
      await box.add(data[y]);
    }

    return;
  }

  static Future<List<ChatThreadModel>> get_items(int user_id,
      {String thread_id: ""}) async {
    List<ChatThreadModel> items = [];
    get_threads(user_id);

    (await get_local_items()).forEach((element) {
      items.add(element);
    });

    return items;
  }

  static Future<List<ChatThreadModel>> get_local_items() async {
    Utils.init_databse();
    await Hive.initFlutter();
    var box = await Hive.openBox<ChatThreadModel>("ChatThreadModel");
    if (box.values.isEmpty) {
      return [];
    }

    List<ChatThreadModel> items = [];
    box.values.forEach((element) {
      items.add(element);
    });

    return items;
  }

  static Future<List<ChatThreadModel>> get_local_chats(
      String thread_id, int user_id) async {
    if ((await Utils.is_connected())) {
      get_online_chats(thread_id, user_id);
    }

    List<ChatThreadModel> items = await ChatThreadModel.get_local_items();
    if (items.isEmpty) {
      if ((await Utils.is_connected())) {
        return [];
      }
      await get_online_chats(thread_id, user_id);
      items = await ChatThreadModel.get_local_items();
    }

    List<ChatThreadModel> _items = [];
    items.forEach((element) {
      if (thread_id == element.thread) {
        _items.add(element);
      }
    });
    _items.sort((a, b) => a.id.compareTo(b.id));
    return _items;
  }

  static Future<List<ChatThreadModel>> get_threads(int user_id) async {
    if ((await Utils.is_connected())) {
      get_online_threads(user_id);
    }
    List<ChatThreadModel> items = await ChatThreadModel.get_local_items();
    if (items.isEmpty) {
      await get_online_threads(user_id);
      items = await ChatThreadModel.get_local_items();
    }

    List<ChatThreadModel> _items = [];
    items.forEach((element) {
      _items.add(element);
    });
    _items.sort((b, a) => a.id.compareTo(b.id));
    return _items;
  }

  static Future<List<ChatThreadModel>> get_online_threads(int user_id) async {
    if (!(await Utils.is_connected())) {
      return [];
    }
    List<ChatThreadModel> items = [];

    String resp = await Utils.http_post('api/threads', {'user_id': user_id});

    if (resp != null && !resp.isEmpty) {
      json.decode(resp).map((element) {
        ChatThreadModel item = new ChatThreadModel();
        item = ChatThreadModel.fromJson(element);
        item.file == "1";
        items.add(item);
      }).toList();
    }
    await ChatThreadModel.save_to_local_db(items, false, true);

    return items;
  }

  static Future<List<ChatThreadModel>> get_online_chats(
      String thread, int user_id,
      {String unread: "0"}) async {
    if (!(await Utils.is_connected())) {
      return [];
    }
    List<ChatThreadModel> items = [];

    String resp = await Utils.http_post('api/get-chats',
        {'thread': thread, 'user_id': "$user_id", unread: unread});

    if (resp != null && !resp.isEmpty) {
      json.decode(resp).map((element) {
        ChatThreadModel item = new ChatThreadModel();
        item = ChatThreadModel.fromJson(element);
        item.file == "1";
        items.add(item);
      }).toList();
    }
    await ChatThreadModel.save_to_local_db(items, false, false);

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

  static ChatThreadModel fromJson(data) {
    ChatThreadModel u = new ChatThreadModel();
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
