#!/bin/bash

echo -e "192.168.56.110 app1.com" | sudo tee -a /etc/hosts
echo -e "192.168.56.110 app2.com" | sudo tee -a /etc/hosts
echo -e "192.168.56.110 app3.com" | sudo tee -a /etc/hosts

cat /etc/hosts