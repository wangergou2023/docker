docker run -d --name="hass" -e "TZ=Asia/Shanghai" -v /data/hass:/config -p 8123:8123 homeassistant/home-assistant:latest
