# docker-teamspeak3
Teamspeak 3 Docker Container

## Run the container
1.  Create a folder on your host for the configuration and data files (eg. sudo mkdir /path/to/data)
2.  Run the container:

    ```
    docker run -d --name ts3 \
        -v /path/to/data:/data \
        -p 9987:9987/udp -p 10011:10011 -p 30033:30033 \
        gotofoo/teamspeak3
    ```
3.  If the teamspeak server cannot find any configuration and data files the data volume will be initialized with a fresh configuration. You can obtain the admin credentials and token from the log as follows:
  
    ```
    docker logs ts3
    ```

## Update to a new version
1.  Stop the running instance:

    ```
    docker stop ts3
    ```
2.  Make shure that all data and configuration is stored outside of the container.
3.  Remove the container:

    ```
    docker rm ts3
    ```
4.  Create a new instance as described under [Run the container](##Run the container)

## Optional environment variables
|Environment Variable|Description|
|--------------------|-----------|
|UID|Specifies the UID the daemon should run as. All created files will be owned by this UID. Defaults to 0 for root.|
|GID|Specifies the GID for all created files. This only works in combination with the UID. Defaults to 0 for root.|
