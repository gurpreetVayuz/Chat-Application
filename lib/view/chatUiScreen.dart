import 'package:chatapplication/database/databaseHelper.dart';
import 'package:chatapplication/model/messageModel.dart';
import 'package:flutter/material.dart';

class ChatUiScreen extends StatefulWidget {
  @override
  _ChatUiScreenState createState() => _ChatUiScreenState();
}

class _ChatUiScreenState extends State<ChatUiScreen> {
  var type = "";
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  var limit = 0;

  List<MessageModel> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _scrollController.addListener((onScroll));
  }

  _loadMessages() async {
    List<MessageModel> messages = await _dbHelper.messages();
    setState(() {
      _messages = messages;
      // _messages.length = 10;
    });
    _scrollToBottom();
  }

  void onScroll() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      limit += 10;
      setState(() {
        // _messages.length += limit;
      });
    }
  }

  _sendMessage(String content, String type) async {
    MessageModel message = MessageModel(
      sender: type,
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await _dbHelper.insertMessage(message);
    _loadMessages();
    _controller.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 202, 240),
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(
              color: Color.fromARGB(255, 103, 195, 232),
              fontWeight: FontWeight.w500,
              fontSize: 30),
        ),
        backgroundColor: const Color.fromRGBO(35, 33, 46, 1),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      _messages[index].sender == "user"
                          ? Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      const Color.fromARGB(243, 3, 142, 201),
                                  child: CircleAvatar(
                                    radius: 21,
                                    child: ClipOval(
                                      child:
                                          Image.asset("assets/images/user.png"),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 17,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _messages[index].sender,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      _messages[index].content,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                const Spacer(),
                              ],
                            )
                          : Row(
                              children: [
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _messages[index].sender,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      _messages[index].content,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),Text(
                                      _messages[index].timestamp.toString(),
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w200),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 17,
                                ),
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      const Color.fromARGB(243, 3, 142, 201),
                                  child: CircleAvatar(
                                    radius: 21,
                                    child: ClipOval(
                                      child:
                                          Image.asset("assets/images/me.png"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _sendMessage(_controller.text, "user"),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: TextField(
                      controller: _controller,
                      decoration:
                          const InputDecoration(hintText: 'Type a message'),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _sendMessage(_controller.text, "me"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
