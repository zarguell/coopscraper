# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget curl unzip gnupg2 && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    echo "deb [arch=arm64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    dpkg --add-architecture arm64 && \
    apt-get update && \
    apt-get install -y google-chrome-stable:amd64 google-chrome-stable:arm64 && \
    rm -rf /var/lib/apt/lists/*

# Create a user named "automate"
RUN useradd -ms /bin/bash automate

# Install the Selenium Python library
RUN pip install selenium requests

# Set the working directory
WORKDIR /app

# Copy the script to the container
COPY script.py .

# Add the crontab file in the cron directory
ADD crontab /etc/cron.d/cron-script

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/cron-script

# Apply the cron job and run it as the "automate" user
RUN crontab -u automate /etc/cron.d/cron-script

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log