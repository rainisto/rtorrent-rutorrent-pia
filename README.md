# rtorrent-rutorrent-pia
Running rtorrent behind gluetun with PIA. Automatically edits forward port details to config file. With noVNC firefox browser you can keep everything inside VPN 
environment without contaminating your normal internet usage.

# to run create .env file with following details:
PIA_USER=pia_username    
PIA_PASS=pia_pass    
VPN_REGION=vpn region for example "Estonia"    
RU_USERNAME=username    
RU_PASSWORD=password    
VNC_PW=password    


# and then start docker-compose and port forwarding logic with:
sudo ./run.sh    
