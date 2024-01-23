// chat_list_page.dart
import 'package:flutter/material.dart';
import 'package:homelessapp/model/model.dart';
import 'package:homelessapp/screen/Messages/chatscreen.dart';
import 'package:intl/intl.dart';

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create a list of demo chat persons.
    final List<ChatPerson> chatPersons = [
      ChatPerson(
        id: '1',
        name: 'John Doe',
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80',
        lastMessage: 'Hello, how are you?',
      ),
      ChatPerson(
        id: '2',
        name: 'Jane Smith',
        imageUrl:
            'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
        lastMessage: 'Good morning!',
      ),
      ChatPerson(
        id: '3',
        name: 'Alice Johnson',
        imageUrl:
            'https://as1.ftcdn.net/v2/jpg/02/43/12/34/1000_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
        lastMessage: "What's up?",
      ),
      ChatPerson(
        id: '4',
        name: 'Yash Trivedi',
        imageUrl:
            'https://as1.ftcdn.net/v2/jpg/02/43/12/34/1000_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
        lastMessage: "Hello!!",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                CustomDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white10),
        child: ListView.builder(
          itemCount: chatPersons.length,
          itemBuilder: (ctx, index) {
            final chatPerson = chatPersons[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(chatPerson.imageUrl.toString()),
              ),
              title: Text(chatPerson.name.toString()),
              subtitle: Text(chatPerson.lastMessage.toString()),
              trailing: const Text(
                '2:30 PM', // Replace with the actual message timestamp
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                // Navigate to the chat screen with chatPerson as a parameter.
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            ChatScreen(chatPerson: chatPerson))));
              },
            );
          },
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Custom Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Handle the home item tap here
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle the settings item tap here
            },
          ),
          // Add more list items for your custom menu
        ],
      ),
    );
  }
}
