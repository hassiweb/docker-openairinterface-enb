# docker-openairinterface-enb

A Docker recipe of OpenAirInterface eNB for [LimeSDR](https://limemicro.com/products/boards/limesdr/) and [LimeSDR mini](https://limemicro.com/products/boards/limesdr-mini/)

## Testing Environment

- Host machine
  - OS: Ubuntu 16.04 (Kernel version: 4.15.0-74-generic)
  - CPU: Intel Core i7-7700T (2.9 GHz 4 cores)
  - [Power management settings](https://gitlab.eurecom.fr/oai/openairinterface5g/wikis/OpenAirKernelMainSetup#power-management)
- Software
  - Docker v18.06.3-ce
  - docker-compose v1.24.1
- SDR board
  - [LimeSDR mini](https://limemicro.com/products/boards/limesdr-mini/)

## Usage
### Single Node eNB

1. Create a Docker image of OpenAirInterface eNB for LimeSDR, and take a coffee break. It will take several tens of minutes.
```
   sh build.sh enb
```

2. Run the single eNB container.
```
   docker-compose -f docker-compose.enb.lmssdr.yml up
```

Change `config/run_enb.sh` if you want to use specific options or configuration files.

Reference: [options of `lte-softmodem`](https://gitlab.eurecom.fr/oai/openairinterface5g/blob/v1.0.3/common/config/DOC/config/rtusage.md)

### Single Node eNB with T-Tracer GUI
1. Create a Docker image (the Same as above).

2. Run X11 server on the remote cliant machine or the local machine.

3. If you want to show the T-Tracer GUI onto the remote cliant machine, modify host name (or IP address) of the environment variable `DISPLAY` in `docker-compose.enb.lmssdr.gui.yml`.

4. Run the single eNB container with T-Tracer GUI.
```
  docker-compose -f docker-compose.enb.lmssdr.gui.yaml up
```

### RCC-RRU split architecture

1. Create the images for [the RCC-RRU split architecture using the NGFI interface](https://gitlab.eurecom.fr/oai/openairinterface5g/wikis/how-to-connect-cots-ue-to-oai-enb-via-ngfi-rru).
```
   sh build.sh split
```

2. Run the containers for RCC and RRU.
```
   docker-compose -f docker-compose.rcc-rru.if4p5.yml up
```

Change `config/run_rcc_if4p5.sh`, and/or `config/run_rru_if4p5.sh` if you want to use specific options or configuration files.



## Note

Transmitting radio waves is restricted by the law in some countries without permission or the license.  Please follow regulations in your country of residence.


## License

MIT

