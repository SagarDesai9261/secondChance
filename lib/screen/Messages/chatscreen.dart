import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';


import 'package:homelessapp/model/model.dart';

class ChatScreen extends StatefulWidget {
  final ChatPerson chatPerson;

  const ChatScreen({required this.chatPerson});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  Widget _buildTextComposer() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              maxLines: null,
              controller: _textController,
              // onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                  hintText: 'Type your message',
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.swap_horiz,
              color: Colors.grey,
            ), // Add a button to switch message type
            onPressed: () {
              setState(() {
                // isSender = !isSender;
              });
            },
          ),
          InkWell(
            onTap: () {
              // ignore: unnecessary_null_comparison
              if (_textController.text == null) {
                return;
              } else {
                // _handleSubmitted(_textController.text);
              }
            },
            child: const SizedBox(
              height: 28,
              child: Image(
                image: AssetImage('assets/send.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.chatPerson.name.toString(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.black12,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[600],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 5, right: 5),
                            child: Text(
                              chat.date,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      ...chat.messages
                          .map((message) => ChatMessagePage(message: message))
                          .toList(),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(height: 1.0),
            _buildTextComposer(),
          ],
        ),
      ),
    );
  }
}

class ChatMessagePage extends StatelessWidget {
  final ChatMessages message; // Pass ChatMessages object

  const ChatMessagePage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSender =
        message.senderId == '1'; // Determine if the message is from the sender

    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message.time,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ),
        isSender
            ? ChatBubble(
                clipper: ChatBubbleClipper2(type: BubbleType.sendBubble),
                alignment: isSender ? Alignment.topRight : Alignment.topLeft,
                backGroundColor: isSender ? Colors.white : Colors.grey,
                child: Container(
                  constraints: const BoxConstraints(
                      // maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                  // padding: EdgeInsets.all(10.0),
                  child: Text(
                    message.message,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            : ChatBubble(
                clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                alignment: isSender ? Alignment.topRight : Alignment.topLeft,
                backGroundColor: isSender ? Colors.white : Colors.grey,
                child: Container(
                  constraints: const BoxConstraints(
                      // maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                  // padding: EdgeInsets.all(10.0),
                  child: Text(
                    "  " + message.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

class ChatMessages {
  final String senderId;
  final String receiverId;
  final String message;
  final int messageId;
  final String time; // Add time field

  ChatMessages({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.messageId,
    required this.time, // Include time in the constructor
  });
}

class Chat {
  final String date;
  final List<ChatMessages> messages;

  Chat({
    required this.date,
    required this.messages,
  });
}

List<Chat> chats = [
  Chat(
    date: '14th Jan 2019',
    messages: [
      ChatMessages(
        senderId: '1',
        receiverId: '2',
        message: 'Hello',
        messageId: 1,
        time: '10:30 AM', // Include time here
      ),
      ChatMessages(
        senderId: '2',
        receiverId: '1',
        message: 'Hi',
        messageId: 2,
        time: '10:35 AM', // Include time here
      ),
    ],
  ),
  Chat(
    date: '15th Jan 2019',
    messages: [
      ChatMessages(
        senderId: '1',
        receiverId: '3',
        message: 'Hey Alice',
        messageId: 3,
        time: '11:00 AM', // Include time here
      ),
      ChatMessages(
        senderId: '3',
        receiverId: '1',
        message: 'Hi John',
        messageId: 4,
        time: '11:05 AM', // Include time here
      ),
    ],
  ),
  // Add more chat objects with dates, messages, and times
  // ...
];
