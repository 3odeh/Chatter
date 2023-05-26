import 'package:flutter/material.dart';

class SearchListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  late  bool hasJoined;
  final Future<dynamic> join;

   SearchListTile(
      {Key? key,
      required this.hasJoined,
      required this.title,
      required this.subtitle,
      required this.join})
      : super(key: key);

  @override
  State<SearchListTile> createState() => _SearchListTileState();
}

class _SearchListTileState extends State<SearchListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Container(
        height: 100,
        child: Center(
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.orange[900],
                radius: 30,
                child: Text(widget.title.trim().substring(0, 1).toUpperCase())),
            title: Text(
              widget.title.trim(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(widget.subtitle,
                style: TextStyle(
                    fontSize: 16,
                    color: (widget.hasJoined) ? Colors.black : null)),
            trailing: ElevatedButton(
              onPressed: (widget.hasJoined)
                  ? null
                  : () {
                      widget.join;
                      setState(() {
                        widget.hasJoined = true;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[900],
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                disabledBackgroundColor: Colors.black,
              ),
              child: Text(
                (widget.hasJoined) ? "joined" : "join",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
