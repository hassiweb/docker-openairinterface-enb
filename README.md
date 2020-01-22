
# docker-openairinterface-enb

A Docker recipe of OpenAirInterface eNB for LimeSDR and LimeSDR mini


## Tested Environment
- Host machine
    - OS: Ubuntu 16.04 (Kernel version: 4.15.0-74-generic)
    - CPU: Intel Core i7-7700T (2.9 GHz 4 cores)
    - Power management settings
- Software
    - Docker v18.06.3-ce
    - docker-compose v1.24.1
- SDR board
    - LimeSDR mini


## Target Software

Tested version: OpenAirInterface v1.0.3


## Usage

Create an image of OpenAirInterface eNB for LimeSDR, and take a coffee break.  It will take several tens of minutes.

    docker build -t oai-lms .

Run the eNB container.

    docker-compose run oaienb

Modify iptables to forward GTP (UDP) packets from S-GW to the eNB container. 

    sh forward_s1_to_enb.sh start


## Note

Transmitting radio waves is restricted by the law in some countries without permission or the license.  Please follow regulations in your country of residence.


## License

MIT
