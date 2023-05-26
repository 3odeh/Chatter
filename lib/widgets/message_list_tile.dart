import 'package:flutter/material.dart';

class MessageListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final int index;
  final bool isMe;
  final DateTime time;

  const MessageListTile(
      {Key? key,
      required this.index,
      required this.title,
      required this.subtitle,
      required this.time, required this.isMe})
      : super(key: key);

  @override
  State<MessageListTile> createState() => _MessageListTileState();
}

class _MessageListTileState extends State<MessageListTile> {
  @override
  Widget build(BuildContext context) {
    return (widget.isMe)?  Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Row(
          mainAxisAlignment:  MainAxisAlignment.end,
          children: [
            const SizedBox(width: 10),
            Expanded(
              flex: 0,
              child: Container(
                constraints: const BoxConstraints(
                    minHeight: 70
                    , minWidth: 100, maxWidth: 200),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    color: Colors.orange[900]?.withOpacity(0.2)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        widget.subtitle,
                        style:
                        const TextStyle(fontSize: 15, color: Colors.black),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Text(
                        "${widget.time.hour}:${widget.time.minute}",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
                backgroundColor: Colors.orange[900],
                radius: 20,
                child: Text(
                  widget.title.trim().substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    ) : Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Row(
          children: [
            const SizedBox(width: 10),
            CircleAvatar(
                backgroundColor: Colors.orange[900],
                radius: 20,
                child: Text(
                  widget.title.trim().substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                )),
            const SizedBox(width: 10),
            Expanded(
              flex: 0,
              child: Container(
                constraints: const BoxConstraints(
                    minHeight: 80, minWidth: 100, maxWidth: 200),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: Colors.orange[900]?.withOpacity(0.2)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Text(
                        widget.title.trim(),
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold,decoration: TextDecoration.underline),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                     margin : const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        widget.subtitle,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Text(
                        "${widget.time.hour}:${widget.time.minute}",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
