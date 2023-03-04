#include <TimeLib.h>

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266HTTPClient.h>

#define light_pin D0

HTTPClient http;

const char *ssid = "Prajas";
const char *password = "12345678";

String Link = "http://172.20.10.3:5000/LH07";
String getData;

time_t start_time;

int flag = 0;

void setup() {
  delay(1000);
  Serial.begin(115200);
  WiFi.mode(WIFI_OFF);
  delay(1000);
  WiFi.mode(WIFI_STA);

  WiFi.begin(ssid, password);
  Serial.println("");

  Serial.print("Connecting");
  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  pinMode(light_pin, OUTPUT);
}

void loop() {
  
  String payload = get_payload();
  
  Serial.println(payload);

  if (flag == 0 && payload == "True"){
    flag = 1;
    start_class();  
  }

  else if(flag == 1 && payload == "False"){
    flag = 0;
    end_class();  
  }

  delay(2000);

}

String get_payload(){
  
  http.begin(Link);
  int httpCode = http.GET();
  return http.getString();  

}

void start_class(){
  
    digitalWrite(light_pin, LOW);

}

void end_class(){
  
  delay(5000);
  digitalWrite(light_pin, HIGH);  

}
