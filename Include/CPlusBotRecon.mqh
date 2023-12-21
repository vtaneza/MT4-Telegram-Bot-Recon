//|-----------------------------------------------------------------------------------------|
//|                                                                       CPlusBotRecon.mq4 |
//|                                                              Copyright 2019, Dennis Lee |
//|                                   https://github.com/dennislwm/MT5-MT4-Telegram-API-Bot |
//|                                                                                         |
//| History                                                                                 |
//|   0.9.0    The CPlusBotRecon class inherits from CCustomBot. We added general, order    |
//|      status, history status, and account status bot commands:                           |
//|      (1) /help - Display a list of bot commands                                         |
//|      (2) /ordertotal - Return count of orders                                           |
//|      (3) /ordertrade - Return ALL orders, where EACH order includes ticket, symbol,     |
//|            type, lots, openprice, stoploss, takeprofit, opentime and prevticket.        |
//|            Note: curprice, swap, profit, expiration, closetime, magicno, accountno,     |
//|               and expertname are NOT returned.                                          |
//|      (4) /orderticket <ticket> - Return an order by ticket number. If <ticket> is a     |
//|            partial trade, return a chain of orders and history, otherwise return a      |
//|            single trade.                                                                |
//|      (5) /historytotal - Return count of history                                        |
//|      (6) /historyticket <ticket> - Return a history or a chain of history, where EACH   |
//|            history includes ticket, symbol, type, lots, openprice, closeprice, stoploss,|
//|            takeprofit, opentime, closetime, and prevticket.                             |
//|            Note: opentime, swap, profit, expiration, magicno, accountno, and            |
//|            expertname are NOT returned.                                                 |
//|      (7) /account - Return account number, currency, balance, equity, margin,           |
//|            freemargin and profit.                                                       |
//|-----------------------------------------------------------------------------------------|
#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/MT5-MT4-Telegram-API-Bot"
#property strict

//---- Assert Basic externs
#include <PlusBotRecon.mqh>
#include <Telegram.mqh>
#include <TradeCmdsMql4.mqh>

//|-----------------------------------------------------------------------------------------|
//|                               M A I N   P R O C E D U R E                               |
//|-----------------------------------------------------------------------------------------|
class CPlusBotRecon: public CCustomBot
{
public:
   void ProcessMessages(void)
   {
      string msg=NL;
      const string strOrderTrade="/ordertrade";
      const string strHistoryTicket="/historyticket";

      int pos=0, ticket=0;
      for( int i=0; i<m_chats.Total(); i++ ) {
         CCustomChat *chat=m_chats.GetNodeAtIndex(i);
         
         if( !chat.m_new_one.done ) {
            chat.m_new_one.done=true;
            
            string text=chat.m_new_one.message_text;
            
            if( text=="/ordertotal" ) {
               SendMessage( chat.m_id, BotOrdersTotal() );
            }
            
            if( StringFind( text, strOrderTrade )>=0 ) {
               pos = StringToInteger( StringSubstr( text, StringLen(strOrderTrade)+1 ) );
               SendMessage( chat.m_id, BotOrdersTrade(pos) );
            }

            if( text=="/historytotal" ) {
               SendMessage( chat.m_id, BotOrdersHistoryTotal() );
            }

            if( StringFind( text, strHistoryTicket )>=0 ) {
               ticket = StringToInteger( StringSubstr( text, StringLen(strHistoryTicket)+1 ) );
               SendMessage( chat.m_id, BotHistoryTicket(ticket) );
            }
            
            if( text=="/account" ) {
               SendMessage( chat.m_id, BotAccount() );
            }
            
            msg = StringConcatenate(msg,"My commands list:",NL);
            msg = StringConcatenate(msg,"/ordertotal-return count of orders",NL);
            msg = StringConcatenate(msg,"/ordertrade-return ALL opened orders",NL);
            msg = StringConcatenate(msg,"/orderticket <ticket>-return an order or a chain of history by ticket",NL);
            msg = StringConcatenate(msg,"/historytotal-return count of history",NL);
            msg = StringConcatenate(msg,"/historyticket <ticket>-return a history or chain of history by ticket",NL);
            msg = StringConcatenate(msg,"/account-return account info",NL);
            msg = StringConcatenate(msg,"/help-get help");
            if( text=="/help" ) {
               SendMessage( chat.m_id, msg );
            }

            /**
            * Handle '/ordersend' command
            *
            * Sample format of the /ordersend command:
            * /ordersend
            * SYMBOL: EURUSD
            * ACTION: BUY
            * ENTRY: 12345
            * SL: 12345
            * TPS: 12345,54321,011223
            */
            if (StringFind(text, "/ordersend") >= 0) {
               
               do {
                  string lines[];
                  int lines_count = StringSplit(text, StringGetCharacter("\n", 0), lines);
                  if (lines_count <= 0) {
                     break;
                  }
                  int tp_count = 0;
                  string symbol, action, entry, sl, tp[50];
                  for (int j = 0; j < lines_count; j++) {
                     if (StringFind(lines[j], ":") >= 0) {
                        string line_tokens[];
                        int tokens_count = StringSplit(lines[j], StringGetCharacter(":", 0), line_tokens);
                        if (tokens_count != 2) {
                           break;
                        }

                        string trimmed = StringTrimRight(line_tokens[1]);
                        trimmed = StringTrimLeft(trimmed);
                        StringToUpper(trimmed);
                        
                        if (StringFind(line_tokens[0], "SYMBOL") >= 0) {
                           symbol = trimmed;
                        }
            	         if (StringFind(line_tokens[0], "ACTION") >= 0) {
                           action = trimmed;
                        }
                        if (StringFind(line_tokens[0], "ENTRY") >= 0) {
                           entry = trimmed;
                        }
                        if (StringFind(line_tokens[0], "SL") >= 0) {
                           sl = trimmed;
                        }
                        if (StringFind(line_tokens[0], "TPS") >= 0) {
                           string tp_tokens[];
                           tp_count = StringSplit(line_tokens[1], StringGetCharacter(",", 0), tp_tokens);
                           if (tp_count <= 0) {
                              break;
                           }
                           for (int k = 0; k < tp_count; k++) {
                              string tp_trimmed = StringTrimRight(tp_tokens[k]);
                              tp_trimmed = StringTrimLeft(tp_trimmed);
                              StringToUpper(tp_trimmed);
                              tp[k] = tp_trimmed;
                           }
                        }
                     }
                  }
                  
                  string sigmsg = NL;
                  sigmsg = StringConcatenate(sigmsg, "[TRADE ENTERED]", NL);
                  sigmsg = StringConcatenate(sigmsg, "SYMBOL: ", symbol, NL);
                  sigmsg = StringConcatenate(sigmsg, "ACTION: ", action, NL);
                  sigmsg = StringConcatenate(sigmsg, "ENTRY: ", entry, NL);
                  sigmsg = StringConcatenate(sigmsg, "SL: ", sl, NL);
                  for (int l = 0; l < tp_count; l++) {
                     sigmsg = StringConcatenate(sigmsg, "TP", l + 1, ": ", tp[l], NL);
                  }
                  SendMessage( chat.m_id, sigmsg );
               } while (false);
            }
         }
      }
   }
};