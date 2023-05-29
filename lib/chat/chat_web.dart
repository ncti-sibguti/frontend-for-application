// import 'package:flutter/material.dart';
// import 'package:stomp_dart_client/stomp.dart';
// import 'package:stomp_dart_client/stomp_config.dart';
// import 'package:stomp_dart_client/stomp_frame.dart';

// class ChatWebSocket {
//   final String url;
//   late StompClient stompClient;

//   ChatWebSocket(this.url) {
//     StompClient stompClient = StompClient(
//   config: StompConfig(
//     url: 'ws://yourhost',
//     onConnect: onConnected,
//     stompConnectHeaders: {'Authorization': '$token'},
//     webSocketConnectHeaders: {'Authorization': '$token'},
//     onWebSocketError: (e) => print(e.toString()),
//     onStompError: (d) => print('error stomp'),
//     onDisconnect: (f) => print('disconnected'),
//   ),
// );
//   }

 

//   void sendMessage(String topic, String message) {
//     stompClient.send(
//       destination: topic,
//       body: message,
//     );
//     stompClient.
//   }
// }