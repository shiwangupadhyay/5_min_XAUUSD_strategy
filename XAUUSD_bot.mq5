//+------------------------------------------------------------------+
//|                                        RSI_EMA_Strategy.mq5      |
//|                                                                  |
//+------------------------------------------------------------------+
#property strict

#include <Trade\Trade.mqh>
CTrade trade;

// Strategy Parameters
input double PercentRisk = 1;     // Percentage of equity to risk per trade
input int TargetPips = 15;         // Target in pips
input int StopLossPips = 15;       // Stop loss in pips
input int RsiLow = 30;             // RSI low threshold
input int RsiHigh = 60;            // RSI high threshold
input int PipDifference = 15;      // Difference between price and EMA in pips
input double pipValue = 0.1;

// Global Variables
int RsiPeriod = 14;


// Function to calculate lot size based on risk percentage
double CalculateLotSize(double riskPercent, double stopLossPips)
{
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = (accountBalance) * (riskPercent / 100.0);
   double lotSize = NormalizeDouble(riskAmount / (stopLossPips * pipValue),2);
   return MathCeil(lotSize/100);
}

// Indicator Handles
int RsiHandle;
int EmaHandle;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   RsiHandle = iRSI(_Symbol, 0, RsiPeriod, PRICE_CLOSE);
   EmaHandle = iMA(_Symbol, 0, 9, 0, MODE_EMA, PRICE_CLOSE);

   if (RsiHandle == INVALID_HANDLE || EmaHandle == INVALID_HANDLE)
   {
      Print("Error initializing indicators.");
      return INIT_FAILED;
   }
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   IndicatorRelease(RsiHandle);
   IndicatorRelease(EmaHandle);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
// Global Variable to Track Last Candlestick Time
datetime lastTradeTime;

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   datetime currentCandleTime = iTime(_Symbol, 0, 0); // Get the open time of the current candlestick

   // Check if a new candlestick has formed
   if (currentCandleTime != lastTradeTime) 
   {
      lastTradeTime = currentCandleTime; // Update lastTradeTime to the current candlestick

      double rsiBuffer[1];
      double emaBuffer[1];

      // Retrieve RSI and EMA values
      if (CopyBuffer(RsiHandle, 0, 1, 1, rsiBuffer) <= 0 || CopyBuffer(EmaHandle, 0, 1, 1, emaBuffer) <= 0)
      {
         Print("Error copying indicator buffer.");
         return;
      }
      double rsiCurrent = rsiBuffer[0];
      double emaCurrent = emaBuffer[0];
      double closePrice = iClose(_Symbol, 0, 0);
      double openPrice = iOpen(_Symbol, 0, 0);
      double lastClose = iClose(_Symbol, 0, 1);
      double lastOpen = iOpen(_Symbol, 0, 1);
      double seclastclose = iClose(_Symbol, 0, 2);
      double seclastOpen = iOpen(_Symbol, 0, 2);

      double lotSize = CalculateLotSize(PercentRisk, StopLossPips);

      // Check if there are open positions
      bool hasBuyPosition = false, hasSellPosition = false;
      for (int i = 0; i < PositionsTotal(); i++)
      {
         if (PositionGetSymbol(i) == _Symbol)
         {
            if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
               hasBuyPosition = true;
            else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
               hasSellPosition = true;
         }
      }

       //Buy Condition
      if (lastClose > lastOpen && rsiCurrent < RsiLow &&
          lastClose < emaCurrent - PipDifference * pipValue && !hasBuyPosition)
      {
         double entryPrice = openPrice;
         double stopLoss = entryPrice - 1.5;
         double takeProfit = entryPrice + 1.5;

         if (stopLoss < entryPrice && entryPrice < takeProfit)
            OpenBuy(entryPrice, stopLoss, takeProfit, lotSize);
      }

      // Sell Condition
      if (lastClose < lastOpen && rsiCurrent > RsiHigh &&
          lastClose > emaCurrent + PipDifference * pipValue && !hasSellPosition)
      {
         double entryPrice = openPrice;
         double stopLoss = entryPrice + 1.5;
         double takeProfit = entryPrice - 1.5;

         if (takeProfit < entryPrice && entryPrice < stopLoss)
            OpenSell(entryPrice, stopLoss, takeProfit, lotSize);
      }
   }
}


//+------------------------------------------------------------------+
//| Open Buy Position                                                |
//+------------------------------------------------------------------+
void OpenBuy(double price, double stopLoss, double takeProfit, double lotSize)
{
   trade.PositionOpen(_Symbol, ORDER_TYPE_BUY, lotSize, price, stopLoss, takeProfit, "Buy Order");
}

//+------------------------------------------------------------------+
//| Open Sell Position                                               |
//+------------------------------------------------------------------+
void OpenSell(double price, double stopLoss, double takeProfit, double lotSize)
{
   trade.PositionOpen(_Symbol, ORDER_TYPE_SELL, lotSize, price, stopLoss, takeProfit, "Sell Order");
}
//+------------------------------------------------------------------+
