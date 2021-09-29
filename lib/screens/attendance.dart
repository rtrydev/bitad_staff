
import 'package:bitad_staff/widgets/qr_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Attendance extends StatelessWidget {


  @override
  Widget build(BuildContext context){

    final color = Theme.of(context).primaryColor;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, backgroundColor, Icons.text_fields, 'Wpisz kod', (){}),
        _buildButtonColumn(color, backgroundColor, Icons.email, 'E-Mail', (){})
      ],
    );

    Widget qrSection = Center(
      child: QRViewAttendance(),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text(
            'Sprawdź Obecność',
          textScaleFactor: 1.2,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.contacts, color: Colors.black,), onPressed: (){
            Navigator.pushReplacementNamed(context, '/contacts');
          },)
        ],
      ),
      body: Column(
        children: [
          Expanded(child: qrSection, flex: 7,),
          Expanded(child: buttonSection, flex: 1,)
        ],
      )
    );
  }



  TextButton _buildButtonColumn(Color color,Color backgroundColor, IconData icon, String label, void Function()? onPress) {
    return TextButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(backgroundColor),),
      onPressed: onPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



