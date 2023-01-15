name: ETH-Price-Variation Daily Script
on:
  schedule:
    - cron:  '0 0 * * *'
jobs:
  lastMonthData:
    runs-on: windows-20H2
    steps:
    - name: Checkout code
      uses: actions/checkout@v2
    - name: Run script
      run: ./scripts/lastMonthData.sh
