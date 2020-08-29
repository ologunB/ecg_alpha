import 'package:ecgalpha/utils/constants.dart';
import 'package:ecgalpha/views/user/home/home_view.dart';
import 'package:flutter/material.dart';

class ExpectingPage extends StatefulWidget {
  final List<Expect> items;

  const ExpectingPage({Key key, @required this.items}) : super(key: key);
  @override
  _ExpectingPageState createState() => _ExpectingPageState();
}

class _ExpectingPageState extends State<ExpectingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Expecting Payments",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
          itemCount: widget.items.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "₦ " +
                            commaFormat.format(
                                double.parse(widget.items[index].amount)),
                        style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.items[index].date,
                        style: TextStyle(fontSize: 17, color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
