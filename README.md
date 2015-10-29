# slack-plugin-docker

Configuration and scripts for building and testing slack-plugin
(https://github.com/jenkinsci/slack-plugin) with a Docker container. Building
with Docker has dubious value, other than providing a consistent environment
between developers, because developers are likely to be using an IDE on their
host systems that still needs to be setup and configured, but being able to
quickly and easily standup a Jenkins server is extremely valuable.

**Note** that these scripts and configurations were created for a
boot2docker/docker-machine environment. If you need to make changes for other
environments, make sure to build something in so it keeps working for everyone.

The scripts are pretty simple and are in many cases conveniences, so small
personal customizations can often be made by just running the commands directly
from the command line.

Setup boot2docker
-----------------

If you need to, install boot2docker (http://boot2docker.io/) and follow the
instructions to get it working. You'll basically need the following.

1. boot2docker init
2. boot2docker start
3. eval $(boot2docker shellinit)

Setup docker-machine
--------------------

See https://www.docker.com/docker-machine for instructions on installing and setting
up docker-machine. The steps below use a machine name of default, but use whatever
settings and naming you prefer. You can even create your machine in a cloud.

1. docker-machine create default
2. docker-machine start default
3. eval $(docker-machine env default)

Building using the Docker container
-----------------------------------

1. Create the Docker container for building the slack-plugin project.

   Execute the build-docker-image.sh shell script. This creates a docker image
   tagged as slack-plugin-build, using the Dockerfile file. This image could be
   uploaded to Docker hub, but it doesn't seem worthwhile right now.
   
   Building the image will probably take quite a while as it needs to download
   the Maven image from Docker hub, but this only needs to be done once, unless
   you need to change something in Dockerfile. Subsequent builds will also
   probably be much faster due to caching.
   
   Note that the Dockerfile creates the expected directories in the container,
   and copies settings.xml into the root user's Maven home directory
   (/root/.m2). The local repository in settings.xml is pointed to /var/m2repo,
   which will be mapped to a directory on the local host when the container is
   started to build the project. More information about that below.
   
2. Build the project using a container by executing the build-plugin.sh shell script.

   **Note** that the shell script assumes that the source code for the
   slack-plugin project is in a directory called slack-plugin 1 directory above
   your current directory (i.e. ../slack-plugin).
   
   This is basically what happens when you execute the script.
   
   1. Create a Docker container from the slack-plugin-build image
   2. Map the slack-plugin source code directory to a volume on /slack-plugin,
      so the container can read the project for building, and the target output
      directory will remain when the container is removed at the end of the
      build.
   3. Map the m2repo in the current directory to a volumne on /var/m2repo. This
      directory will contain the Maven artifacts that are downloaded as
      dependencies during the build.  This means the artifacts are preserved
      during builds, which is very useful because the largest part of the build
      is downloading these dependencies. It would be nice to have a fresh start
      each time, but that would be too time and resource consuming. To get a
      fresh start, simply clear out the contents of m2repo.
   4. Open a psuedo-tty and keep a connection to STDIN open so you can watch
      the progress.
   5. Execute "mvn clean package" to build the project.
   6. Stop the container and remove it.
   
Starting Jenkins
----------------

The Jenkins container can be started by executing the start-jenkins.sh shell
script. This script is a little smarter than the other scripts, mainly because
the Jenkins container runs as a daemon and will continue to run the background
until you stop it. The script will detect whether it is already running,
whether the container has been started previously and just needs to be
restarted, or if it needs to be started for the first time. After startup it
should print out the URL for accessing Jenkins from your browser.

Note that for boot2docker/docker-machine it should show the IP address of the VM.

To stop the container: docker stop jenkins
To stop and remove the Jenkins container: reset-jenkins.sh

