import 'dart:async';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final brokerAddress = dotenv.env['MQTT_BROKER_URL'].toString();
final brokerPort = int.parse(dotenv.env['MQTT_BROKER_PORT'].toString());

class MyMqttClient {
  final MqttClient client;

  MyMqttClient()
      : client = MqttServerClient.withPort(brokerAddress, '', brokerPort);

  Future<void> connect() async {
    client.logging(on: false);
    client.setProtocolV311();
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier('mobileClient')
        .withWillTopic('connected')
        .withWillMessage('mobile client connected')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print('client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      print('socket exception - $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Mosquitto client connected');
    } else {
      print(
          'ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }
  }

  Future<void> publishMessage(
      {required String topic, required String msg}) async {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      var pubTopic = topic;
      final builder = MqttClientPayloadBuilder();
      builder.addString(msg);
      client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
      print("Publish $topic $msg ${DateTime.now()}");
      await MqttUtilities.asyncSleep(10);
    } else {
      print('ERROR Mosquitto client connection failed - message not published');
    }
  }

  void onSubscribed(String topic) {}

  void onDisconnected() {}

  void onConnected() {}

  void pong() {}
}
