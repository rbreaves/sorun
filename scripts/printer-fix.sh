#!/usr/bin/env bash

sudo sed -i 's/BrowseRemoteProtocols dnssd cups/BrowseRemoteProtocols cups/g' /etc/cups/cups-browsed.conf
service cups restart