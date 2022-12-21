# IoT data collection stack

This project is using docker-compose to automate the creation of stack necessary to receive, process, store and visualize data
received from distributed IoT weather devices [more here](https://github.com/Beraton/esp_weather). 

Stack can be used to collect any data measured by the devices (you only need to change the telegraf.conf and mosquitto.conf file)

Project also contains special script `gen_client_ssl_cert.sh` which creates SSL certificates used by clients to authenticate to Telegraf. 

### Setup

In order to use this project, you need to configure `telegraf.conf`:
- enable/disable SSL requirement
- entire [[inputs.mqtt_consumer]] input section
- [[outputs.influxdb_v2]] URL, organization, bucket and token (configure [[outputs.influxdb]] if using InfluxDB <2.0)

`mosquitto.conf`:
- enable/disable SSL requirement
- root CA certificate path
- MQTT server certificate path
- MQTT server ports that are listening/subscribing to incoming topics

To setup Docker you will need to create:
- **MQTT volume** that is used by telegraf and mosquitto container (mainly store configuration files and shared SSL certificates)
- **Influx volume** that is used by influx container (all data received from telegraf will be saved in this volume)

### .envrc file

Personally I use `direnv` shell extension to load environment variables locally inside current directory
In my case `.envrc` loads information from **gopass** but you can set those environment variables directly in `.envrc` file




