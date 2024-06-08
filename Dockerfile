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
    

# Expose Mininet and RYU ports
EXPOSE 6633 6653 6640

# Start the services
ENTRYPOINT ["/ENTRYPOINT.sh"]
