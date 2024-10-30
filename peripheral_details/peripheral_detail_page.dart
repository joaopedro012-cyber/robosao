// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:async';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';
import 'package:roboadmv1/screens/bluetooth/data/capabilities.dart';
import 'package:roboadmv1/screens/bluetooth/peripheral_details/widgets/result_widget.dart';
import 'package:roboadmv1/screens/bluetooth/peripheral_details/widgets/services_list_widget.dart';
import 'package:roboadmv1/screens/bluetooth/widgets/platform_button.dart';
import 'package:roboadmv1/screens/bluetooth/widgets/responsive_buttons_grid.dart';
import 'package:roboadmv1/screens/bluetooth/widgets/responsive_view.dart';

class PeripheralDetailPage extends StatefulWidget {
  final String deviceId;
  final String deviceName;
  const PeripheralDetailPage(this.deviceId, this.deviceName, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _PeripheralDetailPageState();
  }
}

class _PeripheralDetailPageState extends State<PeripheralDetailPage> {
  bool isConnected = false;
  GlobalKey<FormState> valueFormKey = GlobalKey<FormState>();
  List<BleService> discoveredServices = [];
  ExpandableController expandableController = ExpandableController();
  final List<String> _logs = [];
  final binaryCode = TextEditingController();

  ({
    BleService service,
    BleCharacteristic characteristic,
  })? selectedCharacteristic;

  @override
  void initState() {
    super.initState();
    UniversalBle.onConnectionChange = _handleConnectionChange;
    UniversalBle.onValueChange = _handleValueChange;
    UniversalBle.onPairingStateChange = _handlePairingStateChange;
  }

  @override
  void dispose() {
    super.dispose();
    UniversalBle.onConnectionChange = null;
    UniversalBle.onValueChange = null;
    // Disconnect when leaving the page
    if (isConnected) UniversalBle.disconnect(widget.deviceId);
  }

  void _addLog(String type, dynamic data) {
    setState(() {
      _logs.add('$type: ${data.toString()}');
    });
  }

  void _handleConnectionChange(String deviceId, bool isConnected) {
    print('_handleConnectionChange $deviceId, $isConnected');
    setState(() {
      if (deviceId == widget.deviceId) {
        this.isConnected = isConnected;
      }
    });
    _addLog('Connection', isConnected ? "Connected" : "Disconnected");
    // Auto Discover Services
    if (this.isConnected) {
      _discoverServices();
    }
  }

  void _handleValueChange(
      String deviceId, String characteristicId, Uint8List value) {
    String s = String.fromCharCodes(value);
    String data = '$s\nraw :  ${value.toString()}';
    print('_handleValueChange $deviceId, $characteristicId, $s');
    _addLog("Value", data);
  }

  void _handlePairingStateChange(
      String deviceId, bool isPaired, String? error) {
    print('OnPairStateChange $deviceId, $isPaired');
    if (error != null && error.isNotEmpty) {
      _addLog("PairStateChangeError", "(Paired: $isPaired): $error ");
    } else {
      _addLog("PairStateChange", isPaired);
    }
  }

  Future<void> _discoverServices() async {
    var services = await UniversalBle.discoverServices(widget.deviceId);
    print('${services.length} services discovered');
    discoveredServices.clear();
    setState(() {
      discoveredServices = services;
    });

    if (kIsWeb) {
      _addLog("DiscoverServices",
          '${services.length} services discovered,\nNote: Only services added in WebRequestOptionsBuilder will be discoverd');
    }
  }

  Future<void> _readValue() async {
    if (selectedCharacteristic == null) return;
    try {
      Uint8List value = await UniversalBle.readValue(
        widget.deviceId,
        selectedCharacteristic!.service.uuid,
        selectedCharacteristic!.characteristic.uuid,
      );
      String s = String.fromCharCodes(value);
      String data = '$s\nraw :  ${value.toString()}';
      _addLog('Read', data);
    } catch (e) {
      _addLog('ReadError', e);
    }
  }

