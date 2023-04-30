#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#define _CRT_SECURE_NO_WARNINGS
// Update these with values suitable for your network.

String clientId = "100";

// const char* ssid = "921-2.4g";
// const char* password = "kpu123456!";
const char* ssid = "";
const char* password = "";
const char* mqtt_server = "13.124.243.209";
const int port = 58355;

String topicOrder = clientId;
String topicSetDistance = "setDistance/" + clientId;
String topicSetTime = "setTime/" + clientId;
char *led_state = "OFF";
int Distance = 50;  // default detection distance 50cm
int Time = 10000;  // default led on time 10sec (10000msec)

const int LED = 4;
const int trig = 16;
const int echo = 15;
unsigned long time_previous = 0, time_current = 0;
WiFiClient espClient;
PubSubClient client(espClient);
unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE	(50)
char msg[MSG_BUFFER_SIZE];
bool loop_flag = false;

void led_on(){
  loop_flag = false;
  digitalWrite(BUILTIN_LED, LOW);
  digitalWrite(LED, HIGH);
  led_state = "ON";
  snprintf (msg, MSG_BUFFER_SIZE, "%s-%s", clientId.c_str(), led_state);
  Serial.print("Publish message /state ");
  Serial.println(msg);
  client.publish("state", msg);
}

void led_off(){
  loop_flag = false;
  digitalWrite(BUILTIN_LED, HIGH);
  digitalWrite(LED, LOW);
  led_state = "OFF";
  snprintf (msg, MSG_BUFFER_SIZE, "%s-%s", clientId.c_str(), led_state);
  Serial.print("Publish message /state ");
  Serial.println(msg);
  client.publish("state", msg);
}

int hc_sr04(int target){
  long duration, distance;
  digitalWrite(trig, LOW);
  delayMicroseconds(2);
  digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);
  duration = pulseIn(echo, HIGH);
  distance = duration * 17 / 1000;
  if(distance <= target){
    Serial.print("\nDistance: ");
    Serial.print(distance);
    Serial.println(" cm");
    return 1;
  }else{
    return 0;
  }
}

int pir(){
  return 0;
}

void setup_wifi() {
  delay(10);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    digitalWrite(BUILTIN_LED, LOW);
    delay(500);
    Serial.print(".");
  }
  digitalWrite(BUILTIN_LED, HIGH);
  randomSeed(micros());
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived /");
  Serial.print(topic);
  Serial.print(" ");
  String messageTemp = "";
  for (int i = 0; i < length; i++) {
    messageTemp += (char)payload[i];
  }
  char ntopic[50];
  for(int i = 0; i < strlen(topic) - 1; i++){
    ntopic[i] = topic[i];
  }
  Serial.println(messageTemp);

  
  if(!strcmp(topic, topicOrder.c_str())){
    if(messageTemp == "ON"){
      led_on();
    }
    if(messageTemp == "OFF"){
      led_off();
    }
  }else if(!strcmp(topic, topicSetDistance.c_str())){
      Distance = atoi(messageTemp.c_str());
      Serial.print("set Distance: ");
      Serial.println(Distance);
  }else if(!strcmp(topic, topicSetTime.c_str())){
      Time = 1000 * atoi(messageTemp.c_str());
      Serial.print("set Time: ");
      Serial.println(Time);
  }
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect(clientId.c_str())) {
      Serial.println("connected");
      // Once connected, publish an announcement...
      client.publish("login", clientId.c_str());
      // ... and resubscribe
      client.subscribe(topicOrder.c_str());
      client.subscribe(topicSetDistance.c_str());
      client.subscribe(topicSetTime.c_str());
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(500);
    }
  }
}

void setup() {
  pinMode(BUILTIN_LED, OUTPUT);
  pinMode(LED, OUTPUT);
  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);
  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_server, port);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  delay(100);
  if(hc_sr04(Distance) && !strcmp(led_state,"OFF")){
    led_on();
    time_previous = millis();
    loop_flag = true;
  }
  if((millis() - time_previous >= Time) && !strcmp(led_state,"ON") && loop_flag){
    led_off();
  }
}
