const int trig = 16;
const int echo = 15;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);
  pinMode(4, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  long duration, distance;
  digitalWrite(trig, LOW);
  delayMicroseconds(2);
  digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);
  duration = pulseIn(echo, HIGH);

  distance = duration * 17 / 1000;
  if(distance <= 100){
    digitalWrite(4, HIGH);
  }else{
    digitalWrite(4, LOW);
  }

  
  Serial.println(duration);
  Serial.print("\nDistance: ");
  Serial.print(distance);
  Serial.println(" cm");
  delay(100);
}
