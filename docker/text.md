



## What are virtual machines and virtualization?
Before containers came along, the “virtual machine” was the technology of choice for optimizing server capacity. Programmed to emulate the hardware of a physical computer with a complete operating system, VMs (and hypervisors) make it possible to run what appear to be multiple computers with multiple different operating systems on the hardware of a single physical server.


## What is a hypervisor?
Virtualization is not possible without the hypervisor. A hypervisor, or virtual machine monitor, is the software that enables multiple operating systems to run side-by-side, all with access to the same physical server resources. The hypervisor orchestrates and separates the available resources (computing power, memory, storage, etc.), aligning a portion to each virtual machine as needed.

The main difference between Type 1 vs. Type 2 hypervisors is that Type 1 runs on bare metal and Type 2 runs atop an operating system. Each hypervisor type also has its own pros and cons and specific use cases.


## What are the advantages and disadvantages of virtual machines?
- You can virtually spin up multiple different OSs using a single physical machine
- You can manage and allocate resources and limits to VMs
- Since each VM includes an OS and a virtual copy of all the hardware the OS requires, VMs require significant RAM and CPU resources
- Moving VMs between public clouds, private clouds and traditional data centers can be challenging


## What are containers and containerization?
The container shares the kernel of the host OS with other containers, and the shared part of the OS is read-only. Therefore, the containers are lightweight, so you can deploy multiple containers on a single server (or a VM)—no more dedicating an entire server (or a VM) to a single application, allowing you to isolate multiple different applications from each other which will bring more and more benefits, like security benefits and managing different dependencies of applications separately. And, you only have one OS to maintain. Scaling up becomes fast and easy, without the need for more server space.


## But, as with virtual machines, containers have their disadvantages: 
- Because the OS is shared, a security vulnerability in the OS kernel is a threat to all containers on the host machine.
- Containerization is still a new solution with wide variances in implementation plans and skilled resources, making adoption a challenging process for some


## Virtualization vs. Containerization: What’s the right path for you? 
Virtualization enables you to run multiple operating systems on the hardware of a single physical server, while containerization enables you to deploy multiple applications using the same operating system on a single virtual machine or server.

![virtualization-vs-containerization](virtualization-vs-containerization.jpg)


## Docker Main Concepts
- Docker Engine
- Docker Build
- Docker Run
- Docker Compose
- Docker Hub


## Docker Engine overview
Docker Engine is an open source containerization technology for building and containerizing your applications. Docker Engine acts as a client-server application with:

- A server with a long-running daemon process dockerd.
- APIs which specify interfaces that programs can use to talk to and instruct the Docker daemon.
- A command line interface (CLI) client docker.
The CLI uses Docker APIs to control or interact with the Docker daemon through scripting or direct CLI commands. Many other Docker applications use the underlying API and CLI. The daemon creates and manages Docker objects, such as images, containers, networks, and volumes.

- https://docs.docker.com/engine/storage/
- https://docs.docker.com/engine/network/
- https://docs.docker.com/engine/logging/
- https://docs.docker.com/engine/manage-resources/pruning/

### Storage
By default all files created inside a container are stored on a writable container layer. This means that the data doesn't persist when that container no longer exists, and it can be difficult to get the data out of the container if another process needs it.

Docker has two options for containers to store files on the host machine, so that the files are persisted even after the container stops: volumes, and bind mounts.
No matter which type of mount you choose to use, the data looks the same from within the container. It is exposed as either a directory or an individual file in the container's filesystem.
Volumes are stored in a part of the host filesystem which is managed by Docker (/var/lib/docker/volumes/ on Linux).
Bind mounts may be stored anywhere on the host system. They may even be important system files or directories. Non-Docker processes on the Docker host or a Docker container can modify them at any time.
Volumes are created and managed by Docker. You can create a volume explicitly using the docker volume create command, or Docker can create a volume during container or service creation.
Bind mounts have limited functionality compared to volumes. When you use a bind mount, a file or directory on the host machine is mounted into a container. The file or directory is referenced by its full path on the host machine.

### Networking
Container networking refers to the ability for containers to connect to and communicate with each other, or to non-Docker workloads.
Containers have networking enabled by default, and they can make outgoing connections. A container has no information about what kind of network it's attached to, or whether their peers are also Docker workloads or not. A container only sees a network interface with an IP address, a gateway, a routing table, DNS services, and other networking details.
You can create custom, user-defined networks, and connect multiple containers to the same network. Once connected to a user-defined network, containers can communicate with each other using container IP addresses or container names.

docker network create -d bridge my-net
docker run --network=my-net -it --name=container3 busybox

By default, when you create or run a container using docker create or docker run, containers on bridge networks don't expose any ports to the outside world. Use the --publish or -p flag to make a port available to services outside the bridge network. This creates a firewall rule in the host, mapping a container port to a port on the Docker host to the outside world.

Containers use the same DNS servers as the host by default, but you can override this with `--dns`

### Container Logs
The `docker logs` command shows information logged by a running container.
Unix and Linux commands typically open three I/O streams when they run, called `STDIN`, `STDOUT`, and `STDERR`. `STDIN` is the command's input stream, which may include input from the keyboard or input from another command. `STDOUT` is usually a command's normal output, and `STDERR` is typically used to output error messages. By default, docker logs shows the command's `STDOUT` and `STDERR`.

### Prune unused Docker objects
Docker takes a conservative approach to cleaning up unused objects (often referred to as "garbage collection"), such as images, containers, volumes, and networks.
These objects are generally not removed unless you explicitly ask Docker to do so. This can cause Docker to use extra disk space. For each type of object, Docker provides a `prune` command. In addition, you can use `docker system prune` to clean up multiple types of objects at once.

