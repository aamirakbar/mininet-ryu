# Mininet with RYU SDN Controller Docker Environment

This Docker image provides a Mininet simulation environment integrated with the RYU SDN controller. It allows you to easily set up and run network simulations using Mininet and manage them with RYU.

## Pull the Docker Image

To pull the Docker image from DockerHub, use the following command:

```sh
sudo docker pull 601199/mininet-ryu
```

## Running the Docker Container
To run the Docker container, use the following command:

```sh
sudo docker run -it --rm --privileged -e DISPLAY \
             -v /tmp/.X11-unix:/tmp/.X11-unix \
             -v /lib/modules:/lib/modules \
             -v /[path-to-files]:/home \
             601199/mininet-ryu
```

In the above command:

- --rm: Automatically remove the container when it exits.
- --privileged: Grants extended privileges to the container.
- -e DISPLAY: Passes the DISPLAY environment variable for GUI applications.
- -v /tmp/.X11-unix:/tmp/.X11-unix: Shares the host's X11 display server with the container.
- -v /lib/modules:/lib/modules: Shares the host's kernel modules with the container.
- -v /[path-to-files]:/home: Maps the specified host directory to the /home directory in the container. This directory can include your Mininet topology custom files and RYU controller app files.

## Running the RYU Controller
Inside the Docker container, navigate to the RYU directory and start the RYU controller with the following commands:

```sh
cd ryu
PYTHONPATH=. ./bin/ryu-manager ryu.app.simple_switch_13
```

This command starts the default simple_switch_13 application. If you have a custom controller file, you can copy it to the RYU app directory and then run it:

```sh
cp /home/my_controller.py /root/ryu/ryu/app
PYTHONPATH=. ./bin/ryu-manager ryu.app.my_controller
```

## Accessing the Running Docker Container
To open another shell in the running Docker container:

1. In your host OS, list the running Docker containers to get the container ID:

```sh
sudo docker ps
```

2. Use the container ID to open a new shell in the running container:

```sh
sudo docker exec -it <container-id> bash
```

## Running a Mininet Custom Topology

In the new Docker shell, navigate to the directory containing your Mininet custom topology file and run it:

```sh
cd /home/
mn --custom my_topo.py
```

## Conclusion

By following these steps, you can:

1. Pull the Docker image: Get the pre-built Docker image from DockerHub.
2. Run the Docker container: Start the container with the necessary permissions and folder mappings.
3. Run the RYU controller: Start the default or custom RYU applications.
4. Access the running container: Open additional shells in the container to run more commands.
5. Run Mininet topologies: Execute your custom Mininet topology files within the Docker container.
6. This setup simplifies the process of running network simulations using Mininet and managing them with the RYU controller. Enjoy your network simulation environment!
