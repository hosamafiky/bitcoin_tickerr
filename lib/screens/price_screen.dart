import 'dart:convert';
import 'dart:io';

import 'package:bitcointickerr/helper/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiKey = "FBBF093A-00F1-47FA-A840-947C24B546A0";

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";
  double firstRate, secondRate, thirdRate;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
        getData(cryptoList[0]);
        get2Data(cryptoList[1]);
        get3Data(cryptoList[2]);
      },
      items: dropDownItems,
    );
  }

  Widget iosPicker() {
    List<Widget> items = [];
    currenciesList.forEach((element) {
      items.add(Text(element));
    });
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        getData(cryptoList[0]);
        get2Data(cryptoList[1]);
        get3Data(cryptoList[2]);
      },
      children: items,
    );
  }

  void getData(String fromFirst) async {
    String url =
        "https://rest.coinapi.io/v1/exchangerate/$fromFirst/$selectedCurrency?apikey=$apiKey";
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    setState(() {
      firstRate = jsonData["rate"];
    });
  }

  void get2Data(String fromSecond) async {
    String url =
        "https://rest.coinapi.io/v1/exchangerate/$fromSecond/$selectedCurrency?apikey=$apiKey";
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    setState(() {
      secondRate = jsonData["rate"];
    });
  }

  void get3Data(String fromThird) async {
    String url =
        "https://rest.coinapi.io/v1/exchangerate/$fromThird/$selectedCurrency?apikey=$apiKey";
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    setState(() {
      thirdRate = jsonData["rate"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(cryptoList[0]);
    get2Data(cryptoList[1]);
    get3Data(cryptoList[2]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Coin Ticker",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: firstRate == null && secondRate == null && thirdRate == null
          ? Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Please Wait..",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 10.0),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
                  child: Card(
                    color: Colors.lightBlueAccent,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 28.0),
                      child: Text(
                        "1 ${cryptoList[0]} = ${firstRate.toStringAsFixed(0)} $selectedCurrency",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
                  child: Card(
                    color: Colors.lightBlueAccent,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 28.0),
                      child: Text(
                        "1 ${cryptoList[1]} = ${secondRate.toStringAsFixed(0)} $selectedCurrency",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
                  child: Card(
                    color: Colors.lightBlueAccent,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 28.0),
                      child: Text(
                        "1 ${cryptoList[2]} = ${thirdRate.toStringAsFixed(0)} $selectedCurrency",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 150.0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 30.0),
                  color: Colors.lightBlue,
                  child: Platform.isAndroid ? androidDropdown() : iosPicker(),
                ),
              ],
            ),
    );
  }
}