The `docker image prune` command allows you to clean up unused images. By default, this command only cleans up dangling images. A dangling image is one that isn't tagged, and isn't referenced by any container.

When you stop a container, it isn't automatically removed unless you started it with the `--rm` flag.
To see all containers on the Docker host, including stopped containers, use `docker ps -a`.
A stopped container's writable layers still take up disk space. To clean this up, you can use the `docker container prune` command.

Volumes can be used by one or more containers, and take up space on the Docker host. Volumes are never removed automatically, because to do so could destroy data.

Docker networks don't take up much disk space, but they do create `iptables` rules, bridge network devices, and routing table entries. To clean these things up, you can use `docker network prune` to clean up networks which aren't used by any containers.


## Docker Build overview
Docker Build is one of Docker Engine's most used features. Whenever you are creating an image you are using Docker Build. Build is a key part of your software development life cycle allowing you to package and bundle your code and ship it anywhere.

Docker can build images automatically by reading the instructions from a Dockerfile. A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image.

### Use multi-stage builds
With multi-stage builds, you use multiple FROM statements in your Dockerfile. Each FROM instruction can use a different base, and each of them begins a new stage of the build. You can selectively copy artifacts from one stage to another, leaving behind everything you don't want in the final image.

### Docker build cache
Understanding Docker's build cache helps you write better Dockerfiles that result in faster builds.

Each instruction in this Dockerfile translates to a layer in your final image. You can think of image layers as a stack, with each layer adding more content on top of the layers that came before it.
Whenever a layer changes, that layer will need to be re-built.


- https://docs.docker.com/build/concepts/overview/
- https://docs.docker.com/build/building/multi-stage/
- https://docs.docker.com/build/cache/


## Docker Run overview
When you have your images downloaded or built them yourself based on your codebase or ... you can run containers based on those images which will actually run your applications or different services inside that container. separated in many ways with other services on the operating system or other containers, unless you explicitly define some kind of connection.

By running containers you can map ports from within the container to the host network so for example you can access a defined port inside the container from the host IP address. you can define storage points say it be docker volumes or bind mounts from the host filesystem to inside the container.

By default docker containers will be totally ephemeral, meaning no state will be persisted, and by removing the container all the state inside the container will be removed and won't be accessible again, until we create another container with the same image and try to maintain the desired state manually. this is why we build our custom images or use volumes to persist the state inside the containers.


## Docker Compose overview
Docker Compose is a tool for defining and running multi-container applications.

Compose simplifies the control of your entire application stack, making it easy to manage services, networks, and volumes in a single, comprehensible YAML configuration file. Then, with a single command, you create and start all the services from your configuration file.

Compose works in all environments; production, staging, development, testing, as well as CI workflows. It also has commands for managing the whole lifecycle of your application:

- Start, stop, and rebuild services
- View the status of running services
- Stream the log output of running services
- Run a one-off command on a service


### Why use Compose?
Using Docker Compose offers several benefits that streamline the development, deployment, and management of containerized applications:

- Simplified control: Docker Compose allows you to define and manage multi-container applications in a single YAML file. This simplifies the complex task of orchestrating and coordinating various services, making it easier to manage and replicate your application environment.
- Efficient collaboration: Docker Compose configuration files are easy to share, facilitating collaboration among developers, operations teams, and others. This collaborative approach leads to smoother workflows, faster issue resolution, and increased overall efficiency.
- Rapid application development: Compose caches the configuration used to create a container. When you restart a service that has not changed, Compose re-uses the existing containers. Re-using containers means that you can make changes to your environment very quickly.
- Portability across environments: Compose supports variables in the Compose file. You can use these variables to customize your composition for different environments, or different users.
- Extensive community and support: Docker Compose benefits from a vibrant and active community, which means abundant resources, tutorials, and support. This community-driven ecosystem contributes to the continuous improvement of Docker Compose and helps users troubleshoot issues effectively.

### Common use cases of Docker Compose
- Development environments
  When you're developing software, the ability to run an application in an isolated environment and interact with it is crucial. The Compose command line tool can be used to create the environment and interact with it.

  The Compose file provides a way to document and configure all of the application's service dependencies (databases, queues, caches, web service APIs, etc). Using the Compose command line tool you can create and start one or more containers for each dependency with a single command (docker compose up).

- Automated testing environments
  An important part of any Continuous Deployment or Continuous Integration process is the automated test suite. Automated end-to-end testing requires an environment in which to run tests. Compose provides a convenient way to create and destroy isolated testing environments for your test suite.

- Single host deployments
  For times that you are required to manage a single host to deploy and manage your services and applications, compose can become one of the best solutions as it will let you simply isolate your different applications, networks, storages... since you don't have multiple servers to manage separately.


<!-- docker compose demo -->


## Docker Hub overview
Docker Hub is a service provided by Docker for finding and sharing container images.

It's the world’s largest repository of container images with an array of content sources including container community developers, open source projects, and independent software vendors (ISV) building and distributing their code in containers.

What key features are included in Docker Hub?
- Repositories: Push and pull container images.
- Builds: Automatically build container images from GitHub and Bitbucket and push them to Docker Hub.
- Webhooks: Trigger actions after a successful push to a repository to integrate Docker Hub with other services.

Also we have many different container registry providers which docker hub is one of them:
- GitHub Container Registry
- Google Container Registry
- Red Hat Quay
- Amazon ECR
- Azure Container Registry




