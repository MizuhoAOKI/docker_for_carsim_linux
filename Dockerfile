# Last update: 2021.09.02, developed by Mizuho Aoki @ Suzlab

# Base image
FROM ubuntu:18.04 as ubunt1804image

# Environment variables : 
ENV DEBIAN_FRONTEND=noninteractive

# Get packages to develop c++ programs
RUN apt-get update && \
    apt-get install -y sudo git build-essential cmake tree sudo vim

RUN mkdir workspace

# Add sudo user "normaluser"
RUN groupadd -g 1000 developer && \
    useradd  -g      developer -G sudo -m -s /bin/bash normaluser && \
    echo 'normaluser:normaluser' | chpasswd
RUN echo 'Defaults visiblepw'             >> /etc/sudoers
RUN echo 'normaluser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER normaluser

# Copy setting files :
COPY ./settings/* /home/normaluser/

# Set region to jp
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja





# Give permission to execute shell scripts
# RUN chmod 777 -R /carsim 

# Install Carsim
# ENTRYPOINT /carsim/setup_shells/carsim_install.sh
CMD /carsim/setup_shells/carsim_install.sh
# CMD bash -c "/bin/bash & /carsim/setup_shells/carsim_install.sh"
# thread 1 : main process to use. 
    # It launches bash as normaluser.
# thread 2 : background process
    # It keeps carsim license manager after it runs carsim_install.sh.