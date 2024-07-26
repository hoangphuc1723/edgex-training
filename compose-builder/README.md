## Edgex Docker Compose Builder

This folder contains the `Compose Builder` which is made up of **source** compose, **environment** files and a **makefile** for building the single file docker composes files configured for the `Levski` release
### **Note to Developers**: 
> For a Levski patch release, once you have edited and tested your changes to the source compose files
> and then you MUST regenerate the committed Levski compose files using the `make build` command.
>
> **You must use *docker-compose version 1.27.2* due to bug in later versions that generates the `depends_on` sections incorrectly for compose version 3.x**.
>
> **You MUST NOT use the new `compose v2` as it generates compose files that are not compatible with TAF**

### Compose Tool

The Makefile in this folder expects `docker-compose` tool or the new Compose V2 plug-in for the Docker CLI. The `docker-compose` tool will be used if it is found in the `path`, otherwise it will try the `docker compose` CLI command.

### Generating Custom Compose files
If one of the standard committed Levski compose files doesn't meet your needs, you can generate and run a custom Levski compose file using the make gen <options> command. 
See Gen and Run target details below. The Run target simply runs the custom compose file after generating it.

### Multiple Compose files approach

The approach used with these source compose files is the `Extending using multiple Compose files` described here: https://docs.docker.com/compose/extends/#multiple-compose-files

The `Extending using multiple Compose files` approach along with environment files removes the all of the duplication found in earlier EdgeX compose files. This approach makes running the solution more complicated due to having to list the multiple compose files required to run a particular configuration. To alleviate this complexity we provide generated single file compose files one level up. A `Makefile` has been provided here with commands that make it easy to run one of the multiple possible configurations while testing your changes. See the Makefile section below for details on these commands.

> *Note: The `make run`, `make pull` and `make gen` commands all generate a single `docker-compose.yml` file containing the content from the multiple compose files, environment files with all variables resolved for the specified options used. See below for list of options.*

### Compose Files

This folder contains the following compose files:

- **docker-compose-base.yml**<br/>
  Base non-secure mode compose file. Contains all the services that run in the non-secure configuration, including the UI.  
- **add-security.yml**<br/>
    Security **extending** compose file. Adds the additional security services and configuration of services so that all the services are running in the secure configuration.
- **add-secure-redis-messagebus.yml**<br/>
    Secure Redis MessageBus **extending** compose file. Adds the additional security configuration for when Redis is used as MessageBus in secure mode so Kuiper can connect to the secure MessageBus.
- **add-delayed-start-services.yml**<br/>
    Secure delayed start services **extending** compose file. Adds additional delayed start services based on spire/spiffe implementation to provide the secret store token on the runtime secure configuration.
- **add-device-bacnet.yml**<br/>
    Device Service **extending** compose file, which adds the **Device Bacnet**  service.
- **add-device-camera.yml** (***note this service will be Deprecated, use Device ONVIF Camera***)<br/>
    Device Service **extending** compose file, which adds the **Device Camera**  service.
- **add-device-onvif-camera.yml**<br/>
    Device Service **extending** compose file, which adds the **Device ONVIF Camera**  service.
- **add-device-usb-camera.yml**<br/>
    Device Service **extending** compose file, which adds the **Device USB Camera**  service.
- **add-device-grove.yml**<br/>
    Device Service **extending** compose file, which adds the **Device Grove**  service.
- **add-device-modbus.yml**<br/>
    Device Service **extending** compose file, which adds the **Device Modbus**  service.
- **add-device-mqtt.yml**<br/>
    Device Service **extending** compose file, which adds the **Device MQTT**  service.
- **add-secure-device-mqtt.yml**<br/>
    Device Service **extending** compose file, which adds the **Secure Device MQTT**  service.
- **add-device-rest.yml**<br/>
    Device Service **extending** compose file, which adds the **Device REST** service.
- **add-device-snmp.yml**<br/>
    Device Service **extending** compose file, which adds the **Device SNMP**  service.
