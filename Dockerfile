# Use official OpenJDK image as the base image
FROM openjdk:17-jdk-slim

RUN apt update && \
    apt install wget jq -y

# Set environment variables for Minecraft server version, data directory and server port
ENV MC_VERSION=latest \
    MC_HOME=/minecraft \
    MC_PORT=25565 \
    MC_MIN_RAM=512M \
    MC_MAX_RAM=1G

ARG URL=https://papermc.io/api/v2/projects/paper

# Set up non-root user for running the Minecraft server
RUN useradd -m -d ${MC_HOME} minecraft

# Set the working directory to user home 
WORKDIR ${MC_HOME}

# Copy jar downloader
COPY jarGetter.sh ${MC_HOME}
RUN chmod +x jarGetter.sh && \
    chown minecraft jarGetter.sh 

# Switch to the Minecraft server user
USER minecraft

# Get files and make directory
RUN ./jarGetter.sh ${MC_VERSION} && \
    mkdir server && \
    mv *.jar server

# Set the working directory to the Minecraft server directory
WORKDIR ${MC_HOME}/server

# Accept EULA
RUN echo "eula=true" > eula.txt

# Expose port for Minecraft server
EXPOSE ${MC_PORT}

# Command to start the Minecraft server
CMD java -Xms${MC_MIN_RAM} -Xmx${MC_MAX_RAM} -jar $(ls *.jar)
