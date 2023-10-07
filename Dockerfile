# FROM ghcr.io/puppeteer/puppeteer:19.7.2

# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
#     PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# WORKDIR /usr/src/app
# # Set the display environment variable

# COPY package*.json ./
# RUN npm ci
# COPY . .
# CMD [ "node", "index.js" ]


# Use a base image with Node.js and necessary dependencies
FROM node:14

# Set the working directory
WORKDIR /app

# Install Puppeteer and other dependencies
RUN apt-get update -y && \
    apt-get install -y wget libgconf-2-4

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the Node.js script
COPY script.js ./

# Set the display environment variable
ENV DISPLAY=:99

# Start Xvfb and execute the Node.js script
CMD Xvfb :99 -screen 0 1920x1080x16 & node script.js

