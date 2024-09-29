import paho.mqtt.client as mqtt
from datetime import datetime
import csv

# Configurações do broker MQTT
# BROKER_HOST = "192.168.15.2"
BROKER_HOST = "a7eafdfc662004680aa6f774193acd33-2034123120.us-east-1.elb.amazonaws.com"
BROKER_PORT = 1883
TOPIC = "data_hora"
# Nome do arquivo CSV onde os dados serão armazenados
CSV_FILE = "sub.csv"

# Função de callback quando a conexão com o broker é estabelecida
def on_connect(client, userdata, flags, rc):
    print(f"Conectado com o código de resultado: {rc}")
    client.subscribe(TOPIC)

# Função de callback quando uma mensagem é recebida
def on_message(client, userdata, msg):
    # Obtém a data e hora atuais
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
    # Decodifica o payload da mensagem
    message = msg.payload.decode()
    write_to_csv(current_time, message)
    # Imprime a mensagem recebida e a data e hora atual
    print(f"Mensagem recebida: {message} | Data e hora de recebimento: {current_time}")

# Função para escrever a mensagem no arquivo CSV
def write_to_csv(timestamp, message):
    with open(CSV_FILE, mode='a', newline='') as file:
        writer = csv.writer(file)
        writer.writerow([timestamp, message])


# Criação do cliente MQTT
client = mqtt.Client()

# Define os callbacks
client.on_connect = on_connect
client.on_message = on_message

# Conecta ao broker MQTT
client.connect(BROKER_HOST, BROKER_PORT, 60)

# Inicia o loop do cliente MQTT
try:
    client.loop_forever()
except KeyboardInterrupt:
    print("Interrompido pelo usuário")
finally:
    client.disconnect()
