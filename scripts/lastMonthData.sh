#!/bin/bash

# Calculate the start and end times for the past month
now=$(date +%s)
start_time=$((now - 2592000))  # 30 days in seconds
end_time=$now

# Convert the start and end times to Unix timestamps
start_timestamp=$start_time
end_timestamp=$end_time

# Set the base URL for the CryptoCompare API
base_url="https://min-api.cryptocompare.com/data/v2/histohour"

# Set the parameters for the API request
params="fsym=ETH&tsym=USD&limit=720&aggregate=1&toTs=$end_timestamp&api_key=YOUR_API_KEY_HERE"

# Make the request to the CryptoCompare API and parse the JSON response using jq
curl "$base_url?$params" | jq '.Data.Data[] | "\(.close)"' | sed 's/"//g' | awk '{printf "%d\n", $1 + 0.5}' > ./../data_last_month.txt
git config user.email "sacha.simon@edu.devinci.fr"
git config user.name "Sacha924"
git remote set-url origin https://x-access-token:$PAT@github.com/Sacha924/ETH-Price-Variation.git
git add "./../data_last_month.txt" && git commit -m "Updating data_last_month.txt" && git push origin master
