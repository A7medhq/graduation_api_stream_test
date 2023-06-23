import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation/constant/constant.dart';
import 'package:graduation/models/ChatMsgModel.dart';

import '../../controller/chat_api_controller.dart';
import '../../models/ChatDataModel.dart';
import '../../models/top_doctors.dart';
import '../../prefs/prefs.dart';

class PrivateChat extends StatefulWidget {
  PrivateChat({Key? key, required this.data}) : super(key: key);
  static const id = 'PrivateChat';
  final ChatDataModel data;

  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  late ChatDataModel receivedData;
  late TextEditingController controller;
  late ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    receivedData = widget.data;
    controller = TextEditingController();

  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }


  Stream<List<ChatMsgModel>> getStream() async* {
    int i = 0;
    while ( i < 10){
      List<ChatMsgModel> myStreamData = await chatApiController().GetChatMassage(id: receivedData.Id);

      await Future.delayed(Duration(milliseconds: 200));

          yield myStreamData;
      }
      }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'http://ac7a1ae098-001-site1.etempurl.com${receivedData.image}'),
                radius: 18,
              ),
              SizedBox(
                width: 12.w,
              ),
              Text('${receivedData.name}',
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp)),
            ],
          ),
          bottom: PreferredSize(
              child: Container(
                color: Constant.textFiledColor,
                height: 2.0,
              ),
              preferredSize: Size.fromHeight(4.0)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            StreamBuilder(
              stream: getStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Constant.primaryColor,
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Expanded(
                      flex: 20,
                      child: ListView.builder(
                          // shrinkWrap: true,
                          // reverse: true,
                        // controller: scrollController.jumpTo(scrollController.position.maxScrollExtent) ,
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            String id =
                                SharedPrefController().getValueFor('id');

                            final currentUser = id;
                            return MessageBubble(
                                messages: snapshot.data![index].message,
                                index: index,
                                isMe: snapshot.data![index].senderUserId ==
                                    currentUser);
                          }));
                } else {
                  return Center(
                    child: Text('Start your conversation with doctors'),
                  );
                }
              },
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          hintText: 'Type message..',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 26.w),
                          constraints: BoxConstraints(
                            maxHeight: 65.h,
                            minHeight: 65.h,
                          ),
                          // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal,
                              color: Color(0xffb4b4b4)),
                          filled: false,
                          // fillColor: Constant.textFiledColor,
                          counterText: '',
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffe7e7e7), width: 1),
                            borderRadius: BorderRadius.circular(80.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Constant.primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(80.r),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(80.r),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(80.r),
                          ),
                          errorStyle: GoogleFonts.poppins(fontSize: 12.sp)),

                      // border: InputBorder.none,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.r),
                        color: Constant.primaryColor),
                    child: Center(
                      child: IconButton(
                          onPressed: () {
                            chatApiController().SendMsg(
                                id: receivedData.Id, msg: controller.text);
                            setState(() {
                              controller.clear();
                            });
                          },
                          icon: Icon(
                            Icons.send,
                            size: 20,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key? key,
      required this.messages,
      required this.index,
      // required this.sender,
      required this.isMe})
      : super(key: key);

  final String messages;
  final int index;
  // final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          // Text(
          //   '$sender',
          //   style: TextStyle(fontSize: 12, color: Color(0xff9e59aa)),
          // ),
          SizedBox(
            height: 8,
          ),
          Material(
            color: isMe ? Constant.primaryColor : Colors.grey.shade400,
            borderRadius: isMe
                ? BorderRadius.only(
                    topRight: Radius.circular(15.r),
                    bottomLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    bottomLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r),
                  ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${messages}',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
