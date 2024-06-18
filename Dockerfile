# Use a base image with Ubuntu 20.04.3 LTS
FROM ubuntu:20.04

# Set the working directory inside the container
WORKDIR /root

COPY ENTRYPOINT.sh /

# Update the package lists and install necessary packages
RUN apt-get update && \
    apt-get install -y \
        software-properties-common \
        && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
        python3.8 \
        python3-pip \
        git \
        vim \
        iputils-ping \
        tcpdump \
        net-tools \
        iproute2 \
        curl \
        dnsutils \
        ifupdown \
        iproute2 \
        iptables \
        mininet \
        openvswitch-switch \
        openvswitch-testcontroller \
        vim \
        x11-xserver-utils \
        xterm \
        quagga \
    && rm -rf /var/lib/apt/lists/* \
    && touch /etc/network/interfaces \
    && chmod +x /ENTRYPOINT.sh \
    && apt-get clean

# Install networkx using pip3
RUN pip3 install networkx

# Create the /root/ryu directory
RUN mkdir -p ryu

# Copy the local ryu directory to the /root/ryu directory in the container
COPY ryu ./ryu

# Verify the contents of the /root/ryu directory
RUN ls -la /root/ryu

# Create a symbolic link for python3.8
RUN ln -s /usr/bin/python3.8 /usr/bin/python

RUN pip install -r /root/ryu/tools/pip-requires \
        -r /root/ryu/tools/test-requires \
        -r /root/ryu/tools/optional-requires


# Install pip2 and then install requests using pip2
# Install pip2
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && \
    python2 get-pip.py && \
    rm get-pip.py

RUN pip2 install requests


# Enable IP forwarding
RUN echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf && \
    sysctl -p

# Set up Quagga configuration
COPY zebra.conf /etc/quagga/zebra.conf
COPY bgpd.conf /etc/quagga/bgpd.conf 

# Ensure that the /var/log/quagga directory exists and create the log files with appropriate permissions.
RUN mkdir -p /var/log/quagga && \
    touch /var/log/quagga/zebra.log && \
    touch /var/log/quagga/bgpd.log && \
    chmod 640 /var/log/quagga/*.log && \
    chown quagga:quagga /var/log/quagga/*.log

# Expose Mininet and RYU ports
EXPOSE 6633 6653 6640

# Start the services
ENTRYPOINT ["/ENTRYPOINT.sh"]

