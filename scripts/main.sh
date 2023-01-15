# --------------------------------------------------------------- GET DATA FROM API --------------------------------------------------------------- #


# Set the API endpoint and the required parameters
endpoint="https://min-api.cryptocompare.com/data/price"
fsym="ETH" # Specify the cryptocurrency symbol (ETH for Ethereum)
tsyms="USD" # Specify the currency to convert to (USD in this case)
# Check the doc for more infos https://min-api.cryptocompare.com/documentation?key=Blockchain&cat=blockchainDay

# Make the API request
response=$(curl "$endpoint?fsym=$fsym&tsyms=$tsyms")

# Extract the data from the response
data=$(echo $response | jq '.')

# Extract the price from the data
price=$(echo $data | jq '.USD' | awk '{printf "%d\n", $1 + 0.5}')
echo "The current price of Ethereum is $"$price"."


# -------------------------------------------------------------- INSERT DATA INTO DB -------------------------------------------------------------- #


# Insert the data into the database
sqlite3 ./../database/eth_database "INSERT INTO eth_prices (price, date) VALUES ($price, datetime('now'));"
#sqlite3 eth_database  "select * from eth_prices;"
results=$(sqlite3 ./../database/eth_database "SELECT * FROM eth_prices")

# Print the results as a table
echo " id | price |         date        |"
echo "----|-------|---------------------|"
while read -r line; do
    echo "$line" | awk -F '|' '{ printf "%-3s | %-5s | %s |\n", $1, $2, $3 }'
        done <<< "$results"


# ---------------------------------------------------------- CHECK IF DATA IS ABNORMAL ------------------------------------------------------------ #

# calculate the mean and standard deviation of the data in the "data_last_month.txt" file
mean=$(awk '{sum+=$1} END {print sum/NR}' ./../data_last_month.txt)
stddev=$(awk '{sum+=$1; sumsq+=$1*$1} END {print sqrt(sumsq/NR - (sum/NR)**2)}' ./../data_last_month.txt)

# Calculate the z-score of the current price
# price=123456 #It's a test value to see if value that will be abnormal will trigger an insertion in the db
# price=0 #It's a test value to see if value that will be abnormal will trigger an insertion in the db

zscore=$(awk -v price=$price -v mean=$mean -v stddev=$stddev 'BEGIN {print (price - mean) / stddev}')

# Check if the z-score is outside the normal range (e.g. -3 to 3)
if (( $(awk -v zscore=$zscore 'BEGIN {print (zscore < -3)}') )) || (( $(awk -v zscore=$zscore 'BEGIN {print (zscore > 3)}') )); then
    # Calculate the number of standard deviations away from the mean
    num_stddev=$(awk -v zscore=$zscore 'BEGIN {printf "%.2f", zscore}')
    # Print a message indicating that the current price is abnormal
    echo "The current price of Ethereum is abnormal ($price). It is $num_stddev standard deviations away from the mean."
    sqlite3 ./../database/anomaly_db "INSERT INTO price_anomaly (price, num_stddev, date) VALUES ($price, $num_stddev, datetime('now'));"
    git add eth_database && git commit -m "Updating anomaly_database" && git push origin master
    curl --data chat_id="-1001699317441" --data-urlencode "text=The current price of Ethereum is abnormal ($price). It is $num_stddev standard deviations away from the mean." "https://api.telegram.org/bot5780978293:YOUR_API_KEY/sendMessage?parse_mode=HTML"
else
    # Print a message indicating that the current price is normal
    echo "The current price of Ethereum is normal ($price)."
fi
# results=$(sqlite3 ./../database/anomaly_db "SELECT * FROM price_anomaly")
# echo $results