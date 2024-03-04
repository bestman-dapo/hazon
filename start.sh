    #!/bin/bash

    apt-get update

    apt-get install -y cron

    # Navigate to the project directory
    cd /var/www/hazon


    # Run the desired commands or scripts
    CRON_COMMAND="* * * * * /usr/local/bin/php -q -f /var/www/hazon/artisan schedule:run --no-ansi >> /var/log/cron.log 2>&1"

    #touch /var/log/cron.log
    #crontab /etc/cron.d/card-expiry-cron

    # Add the cron job command to the crontab
    echo "$CRON_COMMAND" | crontab -

    # Any other commands or scripts you want to run as part of the cron job
    cron
    
    # Exit with a success status code
    exit 0