import 'package:chatway/app/apis/chat.api.dart';
import 'package:chatway/app/models/chat.model.dart';
import 'package:chatway/app/models/message.model.dart';
import 'package:chatway/app/models/user.model.dart';
import 'package:chatway/app/stores/chat.store.dart';
import 'package:chatway/app/utils/api_response.dart';
import 'package:chatway/app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:signalr_client/signalr_client.dart';

import '../utils/const.dart';

part 'chat.controller.g.dart';

class ChatController = _ChatControllerBase with _$ChatController;

abstract class _ChatControllerBase with Store {
  @observable
  ObservableFuture<ChatStore> store;
  @observable
  HubConnection connection;
  @observable
  TextEditingController inputMessageController = TextEditingController();
  @observable
  String inputMessage = '';
  @observable
  bool isAttended = false;
  @observable
  Chat chat = Chat();
  @observable
  bool isAtendente = false;
  @observable
  User user = Consts.user;

  // *-----------------------------------------------------------------------------------
  @computed
  List<Message> get listFiltered {
    if (store.value == null) return List<Message>();

    return store.value.messages.toList();
  }

  // *-----------------------------------------------------------------------------------
  @action
  setHelpMessage(String helpMessage) async {
    await fetch();
    sendHelpMessage(helpMessage);
  }

  @action
  sendHelpMessage(String textHelpMessage) {
    if (textHelpMessage != "Outro") {
      sendMessage(textHelpMessage);
    }
  }

  @action
  sendMessage(String textMessage) {
    final message = Message(
      content: textMessage,
      sender: user.id,
      receiver: chat.id,
      time: DateTime.now(),
    );

    store.value.addMessage(message);
    connection.invoke("Send", args: [message, chat.id]);

    clearInputMessage();
  }

  @action
  Future<void> fetch() async {
    store = getStore().asObservable();
    if (chat.id == null) {
      print(">> Create Chat");
      await createChat();
    }
    await createSignalRConnection();
  }

  @action
  setInputMessage(String value) async => inputMessage = value;

  @action
  setIsAtendentes(bool value) async {
    if (isAtendente) {
      user = Consts.user;
    } else {
      user = Consts.userAtendente;
    }
    return isAtendente = value;
  }

  @action
  clearInputMessage() {
    inputMessageController.clear();
    inputMessage = "";
  }

  @action
  setIsAttended(bool value) => isAttended = value;

  // *-----------------------------------------------------------------------------------
  Future<ChatStore> getStore() async {
    var store = ChatStore();
    return store;
  }

  Future<void> createSignalRConnection() async {
    connection =
        HubConnectionBuilder().withUrl("${Consts.baseURL}/ChatWay").build();

    await connection.start();
    connection.invoke("LinkChatToGroup", args: [chat.id]);
    connection.invoke("CreateNewChat");

    connection.on("ReceiveDebug", (data) {
      print("> ReceiveDebug ${data.toString()}");
    });

    connection.on("ReceiveAttendance", (data) {
      print("> ReceiveAttendance ${data.toString()}");
      setIsAttended(true);
    });

    connection.on("Receive", (data) {
      print("> Receive ${data[0].toString()}");
      final receiveMessage = Message.fromJson(data[0]);

      store.value.addMessage(receiveMessage);
    });
  }

  Future<void> createChat() async {
    ApiResponse response = await ChatApi.createChat(
      motorista: user.nome,
      motoristaId: user.id,
      unidade: user.unidade,
    );

    if (response.ok) {
      chat = response.result;

      print("<< $chat");
    }
  }
}
