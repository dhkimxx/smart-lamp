#include <ESP8266WiFiMulti.h>
#include <PubSubClient.h>
#include <ESP8266HTTPClient.h>
#define _CRT_SECURE_NO_WARNINGS

const int LED = 2; //D4
const int TRIG = 16; //D0
const int ECHO = 15; //D8
const int PIR = 5; //D1

const char* ssid = "myhomewifi2.4g";
const char* password = "wifi82825535";
const char* mqtt_server = "20.163.15.199";
const int port = 1883;

String clientId = "100";
String topicOrder = clientId;
String topicSetDistance = "setDistance/" + clientId;
String topicSetTime = "setTime/" + clientId;
String topicSetBrightness = "setBrightness/" + clientId;

int Distance = 50;  // Default detection distance: 50cm
int Time = 10000;  // Default led on time: 10sec (10000msec)
float Brightness = 1; // Brightness scope: 0~10 stemp, analogWrite: 1023 * (1 - Brightness / 10)
int WarningTime = 10;   // Default detecting motionless time: 5sec

unsigned long loop_time_previous = 0;
unsigned long check_time_previous = 0;
unsigned long check_time = 500;
unsigned long warning_time_previous = 0;
unsigned long warning_time = WarningTime * 1000;

#define MSG_BUFFER_SIZE	(50)
char msg[MSG_BUFFER_SIZE];
bool delay_flag = false;
bool check_flag = false;
bool warning_flag = false;

ESP8266WiFiMulti WiFiMulti;
WiFiClient espClient;
PubSubClient client(espClient);

void http_request(){
  WiFiClient client;
  HTTPClient http;
  Serial.print("[HTTP] begin...\n");
    if (http.begin(client, "http://20.163.15.199:8080/send-test")) {  // HTTP
      Serial.print("[HTTP] POST...\n");
      // start connection and send HTTP header
      http.addHeader("Content-Type", "application/json");
      Serial.print("{\"unitCode\":" + clientId +  "}");
      int httpCode = http.POST("{\"unitCode\":" + clientId +  "}");
      // httpCode will be negative on error
      if (httpCode > 0) {
        // HTTP header has been send and Server response header has been handled
        Serial.printf("[HTTP] POST... code: %d\n", httpCode);
        // file found at server
        if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
          String payload = http.getString();
          Serial.println(payload);
        }
      } else {
        Serial.printf("[HTTP] POST... failed, error: %s\n", http.errorToString(httpCode).c_str());
      }
      http.end();
    } else {
      Serial.printf("[HTTP} Unable to connect\n");
    }
}

void led_on(){
  digitalWrite(BUILTIN_LED, 1023 * (1 - Brightness / 10));
  analogWrite(LED, 1023 * (1 - Brightness / 10));
  snprintf (msg, MSG_BUFFER_SIZE, "%s-%s", clientId.c_str(), "ON");
  Serial.print("Publish message /status ");
  Serial.println(msg);
  client.publish("status", msg);
}

void led_off(){
  digitalWrite(BUILTIN_LED, HIGH);
  analogWrite(LED, 1023);
  snprintf (msg, MSG_BUFFER_SIZE, "%s-%s", clientId.c_str(), "OFF");
  Serial.print("Publish message /status ");
  Serial.println(msg);
  client.publish("state", msg);
}

int pir(){
  return digitalRead(PIR);
}

int hc_sr04(int target_distance){
  long duration, distance;
  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG, LOW);
  duration = pulseIn(ECHO, HIGH);
  distance = duration * 0.034 / 2;
  if(distance <= target_distance){
    Serial.print("\nDistance: ");
    Serial.print(distance);
    Serial.println(" cm");
    return 1;
  }else{
    return 0;
  }
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
    delay_flag = false;
    check_flag = false;
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
    
    if (client.connect("")) {
      Serial.println("connected");
      client.publish("mmmm", clientId.c_str());
      client.subscribe(topicOrder.c_str());
      client.subscribe(topicSetDistance.c_str());
      client.subscribe(topicSetTime.c_str());
      client.subscribe(topicSetBrightness.c_str());
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.print(" try again in 5 seconds");
      Serial.print("(");
      for(int i = 1; i <= 5; i++){
        Serial.print(i);
        Serial.print("...");
        delay(1000);
      }
      Serial.println(")");
    }
  }
}

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.mode(WIFI_STA);
  //WiFi.begin(ssid, password);
  WiFiMulti.addAP(ssid, password);
  while ((WiFiMulti.run() != WL_CONNECTED)) {
    delay(500);
    Serial.print(".");
  }
  
  randomSeed(micros());
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void setup() {
  Serial.begin(115200);
  pinMode(BUILTIN_LED, OUTPUT);
  pinMode(LED, OUTPUT);
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);
  
  digitalWrite(BUILTIN_LED, HIGH);
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

  if(hc_sr04(Distance)){
    if(warning_flag){
      Serial.println(millis() - warning_time_previous);
      if((millis() - warning_time_previous) > warning_time){
        Serial.println("Http Request!!");
        http_request();
        delay(1000);
        warning_flag = false;
      }
    } else{
      warning_flag = true;
      warning_time_previous = millis();
    }
  } else{
        warning_flag = false;
  }
  
  delay(100);

  if(!delay_flag && pir()){
    led_on();
    loop_time_previous = millis();
    delay_flag = true;
    check_flag = false;
  }

  if(delay_flag && (millis() - loop_time_previous >= Time)){
    led_off();
    delay_flag = false;
  }

  if (check_flag && (millis() - check_time_previous >= check_time)){
    analogWrite(LED, 1023);
    check_flag = false;
  }
}
