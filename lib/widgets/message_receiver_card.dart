import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xtract/model/message_model.dart'; 



class MsgReceiverCard extends StatelessWidget {
  const MsgReceiverCard({
    super.key,
    required this.message, 
  });

  final MessageResponse message;

  @override
  Widget build(BuildContext context) {
    const double kDefault = 16.0;
    return Padding(
      padding: const EdgeInsets.only(top: kDefault * 1.4,left: 8.0),
      child: Column(
        children: [
          Row(
            children: [
               
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefault * 0.8, vertical: kDefault * 0.6),
                  margin: const EdgeInsets.only(left: kDefault / 2),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAEAEC),
                    borderRadius: BorderRadius.only(
                       
                        topRight: Radius.circular(kDefault),
                        bottomRight: Radius.circular(kDefault),
          
                        ),
                  ),
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                    Text(
                             "Topic: ${message.topic}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00B1CC),
                              ),
                            ), Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  message.message,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
          
                              ],
                            ),
                          ),
                         
                        ],
                      ),
                      
              
                    ],
                  ),
                ),
                
              ),
              
            ],
          ),
        Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                                 getDateAndTime(DateTime.now().toString()),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
            ],
          ),
        ), ],
      ),
    );
  }

String getDateAndTime(String date) {
  DateTime dateTime;
  try {
    dateTime = DateTime.parse(date).toLocal();
    return DateFormat('yyyy-MM-dd HH:mm:ss:SSS').format(dateTime);
  } catch (e) {
    return date;
  }
}
}
