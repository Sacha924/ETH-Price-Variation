# Ethereum Price Fluctuation


This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

You can see what the final project looks like by clicking and this link --> https://eth-price-variation-pl5kgjktb-sachadcode.vercel.app/main

## Before diving in deep

The purpose of this project was to learn new skills and not to use the site I created to inform me of anomalies in the price of ether, and because I do not want to run scripts all day long, the automatic execution scripts to retrieve the price of ether, to modify the database, and therefore to modify the front end, will be stopped. 

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `pages/index.js`. The page auto-updates as you edit the file.

[API routes](https://nextjs.org/docs/api-routes/introduction) can be accessed on [http://localhost:3000/api/hello](http://localhost:3000/api/hello). This endpoint can be edited in `pages/api/hello.js`.

The `pages/api` directory is mapped to `/api/*`. Files in this directory are treated as [API routes](https://nextjs.org/docs/api-routes/introduction) instead of React pages.

This project uses [`next/font`](https://nextjs.org/docs/basic-features/font-optimization) to automatically optimize and load Inter, a custom Google Font.



## How can you use this code

Welcome, if you are here you are brave :), start by cloning this repo

```
git clone https://github.com/Sacha924/ETH-Price-Variation.git
```

And go into the database folder

```
cd database
```
<br>
Note that a lot of commands that I will give works on Linux, so if you are not on Linux I invite you to check how to download all the stuff according to your operating system
<br>

Then you need to install SQLite3 :

```
sudo apt-get install sqlite3
```

And create all the database and the table, run in your terminal :

```
sqlite3
.open "eth_database"
CREATE TABLE eth_prices (id INTEGER PRIMARY KEY, price INTEGER, date DATE);
.open anomaly_db
CREATE TABLE price_anomaly (id INTEGER PRIMARY KEY, price INTEGER, num_stddev REAL, date DATE);
```

CMD+D or .exit to leave SQLite3

<br>

After that, make all the scripts executable

```
chmod +x script_fileName
```

<br>

Then, this will probably be the hardest part : you need to configure a chat to receive message when an abnormal fluctuation price is detected. To do so, I invite you to see this video https://www.youtube.com/watch?v=CVG_ejMjNfU&t=1s&ab_channel=WatchNLearnIT, and to replace everything that need to be replace in this line of code ` curl --data chat_id="-1001699317441" --data-urlencode "text=The current price of Ethereum is abnormal ($price). It is $num_stddev standard deviations away from the mean." "https://api.telegram.org/bot5780978293:AAFziQuGxWjUoW45nWRH2rOJw9uEJ5Ezhd4/sendMessage?parse_mode=HTML"`. Or you can delete this line if you want to save time.
<br>
Lastly you will need to create an API key on https://www.cryptocompare.com/, even if I succeed to do my request without it (maybe the CryptoCompare API allows some requests to be made without an API key, or maybe the API is not properly checking for the presence of an API key)

<br>

go to the script folder and check that everything is ok about your scripts and db by running in the terminal
`./main.sh`

If you have any problems at the moment (you will probably have to install some module/package), feel free to use the issues section of this github repo to tell what goes wrong.

## About the files

main.sh : allows us to get data from an API, store this data in our DataBase, and then check if the data is abnormal and send a message if this is the case.

But you may ask how we check if "this is a normal price or not"?

We use a script called lastMonthData.sh that allows us, by calling the same API (with a different entry point), to get the price of ETH over the last month, at each hour. These data are stored in a file called data_last_month.txt, and can be used to detect abnormal price by using the z-score, which is a measure of how many standard deviations a data point is from the mean of a dataset


## Others 

about the 2 first rows in the anomaly_db, I create theses rows by myself by hardcoding the price of eth at 0$ or 123456$, to show that the code detect anomaly. So it's not an accurate old value, but just a test that show that everything is good.  

Note that we can have 0 anomaly for months with our calculation methods, and a thousand of anomaly a day (imagine the price just goes up every minute and break the confidence interval, each time the crontab execute the script, if the price follow the same trend it will trigger an anomaly again and so on)

## WBU automation

automation : we use crontab to allow the script to run every 10 minutes

Both the lastMonthData.sh and the main.sh are executed at a period of 10 minutes.

```
*/10 * * * * /PathToTheScript/ScriptName.sh
```

you can run crontab even if you are on windows : using third-party software such as Cygwin or GnuWin32. These programs allow you to run Unix commands on your Windows computer, including crontab. However, you will need to install this software and configure your environment to be able to use crontab on Windows.


## SQL Secutiry

In this code, there is no functionality that would allow a user to inject SQL code into the database. The database is loaded from a previously created .db file stored on the server, and no SQL query is executed on the database from the user's input.


## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js/) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/deployment) for more details.
