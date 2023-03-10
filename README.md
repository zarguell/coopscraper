# Park Slope Food Coop Calendar Checker

This script logs in to the Park Slope Food Coop website using Selenium, and checks the calendar for available appointments. If any appointments are available, it sends a notification to a Discord webhook specified in the `WEBHOOK` environment variable.

## Prerequisites

- Python 3.6 or higher
- Selenium (you can install it with pip: `pip install selenium`)
- Chrome web driver (download and install it from https://sites.google.com/a/chromium.org/chromedriver/downloads)

## Configuration

Before running the script, you need to set these environment variables:

- `WEBHOOK`: The Discord webhook URL to send notifications to
- `USERNAME`: Your Park Slope Food Coop login username
- `PASSWORD`: Your Park Slope Food Coop login password
- `CRON`: Cron expression frequency to run script
- `HEALTHCHECK`: Optional healthchecks.io endpoint to ping at your cron interval.

You can set environment variables in your terminal session before running the script:

```bash
export WEBHOOK='https://discordapp.com/api/webhooks/...'
export USERNAME='your_username'
export PASSWORD='your_password'
```

Or, you can set them in your IDE or code editor's run configuration.

## Usage
To run the script, navigate to the directory containing the script in your terminal, and enter:

```
python park_slope_food_coop.py
```

The script will launch Chrome, navigate to the login page, enter your username and password, and check the calendar for available appointments. If any appointments are available, it will send a notification to the Discord webhook URL specified in the WEBHOOK environment variable.

If all appointments are taken, the script will print a message indicating that there are no available appointments.

## Docker

A Dockerfile is available for easy of automation. It sets up the Python environment, and runs the script on an hourly cron.