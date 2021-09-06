import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:scholarramp/services/chat.dart';
import 'package:scholarramp/config.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {

  List<ChatMessage> messages = [];
  TextEditingController _inputMessageController = new TextEditingController();
  Dialogflow dialogflow;
  AuthGoogle authGoogle;
  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await initiateDialogFlow();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 140,
      padding: EdgeInsets.only(bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          chatSpaceWidget(),
          bottomChatView(),
        ],
      ),
    );
  }


  Widget chatSpaceWidget() {
    return Flexible(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ListView.builder(
                itemCount: messages.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
                    child: Align(
                      alignment: (messages[index].messageType == "receiver" ? Alignment.topLeft : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: (messages[index].messageType == "receiver"
                              ? LinearGradient(colors: [Colors.grey.shade200, Colors.grey.shade200],)
                              : LinearGradient(colors: [gradientStartColor, gradientEndColor],)
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        child: Text(
                          messages[index].messageContent == null ? 'Sorry. I Could not understand it.' : messages[index].messageContent,
                          style: TextStyle(
                            fontSize: 16,
                            color: (messages[index].messageType == "receiver" ? Colors.black45 : Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget bottomChatView() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right:5.0, top:5.0, bottom: 5.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      height: 55,
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: gradientStartColor, width: 1),
      ),

      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _inputMessageController,
              onSubmitted: (String str) {
                fetchFromDialogFlow(str);
              },
              decoration: InputDecoration(
                  hintText: "Write message...",
                  border: InputBorder.none,
              ),
            ),
          ),

          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              gradient: LinearGradient(
                colors: [gradientStartColor, gradientEndColor],
              ),
            ),
            child: MaterialButton(
              onPressed: () {
                fetchFromDialogFlow(_inputMessageController.text);
              },
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              elevation: 0,
            ),
          ),

        ],
      ),
    );
  }

  _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  initiateDialogFlow() async {
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/creds.json").build();
    dialogflow = Dialogflow(authGoogle: authGoogle, language: Language.english);
  }

  fetchFromDialogFlow(String input) async {
    _inputMessageController.clear();
    setState(() {
      messages.add(ChatMessage(messageContent: input, messageType: "sender"));
    });
    _scrollToBottom();
    AIResponse response = await dialogflow.detectIntent(input);
    setState(() {
      messages.add(ChatMessage(messageContent: response.getMessage(), messageType: "receiver"));
    });
    _scrollToBottom();
  }

}
