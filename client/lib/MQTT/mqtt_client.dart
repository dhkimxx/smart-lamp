import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

const brokerAddress = "54.180.41.24";
const brokerPort = 55427;
var pongCount = 0;

class MyMqttClient {
  final client = MqttServerClient.withPort(brokerAddress, '', brokerPort);

  Future<void> connect() async {
    client.logging(on: false);
    client.setProtocolV311();
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    final connMess = MqttConnectMessage()
        .withClientIdentifier('mobile client')
        .withWillTopic('connected')
        .withWillMessage('mobile client connected')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      print('EXAMPLE::socket exception - $e');
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

  Future<void> pubMessage(String topic, String msg) async {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      var pubTopic = topic;
      final builder = MqttClientPayloadBuilder();
      builder.addString(msg);
      client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
      print("Publish $topic $msg ${DateTime.now()}");
      await MqttUtilities.asyncSleep(10);
      //client.disconnect();
    } else {
      print('ERROR Mosquitto client connection failed - message not published');
    }
  }
}

void onSubscribed(String topic) {}

void onDisconnected() {
  print("Disconnected!");
}

void onConnected() {
  print("Connected!");
}

void pong() {
  pongCount++;
}
