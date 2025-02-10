# 5_min_XAUUSD_strategy
# RSI-EMA Trading Strategy Backtesting

## Overview
This project implements and backtests an RSI-EMA-based trading strategy for the XAU/USD (Gold/USD) forex pair using the **Backtesting.py** library. The strategy is designed to identify optimal entry and exit points based on Relative Strength Index (RSI) and Exponential Moving Average (EMA) conditions. The backtesting process evaluates various parameter combinations to find the most profitable configuration.

## Data Source
The price data for XAU/USD is fetched using the **Polygon.io API**, retrieving historical 5-minute interval data. The data includes open, high, low, close prices, and volume.

## Strategy Description
The strategy identifies trading opportunities using the following conditions:

### **Long (Buy) Entry Conditions**
- The closing price of the latest candle is **higher than the opening price** (indicating a green candle).
- The **RSI value is below a predefined threshold** (e.g., 20 or 30), suggesting an oversold market.
- The closing price is **below the EMA 9 by at least a certain pip difference** (e.g., 10 or 15 pips), indicating a potential rebound.
- If all conditions are met, a long position is entered with a defined **stop-loss** and **take-profit** target.

### **Short (Sell) Entry Conditions**
- The closing price of the latest candle is **lower than the opening price** (indicating a red candle).
- The **RSI value is above a predefined threshold** (e.g., 60, 70, or 80), suggesting an overbought market.
- The closing price is **above the EMA 9 by at least a certain pip difference**, indicating potential downward movement.
- If all conditions are met, a short position is entered with a defined **stop-loss** and **take-profit** target.

### **Exit Conditions**
- The trade closes automatically when either the stop-loss or take-profit level is reached.
- No manual exit or EMA-based exit is implemented.

## Risk Management
- The **position size** is calculated based on a fixed **risk percentage (e.g., 0.1% of equity)**.
- The strategy ensures that **each trade has a calculated stop-loss level** to protect against excessive losses.

## Parameter Optimization
To determine the best-performing strategy, the following parameters are varied:
- **Target pips**: 15 pips
- **RSI low threshold**: 20, 30
- **RSI high threshold**: 60, 70, 80
- **Stop-loss pips**: 15 pips
- **Pip difference** (distance from EMA 9 to enter a trade): 10, 15 pips

## Backtesting Process
1. **Historical Data Preparation**: The price data is retrieved and transformed into a Pandas DataFrame with appropriate column names.
2. **Technical Indicator Calculation**: RSI and EMA (9) are computed for the dataset.
3. **Strategy Execution**: The backtesting engine applies the strategy rules on the dataset.
4. **Parameter Optimization**: Multiple runs are executed to find the optimal combination of parameters that yield the highest final equity.
5. **Performance Evaluation**: The best-performing strategy is selected based on final equity, win rate, Sharpe ratio, and other performance metrics.
6. **Visualization**: The best strategy's performance is visualized using **Backtesting.py’s built-in plotting functions**.

## Performance Metrics
Each backtest run records key performance metrics, including:
- **Final Equity**: The total capital after all trades.
- **Number of Trades**: The total number of trades executed.
- **Win Rate (%)**: The percentage of profitable trades.
- **Sharpe Ratio**: A measure of risk-adjusted returns.
- **Return (%)**: The total percentage return on initial capital.
- **Maximum Drawdown (%)**: The largest peak-to-trough equity drop.
- **Average Drawdown (%)**: The average drawdown during the test.
- **Best Trade (%)**: The highest return from a single trade.
- **Worst Trade (%)**: The biggest loss from a single trade.

## Results


## Visualization


## How to Run the Project
### **1. Install Dependencies**
Ensure you have Python installed, then install the required libraries:
```bash
pip install ta backtesting bokeh==2.4.3 requests pandas
```

### **2. Run the Script**
Simply execute the script in your Python environment:
```bash
python backtest_rsi_ema.py
```
This will fetch the data, run the backtest, optimize the parameters, and display the results.

### **3. View Performance Metrics**
After execution, the script prints the best-performing parameter combination and generates performance visualizations.

## Conclusion
This project demonstrates a systematic approach to backtesting a forex trading strategy using RSI and EMA indicators. The optimization process helps identify the best parameter settings, providing insights into the effectiveness of the strategy. Further refinements, such as additional indicators or dynamic stop-loss adjustments, could enhance performance in real-world trading scenarios.

## Future Improvements
- **Live Trading Implementation**: Connect to a broker API for real-time execution.
- **Advanced Money Management**: Implement dynamic position sizing based on market conditions.
- **Additional Indicators**: Incorporate other technical indicators like MACD or Bollinger Bands for more robust signals.
- **Machine Learning Integration**: Use AI models to refine entry and exit conditions based on historical patterns.

---

### **Author**
*Shiwang Upadhyay*

### **License**
This project is open-source and available under the MIT License.

