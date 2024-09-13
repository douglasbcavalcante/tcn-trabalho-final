# Cluster Kubernetes para x86 local, virtualizado ou baremetal

## Requisitos
- Desktop Ubuntu 22.04
- 8GB RAM
- Virtual Box (Ubuntu 22.04 - 4GB RAM)

## Instalação do Kubernetes na versão K3S

- Roteiro usado de base: [Step-by-Step Guide: Creating a Kubernetes Cluster on Raspberry Pi 5 with K3s](https://everythingdevops.dev/step-by-step-guide-creating-a-kubernetes-cluster-on-raspberry-pi-5-with-k3s/)

### O que é o K3S:

- O K3s é uma distribuição leve do Kubernetes, projetada especificamente para ambientes com recursos limitados, como dispositivos IoT e computação em edge. É otimizado para arquiteturas ARM, tornando-o ideal para o Raspberry Pi. O K3s oferece um processo de instalação simplificado, menores requisitos de recursos e integração sem problemas com hardware IoT.

### Instalação para o Trabalho

- A instalação para o trabalho não contemplou mais de um Raspberry, por não haver disponibilidade simultânea de mais de um equipamento.

### Instalação do K3S no Raspian OS

Comando de instalação:

```
$ sudo curl -sfL https://get.k3s.io | sh -
```

Verificando a instalação

```
$ sudo systemctl status k3s
$ sudo kubectl get nodes
```

Se um nó for exibido, então a instalação ocorreu a contento.

### Deploy do broker HiveMQ-CE.

Será instalado o broker HiveMQ-CE, uma versão baseada em java de código aberto que implementa o MQTT 3.x e o MQTT 5.

- Documentação de referência para deploy no Kubernetes: [Best Practices for Operating HiveMQ and MQTT on Kubernetes](https://www.hivemq.com/resources/best-practices-for-operating-hivemq-and-mqtt-on-kubernetes/)

- Roteiro base: [How to deploy MQTT broker to Kubernetes Cluster](https://techblogs.42gears.com/how-to-deploy-mqtt-broker-to-kubernetes-cluster/)

1. Efetuar o deploy do POD do Broker MQTT:

```
$ sudo kubectl apply -f hivemq-deployment.yaml 
```

2. Efetuar o deploy do serviço:

```
$ sudo kubectl apply -f hivemq-service.yaml 
```

3. Efetuar o deploy do metrics-server

```
$ sudo kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

4. Habilitar o HPA para a aplicação

```
$ sudo kubectl autoscale deployment hivemq-broker-depl --cpu-percent=70 --min=1 --max=10

```

5. Verificar se o HPA está funcionando:

```
$ sudo kubectl get hpa hivemq-broker-depl --watch
```

6. Teste manual (a partir de outro computador com Ubuntu instalado)

- Instalar o __mosquitto_clients__:

```
$ sudo apt install mosquitto_clients
```

- Em um terminar efetuar uma subscriação a um tópico (exemplo, __teste/topic__):

```
$ mosquitto_sub -h 192.168.0.17 -p 31883 -t 'teste/topic'
```

- Em outro terminal efetuar a publicação no mesmo tópico:

```
$ mosquitto_pub -d -h 192.168.0.17 -p 31883 -t 'teste/topic' --repeat 10 --repeat-delay .1 -m 'Teste'
```
