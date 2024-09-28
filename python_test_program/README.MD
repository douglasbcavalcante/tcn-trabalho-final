# Programas para teste de publicação em broker MQTT

## Requisitos

- Python 3.10 ou superior
- Biblioteca paho-mqtt instalada
- Sugere-se usar ambiente virtual (virt-environment)

## mosquito_pub

- Esse programa efetua a publicação no tópico desejado em períodos definidos de tempo e gera um arquivo de log chamado **pub.csv** contendo as mensagens (data e hora com milissegundos) publicadas.

- Parâmetros importantes:

    - **BROKER_HOST**: ip do broker MQTT
    - **BROKER_PORT**: porta do broker MQTT
    - **TOPIC**: tópico a publicar
    - **TEMPO_ENTRE_PUBLICACOES**: tempo em segundos entre as publicações (aceita decimal) 

## mosquito_sub

- Esse programa efetua a subscrição no tópico desejado gera um arquivo de log chamado **sub.csv** contendo as mensagens recebidas (data e hora com milissegundos) e a timestamp de recebimento.

- Parâmetros importantes:

    - **BROKER_HOST**: ip do broker MQTT
    - **BROKER_PORT**: porta do broker MQTT
    - **TOPIC**: tópico a publicar