import paho.mqtt.client as mqtt
from datetime import datetime
import time
import csv

# Configurações do broker MQTT
BROKER_HOST = "192.168.15.2"
BROKER_PORT = 31883
TOPIC = "data_hora"
TEMPO_ENTRE_PUBLICACOES = 0.001 # Tempo em segundos.

# Nome do arquivo CSV onde os dados serão armazenados
CSV_FILE = "pub.csv"

# Função para criar a mensagem com a data e hora atuais
def get_current_datetime():
    now = datetime.now()
    return now.strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]  # Mantém apenas 3 casas decimais nos milissegundos

# Função de callback quando a conexão com o broker é estabelecida
def on_connect(client, userdata, flags, rc):
    print(f"Conectado com o código de resultado: {rc}")
    #client.subscribe(TOPIC)

# Função de callback quando uma mensagem é recebida
def on_message(client, userdata, msg):
    print(f"Mensagem recebida: {msg.payload.decode()}")

# Função para escrever a mensagem no arquivo CSV
def write_to_csv(message):
    with open(CSV_FILE, mode='a', newline='') as file:
        writer = csv.writer(file)
        writer.writerow([message])

# Criação do cliente MQTT
client = mqtt.Client()

# Define os callbacks
client.on_connect = on_connect
client.on_message = on_message

# Conecta ao broker MQTT
client.connect(BROKER_HOST, BROKER_PORT, 60)

# Publica a data e hora atuais no tópico especificado
def publish_current_datetime():
    while True:
        datetime_message = get_current_datetime()
        client.publish(TOPIC, datetime_message)
        write_to_csv(datetime_message)
        print(f"Publicado: {datetime_message}")
        time.sleep(TEMPO_ENTRE_PUBLICACOES) 

# Inicia o loop de conexão e publicação
try:
    client.loop_start()
    publish_current_datetime()
except KeyboardInterrupt:
    print("Interrompido pelo usuário")
finally:
    client.loop_stop()
    client.disconnect()