import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with ChannelEventHandler {
  TextEditingController textEditingController = TextEditingController();
  late String senderMessage, receiverMessage;
  ScrollController scrollController = ScrollController();

  List<BaseMessage> messages = [];

  @override
  void initState() {
    super.initState();
    SendbirdSdk().addChannelEventHandler('chat', this);
    load();
  }

  @override
  void dispose() {
    SendbirdSdk().removeChannelEventHandler("chat");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.arrow_back_ios_new_sharp,
          ),
        ),
        title: const Text(
          '강남스팟',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        actions: const [
          Icon(Icons.menu),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                BaseMessage msg = messages[index];
                String nickname = "unknown";
                String profileUrl = "";
                if (msg.sender!.profileUrl != "") {
                  profileUrl = msg.sender!.profileUrl.toString();
                }
                if (msg.sender!.nickname != "") {
                  nickname = msg.sender!.nickname.toString();
                }
                DateTime dateTime =
                    DateTime.fromMillisecondsSinceEpoch(msg.createdAt);
                String formattedDateTime = formatHour(dateTime);
                return ListTile(
                  // Display all channel members as the title
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profileUrl),
                            radius: 20,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: const BoxDecoration(
                              color: Colors.white12, // Message bubble color
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nickname,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  msg.message.toString(),
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            formattedDateTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    print(msg);
                  },
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.black,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    bottom: 24,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: Colors.white10,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: textEditingController,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 6,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: '메세지 보내기',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    bottom: 24,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white30,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () {
                        print('add message');
                      },
                      onLongPress: () {
                        print('long press');
                      },
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void load() async {
    String userId = "강남스팟";
    String appId = "BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF";
    String apiToken = "f93b05ff359245af400aa805bafd2a091a173064";
    String channelurl = "sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211";

    final sendBird = SendbirdSdk(
      appId: appId,
      apiToken: apiToken,
    );

    final _ = await sendBird.connect(userId);
    final channel = await OpenChannel.getChannel(channelurl);

    List<BaseMessage> messageList = await channel.getMessagesByTimestamp(
      DateTime.now().millisecondsSinceEpoch * 1000,
      MessageListParams(),
    );

    setState(() {
      messages = messageList;
    });
  }

  String formatHour(DateTime dateTime) {
    //final formatDate = DateTime(dateTime.year, dateTime.month, dateTime.day,dateTime.hour, dateTime.minute);
    return "${dateTime.hour}:${dateTime.minute}";
  }
}
