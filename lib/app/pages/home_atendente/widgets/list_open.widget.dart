import 'package:flutter/material.dart';

import 'item_chat.widget.dart';

class ListOpenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: 20,
      itemBuilder: (_, index) {
        return ItemChatWidget(
          index: index.toString(),
          message: "Mensagem automatica $index",
          newMessages: index,
          time: "00:00",
          title: "Motorista $index",
        );
      },
    );
  }
}
