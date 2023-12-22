//+------------------------------------------------------------------+
//|                                                TradeCmdsMql4.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict


extern int InitialMagic


int MarketModify(int tick, double stop, double take)
  {
   if(! OrderSelect(tick, SELECT_BY_TICKET) || OrderType() >= 2 || OrderCloseTime() > 0)
     {
      Print("Wrong ticket for MarketModify function") ;
      return (-3) ;
     }
   double use_sl = 0, use_tp = 0 ;

   if(stop > 0)
     {
      if(OrderType() == OP_BUY)
        {
         use_sl = OrderOpenPrice() - stop ;
        }
      else
        {
         use_sl = OrderOpenPrice() + stop ;
        }
     }
   if(stop < 0)
     {
      use_sl = -stop ;
     }
   if(take > 0)
     {
      if(OrderType() == OP_BUY)
        {
         use_tp = OrderOpenPrice() + take ;
        }
      else
        {
         use_tp = OrderOpenPrice() - take ;
        }
     }
   if(take < 0)
     {
      use_tp = -take ;
     }
   if(MathAbs(OrderStopLoss() - use_sl) < Point && MathAbs(use_tp - OrderTakeProfit()) < Point)
     {
      Print("There was an attempt to modify market order without changes to TP and SL") ;
      return (-3) ;
     }

   int attempt = 1 ;
   bool result = false ;

   while(attempt <= command_attempts && ! result)
     {
      /*
        if ((OrderType () == OP_BUY && (MarketInfo (OrderSymbol (), MODE_BID) - use_sl < d_stoplevel || use_tp - MarketInfo (OrderSymbol (), MODE_BID) < d_stoplevel)) ||
            (OrderType () == OP_SELL && (use_sl - MarketInfo (OrderSymbol (), MODE_ASK) < d_stoplevel || MarketInfo (OrderSymbol (), MODE_ASK) - use_tp < d_stoplevel)))
        {
           Print ("Couldn''t modify order ", tick, " because of broker stops level") ;
           return (-2) ;
        }
        if ((OrderType () == OP_BUY && (MarketInfo (OrderSymbol (), MODE_BID) - use_sl < d_freezelevel || use_tp - MarketInfo (OrderSymbol (), MODE_BID) < d_freezelevel)) ||
            (OrderType () == OP_SELL && (use_sl - MarketInfo (OrderSymbol (), MODE_ASK) < d_freezelevel || MarketInfo (OrderSymbol (), MODE_ASK) - use_tp < d_freezelevel)))
        {
           Print ("Couldn''t modify order ", tick, " because its level is too close to the price") ;
           return (-2) ;
        }*/

      int ms = GetTickCount() ;

      Print("Attempt #", attempt, " to modify market order ", tick, " to stoploss ", DoubleToStr(use_sl, Digits), " and takeprofit ", DoubleToStr(use_tp, Digits)) ;
      result = OrderModify(tick, OrderOpenPrice(), use_sl, use_tp, 0) ;

      if(! result)
        {
         errors ++ ;

         int err = GetLastError() ;

         switch(ErrorBlock(err, ms))
           {
            case 0: // continue

               break ;
            case 1: // wait and continue
               Sleep(wait_error) ;

               break ;
            case 2: // terminate
               return (-1) ;
           }
        }
      else
        {
         errors = 0 ;
         Print("Order successfully modified in ", GetTickCount() - ms, " ms") ;
        }
      if(errors > max_errors)
        {
         Print("Exceeded maximum errors count while trying to send trading command.") ;
         Print("To continue you should restart terminal or the EA") ;
         return (-1) ;
        }
      attempt ++ ;

      if(attempt > command_attempts && ! result)
        {
         return (-1) ;
        }
     }
   return (1) ;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int PendingSend(int type, double lots, double price, double stop, double take, int magic_number, string comm)
  {
   if(type < 2 || type > 5)
     {
      Print("Error in type of pending order!") ;
      return (-3) ;
     }
   bool price_err = false, sltp_err = false ;

   RefreshRates() ;
   double use_sl = 0, use_tp = 0 ;

   if(stop > 0 && stop < d_stoplevel)
     {
      Print("Stoploss for sending pending order is lesser that stops level!") ;
      return (-3) ;
     }
   if(take > 0 && take < d_stoplevel)
     {
      Print("Takeprofit for sending pending order is lesser that stops level!") ;
      return (-3) ;
     }
   switch(type)
     {
      case OP_BUYLIMIT:
         if(Ask - price < d_stoplevel)
           {
            price_err = true ;
           }
         if(stop != 0)
           {
            if(stop > 0)
              {
               use_sl = price - stop ;
              }
            else
              {
               use_sl = -stop ;

               if(price - use_sl < d_stoplevel)
                 {
                  Print("Stoploss for sending pending order is lesser that stops level!") ;
                  return (-3) ;
                 }
              }
           }
         if(take != 0)
           {
            if(take > 0)
              {
               use_tp = price + take ;
              }
            else
              {
               use_tp = -take ;

               if(use_tp - price < d_stoplevel)
                 {
                  Print("Takeprofit for sending pending order is lesser that stops level!") ;
                  return (-3) ;
                 }
              }
           }
         break ;

      case OP_SELLLIMIT:
         if(price - Bid < d_stoplevel)
           {
            price_err = true ;
           }
         if(stop != 0)
           {
            if(stop > 0)
              {
               use_sl = price + stop ;
              }
            else
              {
               use_sl = -stop ;

               if(use_sl - price < d_stoplevel)
                 {
                  Print("Stoploss for sending pending order is lesser that stops level!") ;
                  return (-3) ;
                 }
              }
           }
         if(take != 0)
           {
            if(take > 0)
              {
               use_tp = price - take ;
              }
            else
              {
               use_tp = -take ;

               if(price - use_tp < d_stoplevel)
                 {
                  Print("Takeprofit for sending pending order is lesser that stops level!") ;
                  return (-3) ;
                 }
              }
           }
         break ;

      case OP_BUYSTOP:
         if(price - Ask < d_stoplevel)
           {
            price_err = true ;
           }
         if(stop != 0)
           {
            if(stop > 0)
              {
               use_sl = price - stop ;
              }
            else
              {
               use_sl = -stop ;

               if(price - use_sl < d_stoplevel)
                 {
                  Print("Stoploss for sending pending order is lesser that stops level!") ;
                  return (-3) ;
                 }
              }
           }
         if(take != 0)
           {
            if(take > 0)
              {
               use_tp = price + take ;
              }
            else
              {
               use_tp = -take ;

               if(use_tp - price < d_stoplevel)
                 {
                  Print("Takeprofit for sending pending order is lesser that stops level!") ;
                  return (-3) ;
                 }
              }
           }
         break ;

      case OP_SELLSTOP:
         if(Bid - price < d_stoplevel)
           {
            price_err = true ;
           }
         if(stop != 0)
           {
            if(stop > 0)
              {
               use_sl = price + stop ;
              }
            else
              {
               use_sl = -stop ;

               if(use_sl - price < d_stoplevel)
                 {
                  Print("Stoploss for sending pending order is lesser that stops level!") ;
                  return (-3) ;
                 }
              }
           }
         if(take != 0)
           {
            if(take > 0)
              {
               use_tp = price - take ;
              }
            else
              {
               use_tp = -take ;

               if(price - use_tp < d_stoplevel)
                 {
                  Print("Takeprofit for sending pending order is lesser that stops level!") ;
                  return (-3) ;
                 }
              }
           }
         break ;
     }
   int attempt = 1 ;
   int tick = -1 ;

   while(attempt <= command_attempts && tick < 0)
     {
      RefreshRates() ;

      if((type == OP_BUYLIMIT && Ask - price < d_stoplevel) ||
         (type == OP_SELLLIMIT && price - Bid < d_stoplevel) ||
         (type == OP_BUYSTOP && price - Ask < d_stoplevel) ||
         (type == OP_SELLSTOP && Bid - price < d_stoplevel))
        {
         Print("Cannot set a pending orders due to minimal broker stops&limits level (", DoubleToStr(type, 0), " ", DoubleToStr(price, Digits), " ",
               DoubleToStr(use_sl, Digits), " ", DoubleToStr(use_tp, Digits), ") (", DoubleToStr(Ask, Digits), " ", DoubleToStr(Bid, Digits), ")") ;
         return (-2) ;
        }
      string str = StringConcatenate("Attempt ", DoubleToStr(attempt, 0), " to set an order ") ;

      switch(type)
        {
         case OP_BUYLIMIT:
            str = StringConcatenate(str, "Buy Limit") ;
            break ;
         case OP_SELLLIMIT:
            str = StringConcatenate(str, "Sell Limit") ;
            break ;
         case OP_BUYSTOP:
            str = StringConcatenate(str, "Buy Stop") ;
            break ;
         case OP_SELLSTOP:
            str = StringConcatenate(str, "Sell Stop") ;
        }
      str = StringConcatenate(str, " at price ", DoubleToStr(price, Digits), " stop ", DoubleToStr(use_sl, Digits), " take ", DoubleToStr(use_tp, Digits)) ;
      Print(str) ;

      int ms = GetTickCount() ;
      tick = OrderSend(Symbol(), type, lots, price, 0, use_sl, use_tp, comm, magic_number) ;

      if(tick < 0)
        {
         errors ++ ;

         int err = GetLastError() ;

         switch(ErrorBlock(err, ms))
           {
            case 0: // continue

               break ;
            case 1: // wait and continue
               Sleep(wait_error) ;

               break ;
            case 2: // terminate
               return (-1) ;
           }
        }
      else
        {
         errors = 0 ;
         Print("Order is set in ", GetTickCount() - ms, " ms") ;
        }
      if(errors > max_errors)
        {
         Print("Exceeded maximum errors count while trying to send trading command.") ;
         Print("To continue you should restart terminal or the EA") ;
         return (-1) ;
        }
      attempt ++ ;

      if(attempt > command_attempts && tick < 0)
        {
         Print("Exeeded maximum number of simultaneous attempts of setting an order") ;
         return (-1) ;
        }
     }
   return (tick) ;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MarketSend(int dir, double lots, double stop, double take, int magic_number)
  {
   if(dir != OP_BUY && dir != OP_SELL)
     {
      Print("Wrong order direction for function MarketSend") ;
      return (-3) ;
     }
   RefreshRates() ;

   double init_ask = Ask ;
   double init_bid = Bid ;

   if((stop > 0 && stop < d_stoplevel) || (stop < 0 && ((dir == OP_BUY && Ask + stop < d_stoplevel) || (dir == OP_SELL && -stop - Bid < d_stoplevel))))
     {
      Print("Wrong stoploss value for function MarketSend. Sending w/o stop") ;
      return (-3) ;
     }
   if((take > 0 && take < d_stoplevel) || (take < 0 && ((dir == OP_BUY && -take - Ask < d_stoplevel) || (dir == OP_SELL && Bid + take < d_stoplevel))))
     {
      Print("Wrong takeprofit value for function MarketSend. Sending w/o take") ;
      return (-3) ;
     }
   double use_sl, use_tp, price ;
   int attempt = 1, tick = -1 ;

   while(attempt <= command_attempts && tick < 0)
     {
      double _slp ;
      int use_slp ;

      if(dir == OP_BUY)
        {
         _slp = (Ask - init_ask) / Point ;
         use_slp = max_slippage - _slp ;
        }
      else
        {
         _slp = (init_bid - Bid) / Point ;
         use_slp = max_slippage - _slp ;
        }
      if(use_slp < 0)
        {
         Print("Maximal slippage exceeded while trying to open market order") ;
         return (-2) ;
        }
      if(dir == OP_BUY)
        {
         price = Ask ;
        }
      else
        {
         price = Bid ;
        }
      use_sl = 0 ;
      use_tp = 0 ;

      if(market_execution == 0)
        {
         if(stop > 0)
           {
            if(dir == OP_BUY)
              {
               use_sl = Ask - stop ;
              }
            else
              {
               use_sl = Bid + stop ;
              }
           }
         if(stop < 0)
           {
            if(dir == OP_BUY)
              {
               if(Ask + stop < d_stoplevel)
                 {
                  Print("Stoploss is under broker stop levels while sending BUY") ;
                  return (-2) ;
                 }
               else
                 {
                  use_sl = -stop ;
                 }
              }
            else
              {
               if(-stop - Bid < d_stoplevel)
                 {
                  Print("Stoploss is under broker stop levels while sending SELL") ;
                  return (-2) ;
                 }
               else
                 {
                  use_sl = -stop ;
                 }
              }
           }
         if(take > 0)
           {
            if(dir == OP_BUY)
              {
               use_tp = Ask + take ;
              }
            else
              {
               use_tp = Bid - take ;
              }
           }
         if(take < 0)
           {
            if(dir == OP_BUY)
              {
               if(-take - Ask < d_stoplevel)
                 {
                  Print("Takeprofit is under broker stop levels while sending BUY") ;
                  return (-2) ;
                 }
               else
                 {
                  use_tp = -take ;
                 }
              }
            else
              {
               if(Bid + take < d_stoplevel)
                 {
                  Print("Takeprofit is under broker stop levels while sending SELL") ;
                  return (-2) ;
                 }
               else
                 {
                  use_tp = -take ;
                 }
              }
           }
        }
      string str = StringConcatenate("Attempt ", DoubleToStr(attempt, 0), " of sending order") ;

      if(dir == OP_BUY)
        {
         str = StringConcatenate(str, " BUY ") ;
        }
      else
        {
         str = StringConcatenate(str, " SELL ") ;
        }
      str = StringConcatenate(str, "at price ", DoubleToStr(price, Digits), " stop ", DoubleToStr(use_sl, Digits), " take ", DoubleToStr(use_tp, Digits)) ;
      Print(str) ;

      int ms = GetTickCount() ;
      tick = OrderSend(Symbol(), dir, lots, price, use_slp, use_sl, use_tp, "", magic_number) ;

      if(tick < 0)
        {
         errors ++ ;

         int err = GetLastError() ;

         if(err == ERR_INVALID_STOPS)
           {
            if(market_execution == 0)
              {
               if(stop != 0 || take != 0)
                 {
                  Print("Incorrect stops. Maybe broker increased stop levels") ;
                  return (-2) ;
                 }
               else
                 {
                  Print("Incorrect stops while stop and take = 0. Error in expert logic") ;
                  return (-3) ;
                 }
              }
            else
              {
               Print("Incorrect stops with Market Execution. Error in expert logic") ;
               return (-3) ;
              }
           }
         else
           {
            switch(ErrorBlock(err, ms))
              {
               case 0: // continue

                  break ;
               case 1: // wait and continue
                  Sleep(wait_error) ;

                  break ;
               case 2: // terminate
                  return (-1) ;
              }
           }
        }
      else
        {
         errors = 0 ;
         OrderSelect(tick, SELECT_BY_TICKET) ;

         str = StringConcatenate("Order was opened in ", DoubleToStr(GetTickCount() - ms, 0), " ms") ;
         double r_slp ;

         if(MathAbs(OrderOpenPrice() - price) >= Point)
           {
            if(OrderType() == OP_BUY)
              {
               r_slp = (OrderOpenPrice() - price) / Point ;
              }
            else
              {
               r_slp = (price - OrderOpenPrice()) / Point ;
              }
            str = StringConcatenate(str, " with slippage ", DoubleToStr(MathAbs(r_slp), 0), " pips") ;

            if(r_slp < 0)
              {
               str = StringConcatenate(str, " in our benefit") ;
              }
           }
         Print(str) ;

         if(market_execution == 1 && (stop != 0 || take != 0))
           {
            MarketModify(OrderTicket(), stop, take) ;
           }
        }
      if(errors > max_errors)
        {
         Print("Exceeded maximum errors count while trying to send trading command.") ;
         Print("To continue you should restart terminal or the EA") ;
         return (-1) ;
        }
      attempt ++ ;

      if(attempt > command_attempts && tick < 0)
        {
         Print("Exeeded maximum number of simultaneous attempts of setting an order") ;
         return (-1) ;
        }
      RefreshRates() ;
     }
   return (tick) ;
  }

/*
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MyOrders()
  {
   int num = 0 ;

   for(int i = OrdersTotal() - 1; i >= 0; i --)
     {
      if(OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == Symbol() && OrderMagicNumber() >= initial_magic && OrderMagicNumber() < InitialMagic + 100)
        {
         num ++ ;
        }
     }
   return (num) ;
  }
*/