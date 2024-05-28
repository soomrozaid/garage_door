import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "GarageDoor",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController authTokenController = TextEditingController();

  bool _isAuthenticated = false;
  List<Device?> _doors = [];

  String? _authToken;

  @override
  void initState() {
    super.initState();

    authenticate();
  }

  Future<void> authenticate() async {
    String? authToken = await retrieveAuthToken();

    if (authToken == null) {
      setState(() {
        _isAuthenticated = false;
      });
    } else {
      var request = http.Request("POST",
          Uri.parse("https://api.smartgarage.systems/session/register"));

      request.headers.addAll({"Authorization": authToken});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        List<Device?> doors = await getDoors();

        print('doors: $doors, length: ${doors.length}');

        setState(() {
          _isAuthenticated = true;
          _doors = doors;
        });
      }

      print('statusCode: ${response.statusCode}');
    }
  }

  Future<String?> retrieveAuthToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? authToken = sharedPreferences.getString("authToken");

    setState(() {
      _authToken = authToken;
    });

    return authToken;
  }

  void setAuthToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("authToken", token);

    setState(() {
      _authToken = token;
    });

    authenticate();
  }

  Future<List<Device?>> getDoors() async {
    String? authToken = await retrieveAuthToken();

    if (authToken == null) {
      setState(() {
        _isAuthenticated = false;
      });
      return <Device>[];
    } else {
      var request = http.Request(
          "GET", Uri.parse("https://api.smartgarage.systems/devices"));

      request.headers.addAll({"Authorization": authToken});

      http.StreamedResponse response = await request.send();

      setState(() {
        _isAuthenticated = response.statusCode == 200;
      });

      print('statusCode: ${response.statusCode}');

      dynamic resMap = await response.stream
          .bytesToString()
          .then((value) => json.decode(value));

      List<Device?> devices = [];

      for (var device in resMap["devices"]) {
        devices.add(Device.fromString(device));
      }

      print(resMap.runtimeType);
      // print('devices: ${response.stream.bytesToString()}');
      print(resMap["devices"][0]);
      print(Device.fromString(resMap["devices"][0]));
      // return [{}, {}];

      return devices;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Garage Door"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isAuthenticated
                ? GridView.builder(
                    itemCount: _doors.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      Device device = _doors[index]!;
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.blue,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                device.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                device.doors[0].status == 4 ? "Closed" : "Open",
                              )
                            ],
                          )),
                        ),
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                          child: TextField(
                        controller: authTokenController,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(),
                          helperText:
                              "Please enter your authentication token (Bearer ***)",
                        ),
                      )),
                      ElevatedButton(
                          onPressed: () =>
                              setAuthToken(authTokenController.text),
                          child: const Text("Authenticate")),
                    ],
                  ),
          ),
        ));
  }
}

class Device {
  final String _id;
  final String _serialNumber;
  final String _name;
  final bool _isLocked;
  final String _ssid;
  final String _userId;
  final int _rssi;
  final int _status;
  final bool _isEnabled;
  final DateTime _createdAt;
  final DateTime _updatedAt;
  final int _model;
  final int _family;
  final String _vendor;
  final String _timezone;
  final String _zipcode;
  final bool _isExpired;
  final bool _isUpdatingFirware;
  final List<Door> _doors;
  final String _ownership;

  Device._internal({
    required String id,
    required String serialNumber,
    required String name,
    required bool isLocked,
    required String ssid,
    required String userId,
    required int rssi,
    required int status,
    required bool isEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int model,
    required int family,
    required String vendor,
    required String timezone,
    required String zipcode,
    required bool isExpired,
    required bool isUpdatingFirware,
    required List<Door> doors,
    required String ownership,
  })  : _id = id,
        _serialNumber = serialNumber,
        _name = name,
        _isLocked = isLocked,
        _ssid = ssid,
        _userId = userId,
        _rssi = rssi,
        _status = status,
        _isEnabled = isEnabled,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _model = model,
        _family = family,
        _vendor = vendor,
        _timezone = timezone,
        _zipcode = zipcode,
        _isExpired = isExpired,
        _isUpdatingFirware = isUpdatingFirware,
        _doors = doors,
        _ownership = ownership;

  String get id {
    return _id;
  }

  String get serialNumber {
    return _serialNumber;
  }

  String get name {
    return _name;
  }

  bool get isLocked {
    return _isLocked;
  }

  String get ssid {
    return _ssid;
  }

  String get userId {
    return _userId;
  }

  int get rssi {
    return _rssi;
  }

  int get status {
    return _status;
  }

  bool get isEnabled {
    return _isEnabled;
  }

  DateTime get createdAt {
    return _createdAt;
  }

  DateTime get updatedAt {
    return _updatedAt;
  }

  int get model {
    return _model;
  }

  int get family {
    return _family;
  }

  String get vendor {
    return _vendor;
  }

  String get timezone {
    return _timezone;
  }

  String get zipcode {
    return _zipcode;
  }

  bool get isExpired {
    return _isExpired;
  }

  bool get isUpdatingFirware {
    return _isUpdatingFirware;
  }

  List<Door> get doors {
    return _doors;
  }

  String get ownership {
    return _ownership;
  }

