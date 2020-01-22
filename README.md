# docker-openairinterface-enb

A Docker recipe of OpenAirInterface eNB for LimeSDR and [LimeSDR mini](https://limemicro.com/products/boards/limesdr-mini/)


## Tested Environment

- Host machine
  - OS: Ubuntu 16.04 (Kernel version: 4.15.0-74-generic)
  - CPU: Intel Core i7-7700T (2.9 GHz 4 cores)
  - [Power management settings](https://gitlab.eurecom.fr/oai/openairinterface5g/wikis/OpenAirKernelMainSetup#power-management)
- Software
  - Docker v18.06.3-ce
  - docker-compose v1.24.1
- SDR board
  - [LimeSDR mini](https://limemicro.com/products/boards/limesdr-mini/)


## Target Software

Tested version: [OpenAirInterface v1.0.3](https://gitlab.eurecom.fr/oai/openairinterface5g/tree/v1.0.3)


## Usage

1. Create the image of OpenAirInterface eNB for LimeSDR, and take a coffee break.  It will take several tens of minutes.

```
docker build -t oai-lms .
```

2. Run the eNB container.

```
docker-compose run oaienb
```

  All [`lte-softmodem` options](https://gitlab.eurecom.fr/oai/openairinterface5g/blob/v1.0.3/common/config/DOC/config/rtusage.md) are available when running the eNB container as follows.

```
docker-compose run oaienb -O /config/enb.band1.tm1.25PRB.lmssdr.conf --rf-config-file /root/trx-lms7002m/config-limeSDR/LimeSDR_Mini_above_1p8GHz.ini
```

3. Modify iptables to forward GTP (UDP) packets from S-GW to the eNB container. 

```
sh forward_s1_to_enb.sh start
```

## Note

Transmitting radio waves is restricted by the law in some countries without permission or the license.  Please follow regulations in your country of residence.


## License

MIT