  Future<void> _writeValue() async {
    if (selectedCharacteristic == null ||
        !valueFormKey.currentState!.validate() ||
        binaryCode.text.isEmpty) {
      return;
    }

    Uint8List value;
    try {
      value = Uint8List.fromList(hex.decode(binaryCode.text));
    } catch (e) {
      _addLog('WriteError', "Error parsing hex $e");
      return;
    }

    try {
      await UniversalBle.writeValue(
        widget.deviceId,
        selectedCharacteristic!.service.uuid,
        selectedCharacteristic!.characteristic.uuid,
        value,
        BleOutputProperty.withResponse,
      );
      _addLog('Write', value);
    } catch (e) {
      print(e);
      _addLog('WriteError', e);
    }
  }

  Future<void> _setBleInputProperty(BleInputProperty inputProperty) async {
    if (selectedCharacteristic == null) return;
    try {
      if (inputProperty != BleInputProperty.disabled) {
        List<CharacteristicProperty> properties =
            selectedCharacteristic!.characteristic.properties;
        if (properties.contains(CharacteristicProperty.notify)) {
          inputProperty = BleInputProperty.notification;
        } else if (properties.contains(CharacteristicProperty.indicate)) {
          inputProperty = BleInputProperty.indication;
        } else {
          throw 'No notify or indicate property';
        }
      }
      await UniversalBle.setNotifiable(
        widget.deviceId,
        selectedCharacteristic!.service.uuid,
        selectedCharacteristic!.characteristic.uuid,
        inputProperty,
      );
      _addLog('BleInputProperty', inputProperty);
    } catch (e) {
      _addLog('NotifyError', e);
    }
  }

  bool isValidProperty(List<CharacteristicProperty> properties) {
    for (CharacteristicProperty property in properties) {
      if (selectedCharacteristic?.characteristic.properties
              .contains(property) ??
          false) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.deviceName} - ${widget.deviceId}"),
        elevation: 4,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              isConnected
                  ? Icons.bluetooth_connected
                  : Icons.bluetooth_disabled,
              color: isConnected ? Colors.greenAccent : Colors.red,
              size: 20,
            ),
          )
        ],
      ),
      body: ResponsiveView(builder: (_, DeviceType deviceType) {
        return Row(
          children: [
            if (deviceType == DeviceType.desktop)
              Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).secondaryHeaderColor,
                  child: discoveredServices.isEmpty
                      ? const Center(
                          child: Text('No Services Discovered'),
                        )
                      : ServicesListWidget(
                          discoveredServices: discoveredServices,
                          scrollable: true,
                          onTap: (BleService service,
                              BleCharacteristic characteristic) {
                            setState(() {
                              selectedCharacteristic = (
                                service: service,
                                characteristic: characteristic
                              );
                            });
                          },
                        ),
                ),
              ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            PlatformButton(
                              text: 'Connect',
                              enabled: !isConnected,
                              onPressed: () async {
                                try {
                                  await UniversalBle.connect(widget.deviceId);
                                } catch (e) {
                                  _addLog('ConnectError', e);
                                }
                              },
                            ),
                            PlatformButton(
                              text: 'Disconnect',
                              enabled: isConnected,
                              onPressed: () {
                                UniversalBle.disconnect(widget.deviceId);
                              },
                            ),
                            PlatformButton(
                              text: 'Pair',
                              enabled: !isConnected,
                              onPressed: () async {
                                try {
                                  await UniversalBle.pair(widget.deviceId);
                                } catch (e) {
                                  _addLog('PairError', e);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      ValueListenableBuilder(
                          valueListenable: expandableController,
                          builder: (_, isExpanded, __) {
                            return isExpanded
                                ? const ResultWidget()
                                : ServicesListWidget(
                                    discoveredServices: discoveredServices,
                                    onTap: (BleService service,
                                        BleCharacteristic characteristic) {
                                      setState(() {
                                        selectedCharacteristic = (
                                          service: service,
                                          characteristic: characteristic
                                        );
                                      });
                                    },
                                  );
                          }),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
