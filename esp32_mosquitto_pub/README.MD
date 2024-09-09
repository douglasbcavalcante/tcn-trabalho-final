# esp32_mosquitto_pub

- Aplicação para ESP32 para publicação no cluster kubernetes

- O programa conecta-se ao WiFi, atualiza seu relógio e publica no broker a hora atual.

## Parâmetros importantes:

- __mqtt_server__: ip do broker MQTT.
- __mqtt_port__: porta do broker MQTT.
- __SEND_CYCLE_TIME_MS__: tempo em milissegundos entre uma publicação e outra.
- __PUB_TOPIC__: tópico a publicar.
- __ssid__: nome da rede wifi.
- __password__: senha da rede wifi.