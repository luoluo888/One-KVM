#!/bin/bash

echo  "One-KVM pre-starting..."

if [ "$OTG" == "1" ]; then
    echo "OTG is enabled."
    
    if [ ! -f /etc/kvmd/.otg_flag ]; then
        echo "Enable One-KVM otg config."
        touch /etc/kvmd/.otg_flag
        sed -i "s/ch9329/otg/g" /etc/kvmd/override.yaml
	    sed -i "s/device: \/dev\/ttyUSB0//g" /etc/kvmd/override.yaml
        cat >> /etc/kvmd/supervisord.conf << EOF

[program:kvmd-otg]
command=python -m kvmd.apps.otg start
directory=/
autostart=true
autorestart=unexpected
priority=9
stopasgroup=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes = 0
redirect_stderr=true
EOF
    fi
    if [ -d /sys/kernel/config/usb_gadget/kvmd ]; then
        echo "Usb_gadget kvmd exists,delete it."
        python -m kvmd.apps.otg stop
    fi
fi