# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget curl unzip gnupg2 cron && \
    curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install && \
    rm google-chrome-stable_current_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# Create a user named "automate"
RUN useradd -ms /bin/bash automate

USER automate 

# Install the Selenium Python library
RUN pip install selenium requests

USER root

# Set the working directory
WORKDIR /app

# Copy the script to the container
COPY script.py .
RUN chown automate script.py

# Add the crontab file in the cron directory
ADD crontab /etc/cron.d/cron-script

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/cron-script

# Apply the cron job and run it as the "automate" user
RUN crontab -u automate /etc/cron.d/cron-script

# Create the log file to be able to run tail
RUN touch /var/log/cron.log && chown automate /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log