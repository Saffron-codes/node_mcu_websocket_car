#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <WebSocketsServer.h>
#include <ArduinoJson.h>
#include <ESP8266mDNS.h>


WebSocketsServer webSocket(81);
ESP8266WebServer server(80);

void noMovement(){
  digitalWrite(D1, LOW);
  digitalWrite(D3, LOW);
  digitalWrite(D2, LOW);
  digitalWrite(D4, LOW);
}

void Forward(){
  digitalWrite(D1, HIGH);
  digitalWrite(D3, HIGH);
  digitalWrite(D2, LOW);
  digitalWrite(D4, LOW);
}


void Reverse(){
  digitalWrite(D2, HIGH);
  digitalWrite(D4, HIGH);
  digitalWrite(D1, LOW);
  digitalWrite(D3, LOW);
}

void leftfunc(){
  //left motor
  digitalWrite(D1,HIGH);
  digitalWrite(D2,LOW);
  
  //right motor
  digitalWrite(D3,LOW);
  digitalWrite(D4,HIGH);
}

void rightfunc(){
  //left motor
  digitalWrite(D1,LOW);
  digitalWrite(D2,HIGH);
  
  //right motor
  digitalWrite(D3,HIGH);
  digitalWrite(D4,LOW);
}

void SerializeJSONData(DynamicJsonDocument doc){
    int isforward = doc["isforward"];
    int left = doc["isleft"]; // isleft
    int right = doc["isright"];
    double motorSpeed = doc["speed"];

    if(motorSpeed==0.0 && left != 1 && right != 1){
      noMovement();
      Serial.println("MOVEMENT STOPPED");
    }
    
    if (isforward == 1 && motorSpeed > 1.0){
      Forward();
    }
    if (isforward == 0 && motorSpeed > 1.0){
      Reverse();
    }
    if(left == 1){
      leftfunc();
    }
    if(right == 1){
      rightfunc();
    }
}

void right(){
  //left motor
  digitalWrite(D1,HIGH);
  digitalWrite(D2,LOW);
  
  //right motor
  digitalWrite(D3,LOW);
  digitalWrite(D4,HIGH);
}

void left(){
  //left motor
  digitalWrite(D1,LOW);
  digitalWrite(D2,HIGH);
  
  //right motor
  digitalWrite(D3,HIGH);
  digitalWrite(D4,LOW);
}


void webSocketEvent(uint8_t num, WStype_t type, uint8_t *payload, size_t length)
{
  switch (type)
  {
  case WStype_DISCONNECTED:
    Serial.printf("[%u] Disconnected!\n", num);
    break;
  case WStype_CONNECTED:
  {
    IPAddress ip = webSocket.remoteIP(num);
    Serial.printf("[%u] Connected from %d.%d.%d.%d url: %s\n", num, ip[0], ip[1], ip[2], ip[3], payload);

    // send message to client
    webSocket.sendTXT(num, "Connected from server");
  }
  break;
  case WStype_TEXT:
    Serial.printf("[%u] get Text: %s\n", num, payload);
    String message = String((char *)(payload));
    Serial.println(message);

    // serializing data
    DynamicJsonDocument doc(200);
    DeserializationError error = deserializeJson(doc, message);
    if (error)
    {
      Serial.print("deserializeJson() failed: ");
      Serial.println(error.c_str());
      return;
    }
    
    SerializeJSONData(doc);// data function called here 
  }
}

void setup()
{
  Serial.begin(115200);
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);
  pinMode(D3, OUTPUT);
  pinMode(D4, OUTPUT);
  WiFi.softAP("Car", "");
  Serial.println("softap");
  Serial.println("");
  Serial.println(WiFi.softAPIP());

  if (MDNS.begin("ESP"))
  { // esp.local/
    Serial.println("MDNS responder started");
  }

  server.begin();
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
}

void loop()
{
  webSocket.loop();
  server.handleClient();
}
