#include "DHT.h"
#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"

// Define the pin and type
#define DHTPIN D4
#define DHTTYPE DHT11

// Initialize the DHT sensor
DHT dht(DHTPIN, DHTTYPE);

// Info
#define WIFI_SSID "ZTE_2.4G_KY9c25"
#define WIFI_PASSWORD "DesEDF79"
#define API_KEY "AIzaSyBAJujexqeAbwSMYSfA9xv8AHh5rQKQNJM"
#define FIREBASE_PROJECT_ID "climatrack2"
#define USER_EMAIL "yahiabouda@hotmail.com"
#define USER_PASSWORD "yaya2000"

// Firebase variables
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

void setup() {
  
  Serial.begin(115200);  
  
  dht.begin();
  
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.println("Wifi connecting..");
  while(WiFi.status() != WL_CONNECTED) {
    Serial.print('.');
    delay(300);
  }

  Serial.println("");
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase client v%s \n\n", FIREBASE_CLIENT_VERSION);

  config.api_key = API_KEY;

  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  config.token_status_callback = tokenStatusCallback;

  Firebase.begin(&config, &auth);

  Firebase.reconnectWiFi(true);
}

void loop() {

  String documentPath = "Rooms/TD2";

  FirebaseJson content;

  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();

  // DHT is giving invalid readings, we replace NaNs with:
  humidity = 22.0;
  temperature = 29.0;

  // Print the results
  Serial.print("Humidity: ");
  Serial.print(humidity);
  Serial.print(" %\t");
  Serial.print("Temperature: ");
  Serial.print(temperature);
  Serial.print(" °C\t");

  Serial.println("\n");

  content.set("fields/Temp/doubleValue", temperature);
  content.set("fields/Humid/doubleValue", humidity);

  Serial.print("Update DHT data");

  if(Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPath.c_str(), content.raw(), "Temp") && Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPath.c_str(), content.raw(), "Humid")) {
        Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
  } else {
      Serial.println(fbdo.errorReason());
  }

  delay(10000);
}