- **add-device-virtual.yml**<br/>
    Device Service **extending** compose file, which adds the **Device Virtual**  service.
- **add-device-virtual.yml**<br/>
    Device Service **extending** compose file, which adds the **Device Virtual**  service.
- **add-device-coap.yml**<br/>
    Device Service **extending** compose file, which adds the **Device COAP** service.
- **add-device-gpio.yml**<br/>
    Device Service **extending** compose file, which adds the **Device GPIO**  service.
- **add-device-rfid-llrp.yml**<br/>
    Device Service **extending** compose file, which adds the **Device RFID LLRP**  service.
- **add-asc-http-export.yml**<br/>
    Application Service Configurable **extending** compose file, which adds the **App Service Http Export**  service. Additional configuration required. See [http-export profile](https://docs.edgexfoundry.org/2.2/microservices/application/AppServiceConfigurable/#http-export) for details
- **add-asc-mqtt-export.yml**<br/>
    Application Service Configurable **extending** compose file, which adds the **App Service MQTT Export**  service. Additional configuration required. See [mqtt-export profile](https://docs.edgexfoundry.org/2.2/microservices/application/AppServiceConfigurable/#mqtt-export) for details
- **add-asc-metrics-influxdb.yml**<br/>
    Application Service Configurable **extending** compose file, which adds the **App Service Metrics Infludb**  service.  Additional configuration required. See [metrics-influxdb profile](https://docs.edgexfoundry.org/2.2/microservices/application/AppServiceConfigurable/#metrics-influxdb) for details
- **add-asc-sample.yml**<br/>
    Application Service Configurable **extending** compose file, which adds the **App Service Sample**  service.
- **add-app-rfid-llrp-inventory.yml**<br/>
    Application Service Configurable **extending** compose file, which adds the **App RFID LLRP Inventory**  service.
- **add-asc-external-mqtt-trigger.yml**<br/>
    Application Service Configurable **extending** compose file, which adds the **App Service External MQTT Trigger**  service.
- **add-service-secure-template.yml**<br/>
    A template for a single service **extending** compose file from its base service for security mode,
    and the service is enabled with secret store by default.
- **add-mqtt-messagebus-app-template.yml**<br/>
    A template for a single App service **extending** compose file from its base service for using MQTT as the MessageBus.
- **add-mqtt-messagebus-device-template.yml**<br/>
    A template for a single Device service **extending** compose file from its base service for using MQTT as the MessageBus.
- **add-modbus-simulator.yml**<br/>
    ModBus Simulator **extending** compose file. Adds the MQTT ModBus Simulator service. Must be used in conjunction with  **add-device-modbus.yml**
- **add-mqtt-broker.yml**<br/>
    MQTT Broker **extending** compose file. Adds the Eclipse Mosquitto MQTT Broker.
- **add-secure-mqtt-broker.yml**<br/>
    MQTT Broker **extending** compose file. Adds the Secure Eclipse Mosquitto MQTT Broker.
- **add-mqtt-messagebus.yml**<br/>
    MQTT MesssageBus **extending** compose file. Adds additional configuration of services so that the `MQTT` implementation of the Edgex Message Bus is used. **Must be used in conjunction with add-mqtt-broker.yml**
- **add-secure-mqtt-messagebus.yml**<br/>
    MQTT MesssageBus **extending** compose file. Adds additional configuration of services so that the Secure `MQTT` implementation of the Edgex Message Bus is used. **Must be used in conjunction with add-secure-mqtt-broker.yml**
- **add-nats-messagebus.yml**<br/>
    NATS MesssageBus **extending** compose file. Adds NATS Server and additional configuration of services so that the `NATS` implementation of the Edgex Message Bus is used. 
- **add-nats-messagebus-app-template.yml**<br/>
    A template for a single App service **extending** compose file from its base service for using NATS as the MessageBus.
- **add-nats-messagebus-device-template.yml**<br/>
    A template for a single Device service **extending** compose file from its base service for using NATS as the MessageBus.
- **add-taf-app-services.yml**<br/>
    TAF App Services **extending** compose file. Adds additional App Service for the TAF testing compose files.
- **add-taf-app-services-secure.yml**<br/>
    TAF App Services **extending** `add-taf-app-services` compose file, and services are enabled with secret store by default.
- **add-taf-device-services-mods.yml**<br/>
    TAF Device Services **extending** compose file. Modifies setting of Device Virtual and Device Modbus for the TAF testing compose files. **Must be used in conjunction with add-device-modbus.yml and add-device-virtual.yml**

### Environment Files

This folder contains the following environment files:

- **.env**
    This file contains the `version`, `repositories` and image `version` variables referenced in compose files. Docker compose implicitly uses the `.env` file, if it exists, so you will not see it referenced in the compose files. It is referenced in the Makefile so that it can also use these settings.

- **common.env**
    This file contains the common environment overrides used by all Edgex services.

- **common-security.env**
    This file contains the common security related environment overrides used by many Edgex services.

- **common-sec-stage-gate.env**
    This file contains the common security-bootstrapper stage gate related environment overrides used by many Edgex services.

- **asc-common.env**
    This file contains the common environment overrides used by all Application Services

- **asc-http-export.env**
    This file contains the common environment overrides used by all App Service Configurable instances using the `http-export` profile

- **asc-mqtt-export.env**
    This file contains the common environment overrides used by all App Service Configurable instances using the `mqtt-export` profile

- **mqtt-bus.env**
    This file contains the common MQTT related environment overrides used by many Edgex services when using MQTT as the MessageBus.

- **nats-bus.env**
    This file contains the common NATS related environment overrides used by many Edgex services when using NATS as the MessageBus.

    

### TUI (terminal UI)

Compose builder now has the TUI Generator tool that provides menus to select the options described in the [Makefile](#makefile) section below for generation and running of custom compose files. To use this tool simply run `./tui-generator.sh` in a Linux terminal from the `compose-builder` folder.

### Makefile

This folder contains a `Makefile` that provides commands for building, running, stopping,  generating, cleaning, etc. for the various EdgeX configurations. It is used during **development** of the compose files or generating DEV version for testing service changes.  See the [Gen](#gen) command below for more details on options available to use when generating compose files.

```
Usage: make <target> where target is:
```
#### Portainer

```
portainer       Runs Portainer independent of the EdgeX services
portainer-down	Stops Portainer independent of the EdgeX services
```
#### Build

```
build
Generates the all standard Edgex compose file variations and the TAF testing compose files. The generated compose files are stored in the top level folder. Each variation of standard compose files includes the Device REST & Device Virtual . Compose files are named appropriately for options used to generate them. TAF compose files are store in the 'taf' sub-folder

Standard compose variations are:
   full secure (docker-compose.yml)
   full secure for amd64 (docker-compose-amd64.yml)
   full secure with app-sample (docker-compose-with-app-sample.yml)
   full secure with app-sample for amd64 (docker-compose-with-app-sample-amd64.yml)
   non-secure (docker-compose-no-secty.yml)
   non-secure for amd64 (docker-compose-no-secty-amd64.yml)
   non-secure with app-sample (docker-compose-no-secty-with-app-sample.yml)
   non-secure with app-sample for amd64 (docker-compose-no-secty-with-app-sample-amd64.yml)

 TAF compose variations are:
   full secure general testing (docker-compose-taf.yml)
   full secure general testing for amd64 (docker-compose-taf-amd64.yml)
   non-secure general testing (docker-compose-taf-no-secty.yml)
   nonsecure general testing for amd64 (docker-compose-taf-no-secty-amd64.yml)
   full secure perf testing (docker-compose-taf-perf.yml)
   full secure perf testing for amd64 (docker-compose-taf-perf-amd64.yml)
   non-secure perf testing (docker-compose-taf-perf-no-secty.yml)
   nonsecure perf testing for amd64 (docker-compose-taf-perf-no-secty-amd64.yml)
```
#### Run

```
run [options] [services]
Runs the EdgeX services as specified by:
Options:
    no-secty:        Runs in Non-Secure Mode, otherwise runs in Secure Mode
    amd64:           Runs using amd64 images
    dev:             Runs using local built images from edgex-go repo
                     'make docker' creates local docker images tagged with '0.0.0-dev'
    app-dev:         Runs using local built images from application service repos
                     'make docker' creates local docker images tagged with '0.0.0-dev`
    device-dev:      Runs using local built images from device service repos
                     'make docker' creates local docker images tagged with '0.0.0-dev'
    ui-dev:          Runs using local built images from edgex-ui-go repo
                     'make docker' creates local docker image tagged with '0.0.0-dev'
    delayed-start:   Runs with delayed start services- 
                     spire related services and spiffe-token-provider service included
    ds-modbus:       Runs with device-modbus included
    ds-bacnet:       Runs with device-bacnet included
    ds-camera:       Runs with device-camera included
    ds-onvif-camera: Runs with device-onvif-camera included
    ds-usb-camera:   Runs with device-usb-camera included
    ds-grove:        Runs with device-grove included (valid only with amd64 option)
    ds-mqtt:         Runs with device-mqtt included
    ds-rest:         Runs with device-rest included
    ds-snmp:         Runs with device-snmp included
    ds-virtual:      Runs with device-virtual included
    ds-coap:         Runs with device-coap included
    ds-gpio:         Runs with device-gpio included
    ds-llrp:         Runs with device-rfid-llrp included
    modbus-sim:      Runs with ModBus simulator included
    asc-http:        Runs with App Service HTTP Export included
    asc-mqtt:        Runs with App Service MQTT Export included
    asc-metrics:     Runs with App Service Metrics InfluxDb included
    asc-sample:      Runs with App Service Sample included
    as-llrp:         Runs with App RFID LLRP Inventory included
    asc-ex-mqtt:     Runs with App Service External MQTT Trigger included
    mqtt-broker:     Runs with a MQTT Broker service included
    mqtt-bus:        Runs with services configure for MQTT Message Bus
                     The MQTT Broker service is also included.
    nats-bus:        Runs with services configure for NATS Message Bus
                     The NATS Server service is also included.
    zmq-bus:         Runs with services configure for ZMQ Message Bus

Services:
    <names...>: Runs only services listed (and their dependent services) where 'name' matches a service name in one of the compose files used
```
#### Up

```
up
Start all Edgex services using the docker-compose.yml file resulting from last time "make gen" was run. Use this command when the docker-compose.yml file has been modified after generating it. This command Will result in error if the docker-compose.yml file doesn't exist.
```

#### Down

```    
down
Stops all EdgeX services no matter which configuration started them
```

#### Pull

```				
pull [options] [services]
Pulls the EdgeX service images as specified by:
Options:
    no-secty:        Pulls images for Non-Secure Mode, otherwise pull images 
                     for Secure Mode
    amd64:           Pulls amd64 version of images
    delayed-start:   Pull includes delayed start services- spire related services 
                     and spiffe-token-provider service
    ds-bacnet:       Pull includes device-bacnet
    ds-camera:       Pull includes device-camera
    ds-onvif-camera: Pull includes device-onvif-camera included
    ds-usb-camera:   Pull includes device-usb-camera included
    ds-grove:        Pull includes device-grove (valid only with amd64 option)
    ds-modbus:       Pull includes device-modbus
    ds-mqtt:         Pull includes device-mqtt
    ds-rest:         Pull includes device-rest
    ds-snmp:         Pull includes device-snmp
    ds-virtual:      Pull includes device-virtual
    ds-coap:         Pull includes device-coap
    ds-gpio:         Pull includes device-gpio
    ds-llrp:         Pull includes device-rfid-llrp
    modbus-sim:      Pull includes ModBus simulator
    asc-http:        Pull includes App Service HTTP Export
    asc-mqtt:        Pull includes App Service MQTT Export
    asc-metrics:     Pull includes App Service Metrics InfluxDb included
    asc-sample:      Pull includes App Service Sample
    as-llrp:         Pull includes App RFID LLRP Inventory
    asc-ex-mqtt:     Pull includes App Service External MQTT Trigger
    mqtt-broker:     Pull includes MQTT Broker service
    mqtt-bus:        Pull includes additional services for MQTT Message Bus
    nats-bus:        Pull includes additional services for NATS Message Bus
    zmq-bus:         Pull includes additional services for ZMQ Message Bus

Services:
    <names...>: Pulls only images for the service(s) listed
```
#### Gen

```	
gen [options]
Generates temporary single file compose file (`docker-compose.yml`) as specified by:
Options:
    no-secty:        Generates non-secure compose,
                     otherwise generates secure compose file
    amd64:           Generates compose file using amd64 images
    dev:             Generates using local built images from edgex-go repo
                     'make docker' creates local docker images tagged with '0.0.0-dev'
    app-dev:         Generates using local built images from application service repos
                     'make docker' creates local docker images tagged with '0.0.0-dev`
    device-dev:      Generates using local built images from device service repos
                     'make docker' creates local docker images tagged with '0.0.0-dev'
    ui-dev:          Generates using local built images from edgex-ui-go repo
                     'make docker' creates local docker image tagged with '0.0.0-dev'
    delayed-start:   Generates compose file with delayed start services- spire 
                     related services and spiffe-token-provider service included
    ds-modbus:       Generates compose file with device-modbus included
    ds-bacnet:       Generates compose file with device-bacnet included
    ds-camera:       Generates compose file with device-camera included
    ds-onvif-camera: Generates compose file with device-onvif-camera included
    ds-usb-camera:   Generates compose file with device-usb-camera included
    ds-grove:        Generates compose file with device-grove included (valid only with amd64 option)
    ds-mqtt:         Generates compose file with device-mqtt included
    ds-rest:         Generates compose file with device-rest included
    ds-snmp:         Generates compose file with device-snmp included
    ds-virtual:      Generates compose file with device-virtual included
    ds-coap:         Generates compose file with device-coap included
    ds-gpio:         Generates compose file with device-gpio included
    ds-llrp:         Generates compose file with device-rfid-llrp included
    modbus-sim:      Generates compose file with ModBus simulator included
    asc-http:        Generates compose file with App Service HTTP Export included
    asc-mqtt:        Generates compose file with App Service MQTT Export included
    asc-metrics:     Generates compose file with App Service Metrics InfluxDb included
    asc-sample:      Generates compose file with App Service Sample included
    as-llrp:         Generates compose file with App RFID LLRP Inventory included
    asc-ex-mqtt:     Generates compose file with App Service External MQTT Trigger included
    mqtt-broker:     Generates compose file with a MQTT Broker service included
    mqtt-bus:        Generates compose file with services configured for MQTT Message Bus
                     The MQTT Broker service is also included.
    nats-bus:        Generates compose file with services configured for NAT Message Bus
                     The NATS Server service is also included.
    zmq-bus:         Generates compose file with services configured for ZMQ Message Bus
```
#### Clean

```
clean
Runs 'down' and removes all stopped containers, all volumes and all networks used by the EdgeX stack. Use this command when needing to do a fresh restart.
```

#### Get-token

```
get-token [options] 
Generates a Kong access token as specified by:
Options:
    amd64:  Generates a Kong access token using amd64 image
    dev:    Generates a Kong access token using local dev built docker image
            'make docker' creates local docker images tagged with '0.0.0-dev'    
```
#### Upload-tls-cert

```
upload-tls-cert [options] <environment_variables>
Upload a bring-your-own (BYO) TLS certificate to the Kong proxy server as specified by:
Options:
    amd64:  Upload TLS certificate to the Kong server using amd64 image
    dev:    Upload TLS certificate to the Kong server using local dev built docker image
            'make docker' creates local docker images tagged with '0.0.0-dev'    
    Environment Variables: 
    CERT_INPUT_FILE=<full_path_to_cert_file>: the full file name path to your own certificate file, this is required
    KEY_INPUT_FILE=<full_path_to_key_file>: the full file name path to your own key file, this is required
    EXTRA_SNIS="comma_separated_server_name_list_if_any": an extra server name indicator list in addition to localhost and kong, this is optional and can be omitted
```

#### Get-consul-acl-token

```
get-consul-acl-token 
Retrieves the Consul ACL token
```

#### Compose

```
compose [options] 
Generates the EdgeX compose file as specified by options and stores them in the configured release folder. Compose files are named appropriately for release and options used to generate them.

Options:
    no-secty:      Generates non-secure compose file, otherwise generates secure compose file
    amd64:         Generates compose file using amd64 images
    dev:           Generates using local built images from edgex-go repo
                   'make docker' creates local docker images tagged with '0.0.0-dev'
    app-dev:       Generates using local built images from application service repos
                   'make docker' creates local docker images tagged with '0.0.0-dev`
    device-dev:    Generates using local built images from device service repos
                   'make docker' creates local docker images tagged with '0.0.0-dev'
    ui-dev:        Generates using local built images from edgex-ui-go repo
                   'make docker' creates local docker image tagged with '0.0.0-dev'
    delayed-start: Generates compose file with delayed start services- spire related services and
                   spiffe-token-provider service included
    ds-bacnet:     Generates compose file with device-bacnet included
    ds-camera:     Generates compose file with device-camera included
    ds-grove:      Generates compose file with device-grove included (valid only with amd64 option)
    ds-modbus:     Generates compose file with device-modbus included
    ds-mqtt:       Generates compose file with device-mqtt included
    ds-rest:       Generates compose file with device-rest included
    ds-snmp:       Generates compose file with device-snmp included
    ds-virtual:    Generates compose file with device-virtual included
    ds-coap:       Generates compose file with device-coap included
    ds-gpio:       Generates compose file with device-gpio included
    ds-llrp:       Generates compose file with device-rfid-llrp included
    modbus-sim:    Generates compose file with ModBus simulator included
    asc-http:      Generates compose file with App Service HTTP Export included
    asc-mqtt:      Generates compose file with App Service MQTT Export included
    asc-metrics:   Generates compose file with App Service Metrics InfluxDb included
    asc-sample:    Generates compose file with App Service Sample included
    as-llrp:       Generates compose file with App RFID LLRP Inventory included
    asc-ex-mqtt:   Generates compose file with App Service External MQTT Trigger included
    mqtt-broker:   Generates compose file with a MQTT Broker service included
    mqtt-bus:      Generates compose file with services configure for MQTT Message Bus
                   The MQTT Broker service is also included.
    nats-bus:      Generates compose file with services configure for NATS Message Bus
                   The NATS Server service is also included.
    zmq-bus:       Generates compose file with services configured for ZMQ Message Bus
```

#### Taf-compose

```
taf-compose [options] 
Generates a TAF general testing compose file as specified by options and stores them in the configured TAF folder. Compose files are named appropriately for the options used to generate them.

Options:
    taf-secty:	  Generates general TAF testing compose file with security services
    taf-no-secty: Generates general TAF testing compose file without security services
    amd64:        Generates TAF compose file using amd64 images
```

#### Taf-perf-compose

```
taf-perf-compose [options] 
Generates a TAF performance testing compose file as specified by options and stores them in the configured TAF folder. Compose files are named appropriately for the options used to generate them.

Options:
    taf-secty:	  Generates performance TAF testing compose file with security services
    taf-no-secty: Generates performance TAF testing compose file without security services
    amd64:        Generates TAF compose file using amd64 images
```
