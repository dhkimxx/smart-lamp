#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#define _CRT_SECURE_NO_WARNINGS

const char* ssid = "921-2.4G";
const char* password = "kpu123456!";
// const char* ssid = "myhomewifi2.4g";
// const char* password = "wifi82825535";
const char* mqtt_server = "13.124.243.209";
const int port = 58355;

String clientId = "101";
String topicOrder = clientId;
String topicSetDistance = "setDistance/" + clientId;
String topicSetTime = "setTime/" + clientId;
String topicSetBrightness = "setBrightness/" + clientId;

int Distance = 50;  // default detection distance 50cm
int Time = 10000;  // default led on time 10sec (10000msec)
float Brightness = 5; // Brightness scope: 0~10 stemp, analogWrite: 1023 * (1 - Brightness / 10)

const int LED = 2;
const int TRIG = 16;
const int ECHO = 15;

unsigned long loop_time_previous = 0;
unsigned long check_time_previous = 0;
unsigned long check_time = 1000;

WiFiClient espClient;
PubSubClient client(espClient);
unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE	(50)
char msg[MSG_BUFFER_SIZE];
bool delay_flag = false;
bool check_flag = false;

void led_on(){
  digitalWrite(BUILTIN_LED, 1023 * (1 - Brightness / 10));
  analogWrite(LED, 1023 * (1 - Brightness / 10));
  snprintf (msg, MSG_BUFFER_SIZE, "%s-%s", clientId.c_str(), "ON");
  Serial.print("Publish message /state ");
  Serial.println(msg);
  client.publish("state", msg);
}

void led_off(){
  digitalWrite(BUILTIN_LED, HIGH);
  analogWrite(LED, 1023);
  snprintf (msg, MSG_BUFFER_SIZE, "%s-%s", clientId.c_str(), "OFF");
  Serial.print("Publish message /state ");
  Serial.println(msg);
  client.publish("state", msg);
}

int hc_sr04(int target_distance){
  long duration, distance;
  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG, LOW);
  duration = pulseIn(ECHO, HIGH);
  distance = duration * 17 / 1000;
  if(distance <= target_distance){
    Serial.print("\nDistance: ");
    Serial.print(distance);
    Serial.println(" cm");
    return 1;
  }else{
    return 0;
  }
}

void setup_wifi() {
  delay(10);
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
    if(messageTemp == "ON") led_on();
    if(messageTemp == "OFF")  led_off();
  }
  else if(!strcmp(topic, topicSetDistance.c_str())){
    Distance = atoi(messageTemp.c_str());
    Serial.print("set Distance: ");
    Serial.println(Distance);
  }
  else if(!strcmp(topic, topicSetTime.c_str())){
    Time = 1000 * atoi(messageTemp.c_str());
    Serial.print("set Time: ");
    Serial.println(Time);
  }
  else if(!strcmp(topic, topicSetBrightness.c_str())){
    Brightness = atof(messageTemp.c_str());
    Serial.print("set Brightness: ");
    Serial.println((int)Brightness);
    if (delay_flag) analogWrite(LED, 1023 * (1 - Brightness / 10));
    else{
      check_flag = true;
      check_time_previous = millis();
      analogWrite(LED, 1023 * (1 - Brightness / 10));
    }
  }
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (client.connect(clientId.c_str())) {
      Serial.println("connected");
      client.publish("login", clientId.c_str());
      client.subscribe(topicOrder.c_str());
      client.subscribe(topicSetDistance.c_str());
      client.subscribe(topicSetTime.c_str());
      client.subscribe(topicSetBrightness.c_str());
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(500);
    }
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(BUILTIN_LED, OUTPUT);
  pinMode(LED, OUTPUT);
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);
  
  setup_wifi();
  client.setServer(mqtt_server, port);
  client.setCallback(callback);
}

void loop() {
  delay(10);
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  delay(100);
  if(!delay_flag && hc_sr04(Distance)){
    led_on();
    loop_time_previous = millis();
    delay_flag = true;
    check_flag = false;
  }

  if(delay_flag) Serial.println(millis() - loop_time_previous);

  if(delay_flag && (millis() - loop_time_previous >= Time)){
    led_off();
    delay_flag = false;
  }
  
  if (check_flag && (millis() - check_time_previous >= check_time)){
    analogWrite(LED, 1023);
    check_flag = false;
  }
}
