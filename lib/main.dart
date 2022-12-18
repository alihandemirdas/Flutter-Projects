import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:havadurumu/models.dart';
import 'package:intl/intl.dart';

Future<WeatherResponse> getWeather(String city) async {
  final queryParameters = {
    'q': city,
    'appid': 'i-am-so-sorry-i-cant-share-this',
    'units': 'metric',
    'cnt': '40'
  };
  final uri = Uri.https(
      'api.openweathermap.org', '/data/2.5/forecast', queryParameters);
  final response = await http.get(uri);
  final json = jsonDecode(response.body);
  return WeatherResponse.fromJson(json);
}

void main() {
  runApp(const MyApp());
}

final cityTextController = TextEditingController();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hava Durumu',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var sehir = null, derece = null;
  var bir = null, iki = null, uc = null;
  var today = null, t2 = null, t3 = null, t4 = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 50),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 75,
            ),
            const Text('GÜNCEL\nHAVA DURUMUNU\nÖĞRENİN\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat-Thin',
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            if (sehir != null && derece != null)
              Column(
                children: [
                  Text(sehir,
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Montserrat",
                          color: Color.fromRGBO(144, 63, 172, 100))),
                  Text(
                    "${derece}°C",
                    style: TextStyle(fontFamily: "Montserrat", fontSize: 40),
                  )
                ],
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: SizedBox(
                width: 275,
                height: 50,
                child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: cityTextController,
                    decoration: InputDecoration(
                        labelText: 'Şehir giriniz:',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                        filled: true,
                        fillColor: Color.fromRGBO(217, 217, 217, 100)),
                    textAlign: TextAlign.center),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(144, 63, 172, 100),
                    foregroundColor: Colors.black),
                onPressed: search,
                child: Text('GÖNDER')),
            if (bir != null && iki != null && uc != null)
              Column(
                children: [
                  Container(
                    height: 20,
                  ),
                  Text("3 Günlük Hava Tahmini",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500)),
                  Divider(
                      color: Color.fromRGBO(144, 63, 172, 100),
                      endIndent: 65,
                      indent: 65,
                      thickness: 2.5),
                  Text("• ${bir}°C | ${t2}",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20)),
                  Text("• ${iki}°C | ${t3}",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20)),
                  Text("• ${uc}°C | ${t4}",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20))
                ],
              ),
          ],
        ),
      ),
    );
  }

  void search() async {
    final response = await getWeather(cityTextController.text);
    setState(() => {
          sehir = cityTextController.text,
          derece = response.sifir,
          today = DateFormat('dd-MM-yyyy').format(DateTime.now()),
          t2 = DateFormat('dd-MM-yyyy').format(DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day + 1)),
          t3 = DateFormat('dd-MM-yyyy').format(DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day + 2)),
          t4 = DateFormat('dd-MM-yyyy').format(DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day + 3)),
          bir = response.bir,
          iki = response.iki,
          uc = response.uc
        });
  }
}
