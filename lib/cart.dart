import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dish_object.dart';

class Cart extends StatefulWidget {
  final List<Dish> _cart;

  Cart(this._cart);

  @override
  _CartState createState() => _CartState(this._cart);
}

class _CartState extends State<Cart> {
  _CartState(this._cart);

  List<Dish> _cart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      var item = _cart[index];
                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        child: Card(
                          elevation: 4.0,
                          child: ListTile(
                            leading: Icon(
                              item.icon,
                              color: item.color,
                            ),
                            title: Text(item.name),
                            trailing: GestureDetector(
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  setState(() {
                                    _cart.remove(item);
                                  });
                                }),
                          ),
                        ),
                      );
                    }),
              ),
              RaisedButton(
                onPressed: () {
                  email();
                },
                child: const Text('Confirm', style: TextStyle(fontSize: 20)),
                color: Colors.blue,
                textColor: Colors.white,
                elevation: 5,
              )
            ]),
        resizeToAvoidBottomInset: false
    );
  }
}

email() async {
  String username = "candotest123@gmail.com";
  String password = "123candotest321";

  final smtpServer = gmail(username, password);
  // Creating the Gmail server

  // Create our email message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add('miroslav@luno.com') //recipent email
//    ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com']) //cc Recipents emails
//    ..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
    ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}' //subject of the email
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'; //body of the email

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString()); //print if the email is sent
  } on MailerException catch (e) {
    print('Message not sent. \n'+ e.toString()); //print if the email is not sent
    // e.toString() will show why the email is not sending
  }
}
