#!/bin/bash

# This is a shell script for installing carsim software on ubuntu.
LOG_OUT=/workspace/carsim_install.log
echo "carsim_install.sh started." | tee $LOG_OUT;

# Expand carsim installer
echo "Unpacking Carsim..." | tee -a $LOG_OUT;
tar -zxvf /carsim/CarSim_*.tar.gz -C /workspace;

# Run installer.sh
echo "Installing Carsim..." | tee -a $LOG_OUT;
cd /workspace/CarSim_*/Installer/;
/bin/sh ./install.sh;

# Set config files:
echo "Copy config files" | tee -a $LOG_OUT;
cp /carsim/config/* /home/normaluser/.config/mechsim;
cp /carsim/setup_shells/carsim_example_run.sh /workspace/carsim_example_run.sh

# Launch carsim license manager in the background
echo "Launching carsim license manager..." | tee -a $LOG_OUT;
cs-lm-cli

# Wait forever
while : ; do sleep 1; done

# Overrides default command so things don't shut down after the process ends.
# /bin/sh -c "while sleep 1000; do :; done"