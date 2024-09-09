/* ESP32 DEVKIT V1 COM CH340 no Ubuntu 22.04

https://github.com/juliagoda/CH341SER
https://github.com/juliagoda/CH341SER/issues/18


add yourself to dialout and change permissions on it

$ sudo adduser <username> dialout
$ sudo chmod 777 /dev/ttyUSB0

*/


#include <Arduino.h>

/*********
  Baseado no projeto de Rui Santos
  Complete project details at https://randomnerdtutorials.com  
*********/

#include <WiFi.h>
#include <PubSubClient.h>
#include <Wire.h>

// Replace the next variables with your SSID/Password combination
const char* ssid = "L&D2g";
const char* password = "Do&Lu@1309";

// Add your MQTT Broker IP address
const char* mqtt_server = "192.168.15.2";
const char* PUB_TOPIC = "data_hora";
const int mqtt_port = 31883;
const int SEND_CYCLE_TIME_MS = 10;

WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];
int value = 0;
struct tm *nowtm;
char message[64], tmbuf[64];

// LED Pin
const int ledPin = 2;

void setup_wifi() {
  delay(10);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

}


void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("ESP32Client")) {
      Serial.println("connected");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  configTime(-3 * 3600, 0, "a.st1.ntp.br", "b.st1.ntp.br", "c.st1.ntp.br");
  pinMode(ledPin, OUTPUT);
}


void loop() {

  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  digitalWrite(ledPin, 1);

  long now = millis();
  if (now - lastMsg > SEND_CYCLE_TIME_MS) {
    lastMsg = now;

    struct timeval tv;
    if (gettimeofday(&tv, NULL)!= 0) {
      Serial.println("Failed to obtain time");
      return;
    }

    time_t epochTime = tv.tv_sec;
    nowtm = localtime(&epochTime);
    strftime(message, sizeof message, "%Y-%m-%d %H:%M:%S", nowtm);
    snprintf(message, sizeof message, "%s.%03d", message, tv.tv_usec / 1000);

    Serial.print("Data_Hora: ");
    Serial.println(message);

    client.publish(PUB_TOPIC, message);

  }
  
  digitalWrite(ledPin, 0);

}