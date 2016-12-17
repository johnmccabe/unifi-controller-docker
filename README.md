# Running
```
docker run -d -p 8080:8080 \
              -p 8443:8443 \
              -p 8880:8880 \
              -p 3478:3478 \
              -v /local_data/unifi_docker:/usr/lib/unifi/data \
              --name unifi \
              johnmccabe/unifi-controller
```

# Configuration
## Ports
| Port | Name | Description |
| ---- | ---- | ----------- |
| 3478/udp | `unifi.stun.port`| STUN |
| 8080/tcp | `unifi.http.port`| device inform |
| 8443/tcp | `unifi.https.port`| controller UI/API |
| 8880/tcp | `portal.http.port`| guest portal |

see - https://help.ubnt.com/hc/en-us/articles/204910084-UniFi-Change-Default-Ports-for-Controller-and-UAPs

## Directories
| Directory | Description |
| --------- | ----------- |
| /usr/lib/unifi/data | Configuration |