  factory Device({
    required String id,
    required String serialNumber,
    required String name,
    required bool isLocked,
    required String ssid,
    required String userId,
    required int rssi,
    required int status,
    required bool isEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int model,
    required int family,
    required String vendor,
    required String timezone,
    required String zipcode,
    required bool isExpired,
    required bool isUpdatingFirware,
    required List<Door> doors,
    required String ownership,
  }) {
    return Device._internal(
      id: id,
      serialNumber: serialNumber,
      name: name,
      isLocked: isLocked,
      ssid: ssid,
      userId: userId,
      rssi: rssi,
      status: status,
      isEnabled: isEnabled,
      createdAt: createdAt,
      updatedAt: updatedAt,
      model: model,
      family: family,
      vendor: vendor,
      timezone: timezone,
      zipcode: zipcode,
      isExpired: isExpired,
      isUpdatingFirware: isUpdatingFirware,
      doors: doors,
      ownership: ownership,
    );
  }

  static Device fromString(Map map) {
    List<Door> doors = [];

    for (var door in map["doors"]) {
      doors.add(Door.fromString(door));
    }

    return Device(
      id: map["id"],
      serialNumber: map["serial_number"],
      name: map["name"],
      isLocked: map["is_locked"],
      ssid: map["ssid"],
      userId: map["userId"] ?? '',
      rssi: map["rssi"] ?? 0,
      status: map["status"] ?? 0,
      isEnabled: map["isEnabled"] ?? false,
      createdAt: map["createdAt"] ?? DateTime.now(),
      updatedAt: map["updatedAt"] ?? DateTime.now(),
      model: int.tryParse(map["model"]) ?? 0,
      family: map["family"] ?? 0,
      vendor: map["vendor"] ?? "",
      timezone: map["timezone"] ?? "",
      zipcode: map["zipcode"] ?? "",
      isExpired: map["isExpired"] ?? false,
      isUpdatingFirware: map["isUpdatingFirware"] ?? false,
      doors: doors,
      ownership: map["ownership"] ?? "",
    );
  }

  @override
  String toString() {
    return '''Device(
      id: $id,
      serialNumber: $serialNumber,
      name: $name,
      isLocked: $isLocked,
      ssid: $ssid,
      userId: $userId,
      rssi: $rssi,
      status: $status,
      isEnabled: $isEnabled,
      createdAt: $createdAt,
      updatedAt: $updatedAt,
      model: $model,
      family: $family,
      vendor: $vendor,
      timezone: $timezone,
      zipcode: $zipcode,
      isExpired: $isExpired,
      isUpdatingFirware: $isUpdatingFirware,
      doors: $doors,
      ownership: $ownership,
    )''';
  }
}

class Door {
  final String _id;
  final int _batteryLevel;
  final DateTime _createdAt;
  final DateTime _updatedAt;
  final bool _isEnabled;
  final int _status;
  final String _vehicleType;
  final String _vehicleColor;
  final int _linkStatus;
  final String _name;
  final int _bleStrength;
  final int _doorIndex;

  const Door._internal({
    required String id,
    required int batteryLevel,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isEnabled,
    required int status,
    required String vehicleType,
    required String vehicleColor,
    required int linkStatus,
    required String name,
    required int bleStrength,
    required int doorIndex,
  })  : _id = id,
        _batteryLevel = batteryLevel,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _isEnabled = isEnabled,
        _status = status,
        _vehicleType = vehicleType,
        _vehicleColor = vehicleColor,
        _linkStatus = linkStatus,
        _name = name,
        _bleStrength = bleStrength,
        _doorIndex = doorIndex;

  String get id {
    return _id;
  }

  int get batteryLevel {
    return _batteryLevel;
  }

  DateTime get createdAt {
    return _createdAt;
  }

  DateTime get updatedAt {
    return _updatedAt;
  }

  bool get isEnabled {
    return _isEnabled;
  }

  int get status {
    return _status;
  }

  String get vehicleType {
    return _vehicleType;
  }

  String get vehicleColor {
    return _vehicleColor;
  }

  int get linkStatus {
    return _linkStatus;
  }

  String get name {
    return _name;
  }

  int get bleStrength {
    return _bleStrength;
  }

  int get doorIndex {
    return _doorIndex;
  }

  factory Door({
    required String id,
    required int batteryLevel,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isEnabled,
    required int status,
    required String vehicleType,
    required String vehicleColor,
    required int linkStatus,
    required String name,
    required int bleStrength,
    required int doorIndex,
  }) {
    return Door._internal(
        id: id,
        batteryLevel: batteryLevel,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isEnabled: isEnabled,
        status: status,
        vehicleType: vehicleType,
        vehicleColor: vehicleColor,
        linkStatus: linkStatus,
        name: name,
        bleStrength: bleStrength,
        doorIndex: doorIndex);
  }

  static Door fromString(Map map) {
    return Door(
        id: map["id"],
        batteryLevel: map["batteryLevel"] ?? 0,
        createdAt: map["createdAt"] ?? DateTime.now(),
        updatedAt: map["updatedAt"] ?? DateTime.now(),
        isEnabled: map["isEnabled"] ?? false,
        status: map["status"],
        vehicleType: map["vehicleType"] ?? '',
        vehicleColor: map["vehicleColor"] ?? '',
        linkStatus: map["linkStatus"] ?? 0,
        name: map["name"] ?? "",
        bleStrength: map["bleStrength"] ?? 0,
        doorIndex: map["doorIndex"] ?? 0);
  }

  @override
  String toString() {
    return '''Door(
      id: $id,
      batteryLevel: $batteryLevel,
      createdAt: $createdAt,
      updatedAt: $updatedAt,
      isEnabled: $isEnabled,
      status: $status,
      vehicleType: $vehicleType,
      vehicleColor: $vehicleColor,
      linkStatus: $linkStatus,
      name: $name,
      bleStrength: $bleStrength,
      doorIndex: $doorIndex
    )''';
  }
}
