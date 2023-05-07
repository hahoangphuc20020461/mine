import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:weather/src/Contract/cityWeatherViewContact.dart';
import 'package:weather/src/Contract/historyInforViewContract.dart';
import 'package:weather/src/Model/cityWeatherModel.dart';
import 'package:weather/src/Model/historyInforModel.dart';
import 'package:weather/src/Presenter/cityWeatherPresenter.dart';
import 'package:weather/src/Presenter/historyInforPresenter.dart';
import 'package:weather/src/ui/detailpage.dart';
import 'package:weather/src/ui/weatherItem.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    implements CityWeatherViewContract, HistoryInforViewContract {
  late bool _isLoading;
  dynamic city;
  dynamic historys;
  late CityWeatherPresenter _cityWeatherPresenter;
  late HistoryInforPresenter _historyInforPresenter;
  dynamic temp = "";
  dynamic cityName = "";
  dynamic icon = "";
  late final int index;
  MyHomePage(index) {
    // TODO: implement MyHomePage
    throw UnimplementedError();
  }

  late Timer _timer;
  int _counter = 0;

  void loadData() async {
    await HomeWidget.getWidgetData<String>('_cityName', defaultValue: "")
        .then((value) {
      cityName = value!;
    });
    await HomeWidget.getWidgetData<String>('_icon', defaultValue: "")
        .then((value) {
      icon = value!;
    });
    await HomeWidget.getWidgetData<String>('_temp', defaultValue: "")
        .then((value) {
      temp = value!;
    });

    setState(() {});
  }

  Future<void> updateAppWidget() async {
    await HomeWidget.saveWidgetData<String>('_cityName', cityName);
    await HomeWidget.saveWidgetData<String>('_icon', icon);
    await HomeWidget.saveWidgetData<String>('_temp', temp);

    await HomeWidget.updateWidget(
        name: 'HomeScreenWidgetProvider', iOSName: 'HomeScreenWidgetProvider');
  }

  void _incrementCounter(String iCity, String iIcon, String iTemp) {
    setState(() {
        cityName = iCity;
        icon = iIcon;
        temp = iTemp;
    });
    updateAppWidget();
  }

  @override
  void initState() {
    _cityWeatherPresenter = CityWeatherPresenter();
    _cityWeatherPresenter.attachView(this);

    _historyInforPresenter = HistoryInforPresenter();
    _historyInforPresenter.attachView(this);
    _isLoading = true;
    _historyInforPresenter.loadAllHistory();
    _cityWeatherPresenter.loadCityWeatherFromLocation();

    super.initState();
    // In ra dòng chữ "Hello" mỗi 5 giây
    // _timer = Timer.periodic(Duration(seconds: 2), (timer) {
    //   setState(() {
    //     _counter++;
    //   });
    //   print("Hello $_counter");
    // });

    HomeWidget.widgetClicked.listen((Uri? uri) => loadData());
    loadData(); // This will load data from widget every time app is opened
  }

  @override
  void dispose() {
    // Huỷ timer khi Widget bị huỷ
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(now);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: _isLoading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.place, size: 128, color: Colors.redAccent),
                  CircularProgressIndicator()
                ],
              ))
            : Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.cyan,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'lib/Input/${city?.weatherCurrent.image}',
                        )),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.height/10),
                        left: (MediaQuery.of(context).size.width/20),
                        right: (MediaQuery.of(context).size.width/20),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          // fetchWeatherData(value);
                        },
                        style: const TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          _cityWeatherPresenter.loadCityWeather(value);
                        },
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          hintStyle: const TextStyle(color: Colors.white),
                          hintText: 'Search'.toUpperCase(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.0, 1.3),
                      child: SizedBox(
                        height: (MediaQuery.of(context).size.height/73),
                        // width: 10,
                        child: Transform.scale(
                          scale: 0.86,
                          child: OverflowBox(
                            minWidth: 0.0,
                            maxWidth: MediaQuery.of(context).size.width,
                            minHeight: 0.0,
                            maxHeight:
                            (MediaQuery.of(context).size.height/1.15),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  // padding: const EdgeInsets.symmetric(
                                  //     horizontal: 16.8, vertical: 50),
                                  padding: EdgeInsets.only(
                                      top: (MediaQuery.of(context).size.height/4.01),
                                      right: MediaQuery.of(context).size.width/20.6,
                                      left: MediaQuery.of(context).size.width/20.6,
                                      bottom: (MediaQuery.of(context).size.height/36.6)),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20)),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  '${city?.weatherCurrent.nhietdo}' +
                                                      "℃",
                                                  // bỏ data nhiệt độ vào đây
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontFamily:
                                                      'flutterfonts',
                                                      fontSize: 40),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  '${city?.cityName}',
                                                  // bỏ data thành phố vào đây
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontFamily:
                                                      'flutterfonts'),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  formattedDate,
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 14,
                                                      fontFamily:
                                                      'flutterfonts'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(),
                                        Container(
                                          padding: EdgeInsets.all(MediaQuery.of(context).size.width/20),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              WeatherItem(
                                                  value: '${city
                                                      ?.weatherCurrent.gio}',
                                                  unit: "Kmh",
                                                  imageUrl:
                                                  "lib/Input/windspeed.png"),
                                              WeatherItem(
                                                  value: '${city
                                                      ?.weatherCurrent.doam}',
                                                  unit: "%",
                                                  imageUrl:
                                                  "lib/Input/humidity.png"),
                                              WeatherItem(
                                                  value: '${city
                                                      .weatherCurrent
                                                      .luongmua}',
                                                  unit: "mm",
                                                  imageUrl:
                                                  "lib/Input/rain.png"),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context).size.height/36.6,
                                              bottom: MediaQuery.of(context).size.height/36.6,
                                              right: MediaQuery.of(context).size.width/10.3,
                                              left: MediaQuery.of(context).size.width/10.3),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              WeatherItem(
                                                  value: city
                                                      ?.weatherCurrent
                                                      .khongkhi,
                                                  unit: "",
                                                  imageUrl:
                                                  "lib/Input/air.png"),
                                              Column(

                                                children: <Widget>[
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    child: Image.network(
                                                      'https:${city?.weatherCurrent.icon}',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Text(city
                                                      ?.weatherCurrent
                                                      .tinhtrang, //data gió
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .caption
                                                        ?.copyWith(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black54,
                                                        fontFamily: 'flutterfont'
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Expanded(
                flex: 2,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.6),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'today'.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            ?.copyWith(
                                            fontSize: 16,
                                            fontFamily: 'flutterfonts',
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_)=> DetailPage(cityData: city,))); //this will open forecast screen;
                                      },
                                      child: Container(
                                        child: Text(
                                          'Forecasts'.toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              ?.copyWith(
                                              fontSize: 16,
                                              fontFamily:
                                              'flutterfonts',
                                              color: Colors.blue,
                                              decoration: TextDecoration
                                                  .underline,
                                              decorationThickness: 3.0,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              Container(
                                height: 150,
                                padding: EdgeInsets.only(top: 15),
                                child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, index) {
                                      return Container(
                                        width: 100,
                                        height: 150,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            padding:
                                            const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  city?.weatherHour[index]
                                                      .thoigian, // bỏ dữ liệu giờ
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      ?.copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      color:
                                                      Colors.black,
                                                      fontFamily:
                                                      'flutterfont'),
                                                ),
                                                Image.network(
                                                  'https:${city?.weatherHour[index].icon}',
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.fill,
                                                ),
                                                Text(
                                                  '${city?.weatherHour[index].nhietdo}℃',
                                                  // bỏ dữ liệu mô tả vào đây, giống kiểu trời mưa, hay nắng hay mây
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      ?.copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      color:
                                                      Colors.black,
                                                      fontFamily:
                                                      'flutterfont'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, index) =>
                                        VerticalDivider(
                                          color: Colors.transparent,
                                          width: 5,
                                        ),
                                    itemCount: city.weatherHour
                                        .length // bỏ data số lượng kiểu length của mảng dữ liệu thời tiết nhiệt độ
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //PageView.builder(itemBuilder: (context))
          ],
        ),
    );
  }

  @override
  void onLoadCityWeatherComplete(CityWeather cityWeather, bool isLoading) {
    _incrementCounter(cityWeather.cityName, cityWeather.weatherCurrent.icon, cityWeather.weatherCurrent.nhietdo.toInt().toString());
    setState(() {
      city = cityWeather;
      _isLoading = isLoading;
      _historyInforPresenter.loadAddHistory(
          '${city?.cityName}', '${city?.countryName}');
    });
  }

  @override
  void onLoadAllHistoryComplete(List<HistoryInfor> allHistory) {
    setState(() {
      historys = allHistory;
    });
  }

  @override
  void onLoadHistoryByCityNameComplete(List<HistoryInfor> allHistory) {
    // TODO: implement onLoadHistoryByCityNameComplete
  }

  @override
  void onLoadHistoryByCountryComplete(List<HistoryInfor> allHistory) {
    // TODO: implement onLoadHistoryByCountryComplete
  }

  @override
  void onLoadHistoryByDateomplete(List<HistoryInfor> allHistory) {
    // TODO: implement onLoadHistoryByDateomplete
  }

  @override
  void onLoadAddHistory() {
    _historyInforPresenter.loadAllHistory();
  }

  @override
  void onLoadDeleteHistory() {
    // TODO: implement onLoadDeleteHistory
  }
}
