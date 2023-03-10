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

# Set the working directory
WORKDIR /app

# Copy the script to the container
COPY script.py .
RUN chown automate script.py

USER automate 

# Install the Selenium Python library
RUN pip install selenium requests

# Run the script
CMD /usr/local/bin/python /app/script.py 