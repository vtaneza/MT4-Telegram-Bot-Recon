//+------------------------------------------------------------------+
//|                                                       Common.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property strict

#include <stderror.mqh>

//+------------------------------------------------------------------+
//|   Define                                                         |
//+------------------------------------------------------------------+
#define sec_wait_context            10
#define max_errors                  30
#define wait_error                  1000
#define busysleep                   100
#define EB_NEXTTRY                  0
#define EB_WAITTRY                  1
#define EB_TERMINATE                2
#define CUSTOM_ERROR_FIRST          ERR_USER_ERROR_FIRST
#define ERR_JSON_PARSING            ERR_USER_ERROR_FIRST+1
#define ERR_JSON_NOT_OK             ERR_USER_ERROR_FIRST+2
#define ERR_TOKEN_ISEMPTY           ERR_USER_ERROR_FIRST+3
#define ERR_RUN_LIMITATION          ERR_USER_ERROR_FIRST+4
//---
#define ERR_NOT_ACTIVE              ERR_USER_ERROR_FIRST+100
#define ERR_NOT_CONNECTED           ERR_USER_ERROR_FIRST+101
#define ERR_ORDER_SELECT            ERR_USER_ERROR_FIRST+102
#define ERR_INVALID_ORDER_TYPE      ERR_USER_ERROR_FIRST+103
#define ERR_INVALID_SYMBOL_NAME     ERR_USER_ERROR_FIRST+104
#define ERR_INVALID_EXPIRATION_TIME ERR_USER_ERROR_FIRST+105
#define ERR_HTTP_ERROR_FIRST        ERR_USER_ERROR_FIRST+1000 //+511
//+------------------------------------------------------------------+
//|   ENUM_LANGUAGES                                                 |
//+------------------------------------------------------------------+
enum ENUM_LANGUAGES
  {
   LANGUAGE_EN,// English
   LANGUAGE_RU // Russian
  };
//+------------------------------------------------------------------+
//|   ENUM_UPDATE_MODE                                               |
//+------------------------------------------------------------------+
enum ENUM_UPDATE_MODE
  {
   UPDATE_FAST,   //Fast
   UPDATE_NORMAL, //Normal
   UPDATE_SLOW,   //Slow
  };
//+------------------------------------------------------------------+
//|   ENUM_RUN_MODE                                                  |
//+------------------------------------------------------------------+
enum ENUM_RUN_MODE
  {
   RUN_OPTIMIZATION,
   RUN_VISUAL,
   RUN_TESTER,
   RUN_LIVE
  };
//+------------------------------------------------------------------+
//|   GetRunMode                                                     |
//+------------------------------------------------------------------+
ENUM_RUN_MODE GetRunMode(void)
  {
   if(MQLInfoInteger(MQL_OPTIMIZATION))

      return(RUN_OPTIMIZATION);
   if(MQLInfoInteger(MQL_VISUAL_MODE))
      return(RUN_VISUAL);
   if(MQLInfoInteger(MQL_TESTER))
      return(RUN_TESTER);
   return(RUN_LIVE);
  }
//+------------------------------------------------------------------+
//|   ENUM_ERROR_LEVEL                                               |
//+------------------------------------------------------------------+
enum ENUM_ERROR_LEVEL
  {
   LEVEL_INFO,
   LEVEL_WARNING,
   LEVEL_ERROR,
   LEVEL_CRITICAL
  };

enum ENUM_TRADE_ACTION
  {
    TRADE_ACTION_BUY = 0,
    TRADE_ACTION_SELL,
    TRADE_ACTION_BUYLIMIT,
    TRADE_ACTION_SELLLIMIT,
    TRADE_ACTION_BUYSTOP,
    TRADE_ACTION_SELLSTOP
  };

//+------------------------------------------------------------------+
//|   CustomInfo                                                     |
//+------------------------------------------------------------------+
struct CustomInfo
  {
   string            text1;
   string            text2;
   color             colour;
   ENUM_ERROR_LEVEL  level;
  };
//+------------------------------------------------------------------+
//|   ErrorInfo                                                      |
//+------------------------------------------------------------------+
struct ErrorInfo
  {
   int               code;
   string            desc;
   ENUM_ERROR_LEVEL  level;
   ENUM_LANGUAGES    lang;
  };
  
//+------------------------------------------------------------------+
//|   OrderInfo                                                      |
//+------------------------------------------------------------------+
struct OrderParams
  {
    string            symbol_alias;
    double            lot;
    int               max_slippage;
    int               command_attempts;
    int               initial_magic;
  };

struct OrderInfo
  {
   string             symbol;
   ENUM_TRADE_ACTION  action;
   double             price;
   double             sl;
   double             tp[20];
   int                tp_count;
  };
  
//+------------------------------------------------------------------+
//|   GetErrorInfo                                                   |
//+------------------------------------------------------------------+
bool GetErrorInfo(ErrorInfo &info)
  {

   info.level=LEVEL_INFO;

   if(info.lang==LANGUAGE_EN)
     {

      switch(info.code)
        {
         case ERR_NOT_CONNECTED:                info.desc="No connection with server"; info.level=LEVEL_ERROR; break;
         case ERR_JSON_PARSING:                 info.desc="JSON parsing error";  info.level=LEVEL_ERROR; break;
         case ERR_JSON_NOT_OK:                  info.desc="JSON parsing not OK"; info.level=LEVEL_ERROR; break;
         case ERR_TOKEN_ISEMPTY:                info.desc="Token is empty"; info.level=LEVEL_ERROR; break;
         case ERR_RUN_LIMITATION:               info.desc="The bot does not run in tester mode"; info.level=LEVEL_ERROR; break;

         case ERR_WEBREQUEST_INVALID_ADDRESS:   info.desc="Invalid URL"; break;
         case ERR_WEBREQUEST_CONNECT_FAILED:    info.desc="Failed to connect to specified URL"; break;
         case ERR_WEBREQUEST_TIMEOUT:           info.desc="Timeout exceeded"; break;
         case ERR_WEBREQUEST_REQUEST_FAILED:    info.desc="HTTP request failed"; break;

#ifdef __MQL4__
         case ERR_FUNCTION_NOT_CONFIRMED:       info.desc="URL does not allowed for WebRequest"; break;
#endif

#ifdef __MQL5__
         case ERR_FUNCTION_NOT_ALLOWED:         info.desc="URL does not allowed for WebRequest"; break;
         case ERR_FILE_NOT_EXIST:               info.desc="File is not exists"; break;
         case ERR_CHART_NOT_FOUND:              info.desc="Chart not found"; break;
         case ERR_SUCCESS:                      info.desc="The operation completed successfully"; break;
#endif         
         //---
         case ERR_HTTP_ERROR_FIRST+100:         info.desc="Continue"; break;
         case ERR_HTTP_ERROR_FIRST+101:         info.desc="Switching Protocols"; break;
         case ERR_HTTP_ERROR_FIRST+103:         info.desc="Checkpoint"; break;
         case ERR_HTTP_ERROR_FIRST+200:         info.desc="OK"; break;
         case ERR_HTTP_ERROR_FIRST+201:         info.desc="Created"; break;
         case ERR_HTTP_ERROR_FIRST+202:         info.desc="Accepted"; break;
         case ERR_HTTP_ERROR_FIRST+203:         info.desc="Non-Authoritative Information"; break;
         case ERR_HTTP_ERROR_FIRST+204:         info.desc="No Content"; break;
         case ERR_HTTP_ERROR_FIRST+205:         info.desc="Reset Content"; break;
         case ERR_HTTP_ERROR_FIRST+206:         info.desc="Partial Content"; break;
         case ERR_HTTP_ERROR_FIRST+300:         info.desc="Multiple Choices"; break;
         case ERR_HTTP_ERROR_FIRST+301:         info.desc="Moved Permanently"; break;
         case ERR_HTTP_ERROR_FIRST+302:         info.desc="Found"; break;
         case ERR_HTTP_ERROR_FIRST+303:         info.desc="See Other"; break;
         case ERR_HTTP_ERROR_FIRST+304:         info.desc="Not Modified"; break;
         case ERR_HTTP_ERROR_FIRST+306:         info.desc="Switch Proxy"; break;
         case ERR_HTTP_ERROR_FIRST+307:         info.desc="Temporary Redirect"; break;
         case ERR_HTTP_ERROR_FIRST+308:         info.desc="Resume Incomplete"; break;
         case ERR_HTTP_ERROR_FIRST+400:         info.desc="Bad Request"; break;
         case ERR_HTTP_ERROR_FIRST+401:         info.desc="Unauthorized"; break;
         case ERR_HTTP_ERROR_FIRST+402:         info.desc="Payment Required"; break;
         case ERR_HTTP_ERROR_FIRST+403:         info.desc="Forbidden"; break;
         case ERR_HTTP_ERROR_FIRST+404:         info.desc="Not Found"; break;
         case ERR_HTTP_ERROR_FIRST+405:         info.desc="Method Not Allowed"; break;
         case ERR_HTTP_ERROR_FIRST+406:         info.desc="Not Acceptable"; break;
         case ERR_HTTP_ERROR_FIRST+407:         info.desc="Proxy Authentication Required"; break;
         case ERR_HTTP_ERROR_FIRST+408:         info.desc="Request Timeout"; break;
         case ERR_HTTP_ERROR_FIRST+409:         info.desc="Conflict"; break;
         case ERR_HTTP_ERROR_FIRST+410:         info.desc="Gone"; break;
         case ERR_HTTP_ERROR_FIRST+411:         info.desc="Length Required"; break;
         case ERR_HTTP_ERROR_FIRST+412:         info.desc="Precondition Failed"; break;
         case ERR_HTTP_ERROR_FIRST+413:         info.desc="Request Entity Too Large"; break;
         case ERR_HTTP_ERROR_FIRST+414:         info.desc="Request-URI Too Long"; break;
         case ERR_HTTP_ERROR_FIRST+415:         info.desc="Unsupported Media Type"; break;
         case ERR_HTTP_ERROR_FIRST+416:         info.desc="Requested Range Not Satisfiable"; break;
         case ERR_HTTP_ERROR_FIRST+417:         info.desc="Expectation Failed"; break;
         case ERR_HTTP_ERROR_FIRST+500:         info.desc="Internal Server Error"; break;
         case ERR_HTTP_ERROR_FIRST+501:         info.desc="Not Implemented"; break;
         case ERR_HTTP_ERROR_FIRST+502:         info.desc="Bad Gateway"; break;
         case ERR_HTTP_ERROR_FIRST+503:         info.desc="Service Unavailable"; break;
         case ERR_HTTP_ERROR_FIRST+504:         info.desc="Gateway Timeout"; break;
         case ERR_HTTP_ERROR_FIRST+505:         info.desc="HTTP Version Not Supported"; break;
         case ERR_HTTP_ERROR_FIRST+511:         info.desc="Network Authentication Required"; break;

         //--- The error codes returned by trade server:
#ifdef __MQL4__         
         case ERR_NO_ERROR:                     info.desc="No error"; break;
         case ERR_NO_RESULT:                    info.desc="No error returned, but the result is unknown"; info.level=LEVEL_WARNING; break;
         case ERR_COMMON_ERROR:                 info.desc="Common error."; info.level=LEVEL_WARNING; break;
         case ERR_INVALID_TRADE_PARAMETERS:     info.desc="Invalid trade parameters"; info.level=LEVEL_WARNING; break;
         case ERR_SERVER_BUSY:                  info.desc="Trade server is busy"; info.level=LEVEL_WARNING; break;
         case ERR_OLD_VERSION:                  info.desc="Old version of the client terminal"; info.level=LEVEL_WARNING; break;
         case ERR_NO_CONNECTION:                info.desc="No connection with trade server"; info.level=LEVEL_WARNING; break;
         case ERR_NOT_ENOUGH_RIGHTS:            info.desc="Not enough rights"; info.level=LEVEL_WARNING; break;
         case ERR_TOO_FREQUENT_REQUESTS:        info.desc="Too frequent requests"; info.level=LEVEL_WARNING; break;
         case ERR_MALFUNCTIONAL_TRADE:          info.desc="Malfunctional trade operation"; info.level=LEVEL_WARNING; break;
         case ERR_ACCOUNT_DISABLED:             info.desc="Account disabled"; info.level= LEVEL_ERROR; break;
         case ERR_INVALID_ACCOUNT:              info.desc="Invalid account"; info.level= LEVEL_WARNING; break;
         case ERR_TRADE_TIMEOUT:                info.desc="Trade timeout"; info.level=LEVEL_WARNING; break;
         case ERR_INVALID_PRICE:                info.desc="Invalid price"; info.level= LEVEL_WARNING; break;
         case ERR_INVALID_STOPS:                info.desc="Invalid stops"; info.level= LEVEL_WARNING; break;
         case ERR_INVALID_TRADE_VOLUME:         info.desc="Invalid trade volume"; info.level=LEVEL_WARNING; break;
         case ERR_MARKET_CLOSED:                info.desc="Market is closed"; info.level=LEVEL_ERROR; break;
         case ERR_TRADE_DISABLED:               info.desc="Trade is disabled"; info.level=LEVEL_ERROR; break;
         case ERR_NOT_ENOUGH_MONEY:             info.desc="Not enough money"; info.level=LEVEL_ERROR; break;
         case ERR_PRICE_CHANGED:                info.desc="Price changed"; info.level=LEVEL_WARNING; break;
         case ERR_OFF_QUOTES:                   info.desc="Off quotes"; info.level=LEVEL_WARNING; break;
         case ERR_BROKER_BUSY:                  info.desc="Broker is busy"; info.level=LEVEL_WARNING; break;
         case ERR_REQUOTE:                      info.desc="Requote"; info.level=LEVEL_WARNING; break;
         case ERR_ORDER_LOCKED:                 info.desc="Order is locked"; info.level=LEVEL_WARNING; break;
         case ERR_LONG_POSITIONS_ONLY_ALLOWED:  info.desc="Long positions only allowed"; info.level=LEVEL_WARNING; break;
         case ERR_TOO_MANY_REQUESTS:            info.desc="Too many requests"; info.level=LEVEL_WARNING; break;
         case ERR_TRADE_MODIFY_DENIED:          info.desc="Modification denied because order too close to market"; info.level=LEVEL_WARNING; break;
         case ERR_TRADE_CONTEXT_BUSY:           info.desc="Trade context is busy"; info.level=LEVEL_WARNING; break;
         case ERR_TRADE_EXPIRATION_DENIED:      info.desc="Expirations are denied by broker"; info.level=LEVEL_WARNING; break;
         case ERR_TRADE_TOO_MANY_ORDERS:        info.desc="The amount of open and pending orders has reached the limit set by the broker"; info.level=LEVEL_ERROR; break;
         case ERR_TRADE_HEDGE_PROHIBITED:       info.desc="An attempt to open a position opposite to the existing one when hedging is disabled"; info.level=LEVEL_ERROR; break;
         case ERR_TRADE_PROHIBITED_BY_FIFO:     info.desc="An attempt to close a position contravening the FIFO rule"; info.level=LEVEL_WARNING; break;
         //--- MQL4 run time error codes
         case ERR_TRADE_NOT_ALLOWED:            info.desc="Trade is not allowed. Enable checkbox (Allow live trading) in the expert properties"; info.level=LEVEL_WARNING; break;
         case ERR_LONGS_NOT_ALLOWED:            info.desc="Longs are not allowed. Check the expert properties"; info.level=LEVEL_ERROR; break;
         case ERR_SHORTS_NOT_ALLOWED:           info.desc="Shorts are not allowed. Check the expert properties"; info.level=LEVEL_ERROR; break;
#endif

         //---
         case ERR_INVALID_ORDER_TYPE:           info.desc="Invalid order type"; info.level=LEVEL_ERROR; break;
         case ERR_INVALID_SYMBOL_NAME:          info.desc="Invalid symbol name"; info.level=LEVEL_ERROR; break;
         case ERR_INVALID_EXPIRATION_TIME:      info.desc="Invalid expiration time"; info.level=LEVEL_ERROR; break;
         case ERR_ORDER_SELECT:                 info.desc="Error function OrderSelect()"; info.level=LEVEL_ERROR; break;
         //---

         default:
            info.desc="Unknown error "+IntegerToString(info.code);
            return(false);

        }
     }

//---
   if(info.lang==LANGUAGE_RU)
     {
      switch(info.code)
        {
         case ERR_NOT_ACTIVE:                   info.desc="Нет лицензии"; break;
         case ERR_NOT_CONNECTED:                info.desc="Нет соединения с торговым сервером"; break;

         case ERR_JSON_PARSING:                 info.desc="Ошибка JSON структуры ответа";info.level=LEVEL_ERROR; break;
         case ERR_JSON_NOT_OK:                  info.desc="Парсинг JSON завершен с ошибкой";info.level=LEVEL_ERROR; break;
         case ERR_TOKEN_ISEMPTY:                info.desc="Токен-пустая строка"; info.level=LEVEL_ERROR; break;
         case ERR_RUN_LIMITATION:               info.desc="Бот не работает в тестере стратегий"; info.level=LEVEL_ERROR; break;

         //---
         case ERR_WEBREQUEST_INVALID_ADDRESS:   info.desc="URL не прошел проверку"; break;
         case ERR_WEBREQUEST_CONNECT_FAILED:    info.desc="Не удалось подключиться к указанному URL"; break;
         case ERR_WEBREQUEST_TIMEOUT:           info.desc="Превышен таймаут получения данных"; break;
         case ERR_WEBREQUEST_REQUEST_FAILED:    info.desc="Ошибка в результате выполнения HTTP запроса"; break;

#ifdef __MQL4__         
         case ERR_FUNCTION_NOT_CONFIRMED:       info.desc="URL нет в списке для WebRequest"; break;
#endif         

#ifdef __MQL5__
         case ERR_FUNCTION_NOT_ALLOWED:         info.desc="URL нет в списке для WebRequest"; break;
         case ERR_FILE_NOT_EXIST:               info.desc="Файла не существует"; break;
         case ERR_CHART_NOT_FOUND:              info.desc="График не найден"; break;
         case ERR_SUCCESS:                      info.desc="Операция выполнена успешно"; break;
#endif
         //---
         case ERR_HTTP_ERROR_FIRST+100:         info.desc="Continue"; break;
         case ERR_HTTP_ERROR_FIRST+101:         info.desc="Switching Protocols"; break;
         case ERR_HTTP_ERROR_FIRST+103:         info.desc="Checkpoint"; break;
         case ERR_HTTP_ERROR_FIRST+200:         info.desc="OK"; break;
         case ERR_HTTP_ERROR_FIRST+201:         info.desc="Created"; break;
         case ERR_HTTP_ERROR_FIRST+202:         info.desc="Accepted"; break;
         case ERR_HTTP_ERROR_FIRST+203:         info.desc="Non-Authoritative Information"; break;
         case ERR_HTTP_ERROR_FIRST+204:         info.desc="No Content"; break;
         case ERR_HTTP_ERROR_FIRST+205:         info.desc="Reset Content"; break;
         case ERR_HTTP_ERROR_FIRST+206:         info.desc="Partial Content"; break;
         case ERR_HTTP_ERROR_FIRST+300:         info.desc="Multiple Choices"; break;
         case ERR_HTTP_ERROR_FIRST+301:         info.desc="Moved Permanently"; break;
         case ERR_HTTP_ERROR_FIRST+302:         info.desc="Found"; break;
         case ERR_HTTP_ERROR_FIRST+303:         info.desc="See Other"; break;
         case ERR_HTTP_ERROR_FIRST+304:         info.desc="Not Modified"; break;
         case ERR_HTTP_ERROR_FIRST+306:         info.desc="Switch Proxy"; break;
         case ERR_HTTP_ERROR_FIRST+307:         info.desc="Temporary Redirect"; break;
         case ERR_HTTP_ERROR_FIRST+308:         info.desc="Resume Incomplete"; break;
         case ERR_HTTP_ERROR_FIRST+400:         info.desc="Bad Request"; break;
         case ERR_HTTP_ERROR_FIRST+401:         info.desc="Unauthorized"; break;
         case ERR_HTTP_ERROR_FIRST+402:         info.desc="Payment Required"; break;
         case ERR_HTTP_ERROR_FIRST+403:         info.desc="Forbidden"; break;
         case ERR_HTTP_ERROR_FIRST+404:         info.desc="Not Found"; break;
         case ERR_HTTP_ERROR_FIRST+405:         info.desc="Method Not Allowed"; break;
         case ERR_HTTP_ERROR_FIRST+406:         info.desc="Not Acceptable"; break;
         case ERR_HTTP_ERROR_FIRST+407:         info.desc="Proxy Authentication Required"; break;
         case ERR_HTTP_ERROR_FIRST+408:         info.desc="Request Timeout"; break;
         case ERR_HTTP_ERROR_FIRST+409:         info.desc="Conflict"; break;
         case ERR_HTTP_ERROR_FIRST+410:         info.desc="Gone"; break;
         case ERR_HTTP_ERROR_FIRST+411:         info.desc="Length Required"; break;
         case ERR_HTTP_ERROR_FIRST+412:         info.desc="Precondition Failed"; break;
         case ERR_HTTP_ERROR_FIRST+413:         info.desc="Request Entity Too Large"; break;
         case ERR_HTTP_ERROR_FIRST+414:         info.desc="Request-URI Too Long"; break;
         case ERR_HTTP_ERROR_FIRST+415:         info.desc="Unsupported Media Type"; break;
         case ERR_HTTP_ERROR_FIRST+416:         info.desc="Requested Range Not Satisfiable"; break;
         case ERR_HTTP_ERROR_FIRST+417:         info.desc="Expectation Failed"; break;
         case ERR_HTTP_ERROR_FIRST+500:         info.desc="Internal Server Error"; break;
         case ERR_HTTP_ERROR_FIRST+501:         info.desc="Not Implemented"; break;
         case ERR_HTTP_ERROR_FIRST+502:         info.desc="Bad Gateway"; break;
         case ERR_HTTP_ERROR_FIRST+503:         info.desc="Service Unavailable"; break;
         case ERR_HTTP_ERROR_FIRST+504:         info.desc="Gateway Timeout"; break;
         case ERR_HTTP_ERROR_FIRST+505:         info.desc="HTTP Version Not Supported"; break;
         case ERR_HTTP_ERROR_FIRST+511:         info.desc="Network Authentication Required"; break;

         //---
#ifdef __MQL4__         
         case ERR_NO_ERROR:                     info.desc="Нет ошибки"; break;
         case ERR_NO_RESULT:                    info.desc="Нет ошибки, но результат неизвестен"; info.level=LEVEL_WARNING; break;
         case ERR_COMMON_ERROR:                 info.desc="Общая ошибка"; info.level=LEVEL_WARNING; break;
         case ERR_INVALID_TRADE_PARAMETERS:     info.desc="Неправильные параметры"; info.level=LEVEL_WARNING; break;
         case ERR_SERVER_BUSY:                  info.desc="Торговый сервер занят"; info.level=LEVEL_WARNING; break;
         case ERR_OLD_VERSION:                  info.desc="Старая версия клиентского терминала"; info.level=LEVEL_WARNING; break;
         case ERR_NO_CONNECTION:                info.desc="Нет связи с торговым сервером"; info.level=LEVEL_WARNING; break;
         case ERR_NOT_ENOUGH_RIGHTS:            info.desc="Недостаточно прав"; info.level=LEVEL_WARNING; break;
         case ERR_TOO_FREQUENT_REQUESTS:        info.desc="Слишком частые запросы"; info.level=LEVEL_WARNING; break;
         case ERR_MALFUNCTIONAL_TRADE:          info.desc="Недопустимая операция нарушающая функционирование сервера"; info.level=LEVEL_WARNING; break;
         case ERR_ACCOUNT_DISABLED:             info.desc="Счет заблокирован"; info.level= LEVEL_ERROR; break;
         case ERR_INVALID_ACCOUNT:              info.desc="Неправильный номер счета"; info.level= LEVEL_WARNING; break;
         case ERR_TRADE_TIMEOUT:                info.desc="Истек срок ожидания совершения сделки"; info.level=LEVEL_WARNING; break;
         case ERR_INVALID_PRICE:                info.desc="Неправильная цена"; info.level= LEVEL_WARNING; break;
         case ERR_INVALID_STOPS:                info.desc="Неправильные стопы"; info.level= LEVEL_WARNING; break;
         case ERR_INVALID_TRADE_VOLUME:         info.desc="Неправильный объем"; info.level=LEVEL_WARNING; break;
         case ERR_MARKET_CLOSED:                info.desc="Рынок закрыт"; info.level=LEVEL_ERROR; break;
         case ERR_TRADE_DISABLED:               info.desc="Торговля запрещена"; info.level=LEVEL_ERROR; break;
         case ERR_NOT_ENOUGH_MONEY:             info.desc="Недостаточно денег для совершения операции"; info.level=LEVEL_ERROR; break;
         case ERR_PRICE_CHANGED:                info.desc="Цена изменилась"; info.level=LEVEL_WARNING; break;
         case ERR_OFF_QUOTES:                   info.desc="Нет цен"; info.level=LEVEL_WARNING; break;
         case ERR_BROKER_BUSY:                  info.desc="Брокер занят"; info.level=LEVEL_WARNING; break;
         case ERR_REQUOTE:                      info.desc="Новые цены"; info.level=LEVEL_WARNING; break;
         case ERR_ORDER_LOCKED:                 info.desc="Ордер заблокирован и уже обрабатывается"; info.level=LEVEL_WARNING; break;
         case ERR_LONG_POSITIONS_ONLY_ALLOWED:  info.desc="Разрешена только покупка"; info.level=LEVEL_WARNING; break;
         case ERR_TOO_MANY_REQUESTS:            info.desc="Слишком много запросов"; info.level=LEVEL_WARNING; break;
         case ERR_TRADE_MODIFY_DENIED:          info.desc="Модификация запрещена, так как ордер слишком близок к рынку"; info.level=LEVEL_WARNING; break;
         case ERR_TRADE_CONTEXT_BUSY:           info.desc="Подсистема торговли занята"; info.level=LEVEL_WARNING; break;
         case ERR_TRADE_EXPIRATION_DENIED:      info.desc="Использование даты истечения ордера запрещено брокером"; info.level=LEVEL_WARNING; break;
         case ERR_TRADE_TOO_MANY_ORDERS:        info.desc="Количество открытых и отложенных ордеров достигло предела, установленного брокером."; info.level=LEVEL_ERROR; break;
         case ERR_TRADE_HEDGE_PROHIBITED:       info.desc="Попытка открыть противоположную позицию к уже существующей в случае, если хеджирование запрещено"; info.level=LEVEL_ERROR; break;
         case ERR_TRADE_PROHIBITED_BY_FIFO:     info.desc="Попытка закрыть позицию по инструменту в противоречии с правилом FIFO"; info.level=LEVEL_WARNING; break;
         //--- MQL4 run time error codes
         case ERR_TRADE_NOT_ALLOWED:            info.desc="Торговля не разрешена. Необходимо включить опцию `Разрешить советнику торговать` в свойствах эксперта"; info.level=LEVEL_WARNING; break;
         case ERR_LONGS_NOT_ALLOWED:            info.desc="Ордера на покупку не разрешены. Необходимо проверить свойства эксперта"; info.level=LEVEL_ERROR; break;
         case ERR_SHORTS_NOT_ALLOWED:           info.desc="Ордера на продажу не разрешены. Необходимо проверить свойства эксперта"; info.level=LEVEL_ERROR; break;
#endif
         //---  торговые 
         case ERR_INVALID_ORDER_TYPE:           info.desc="Неправильный тип ордера"; info.level=LEVEL_ERROR; break;
         case ERR_INVALID_SYMBOL_NAME:          info.desc="Неправильное имя инструмента"; info.level=LEVEL_ERROR; break;
         case ERR_INVALID_EXPIRATION_TIME:      info.desc="Неправильное время экспирации"; info.level=LEVEL_ERROR; break;
         case ERR_ORDER_SELECT:                 info.desc="Ошибка функции OrderSelect()"; info.level=LEVEL_ERROR; break;

         //---
         default:
            info.desc="Неизвестная ошибка "+IntegerToString(info.code);
            return(false);
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetErrorDescription(const int _error_code,
                           const ENUM_LANGUAGES _language=LANGUAGE_EN)
  {
   ErrorInfo info;
   info.code=_error_code;
   info.lang=_language;

   GetErrorInfo(info);

   return(info.desc);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_ERROR_LEVEL GetErrorLevel(const int _error_code)
  {
   ErrorInfo info;
   info.code=_error_code;
   info.lang=LANGUAGE_EN;

   GetErrorInfo(info);
   return(info.level);
  }
//+------------------------------------------------------------------+
//|   PrintError                                                     |
//+------------------------------------------------------------------+
ENUM_ERROR_LEVEL PrintError(int _error_code,const ENUM_LANGUAGES _lang=LANGUAGE_EN)
  {
   ErrorInfo info;
   info.code=_error_code;
   info.lang=_lang;
//---
   GetErrorInfo(info);
//---
   if(_lang==LANGUAGE_RU)
      printf("Ошибка: %s",info.desc);
   else
      printf("Error: %s",info.desc);
//---
   return(info.level);
  }
//+------------------------------------------------------------------+

string EnumTradeActionToStr(ENUM_TRADE_ACTION action)
  {
    string strAction = "";
    if(action == TRADE_ACTION_BUY)
      {
        strAction ="BUY";
      }
    else if (action == TRADE_ACTION_SELL)
      {
        strAction = "SELL";
      }
    else if (action == TRADE_ACTION_BUYLIMIT)
      {
        strAction = "BUY LIMIT";
      }
    else if (action == TRADE_ACTION_SELLLIMIT)
      {
        strAction = "SELL LIMIT";
      }
    else if (action == TRADE_ACTION_BUYSTOP)
      {
        strAction = "BUY STOP";
      }
    else if (action == TRADE_ACTION_SELLSTOP)
      {
        strAction = "SELL STOP";
      }
    
    return strAction;
  }

ENUM_TRADE_ACTION StrTradeActionToEnum(string strAction)
  {
    ENUM_TRADE_ACTION action = -1;
    if(strAction == "BUY")
      {
        action = TRADE_ACTION_BUY;
      }
    else if (strAction == "SELL")
      {
        action = TRADE_ACTION_SELL;
      }
    else if (strAction == "BUY LIMIT")
      {
        action = TRADE_ACTION_BUYLIMIT;
      }
    else if (strAction == "SELL LIMIT")
      {
        action = TRADE_ACTION_SELLLIMIT;
      }
    else if (strAction == "BUY STOP")
      {
        action = TRADE_ACTION_BUYSTOP;
      }
    else if (strAction == "SELL STOP")
      {
        action = TRADE_ACTION_SELLSTOP;
      }
    
    return action;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int _IsNotTradeContextBusy()
  {
   if(IsTradeContextBusy())
     {
      int StartWaitingTime = GetTickCount();
      Print("Trade context is busy. Waiting...");
    
      while(true)
        {
         if(GetTickCount() - StartWaitingTime > sec_wait_context * 1000)
           {
            Print("Waiting limit exceeded (" + sec_wait_context + " sec.)!");
            return(-2);
           }
         if(!IsTradeContextBusy())
           {
            return(0);
           }
         Sleep(busysleep);
        }
     }
   else
     {
      return(1);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ErrorBlock(int err, int ms)
  {
   string str = "" ;
   int res = EB_TERMINATE ;

   switch(err)
     {
      case ERR_NO_ERROR:
         str = "No error" ;

         break ;
      case ERR_NO_RESULT:
         str = "Unknown result" ;

         break ;
      case ERR_COMMON_ERROR:
         str = "Common error. Probably the signal was rejected by user or trade direction is denied in expert settings" ;
         
         break ;
      case ERR_INVALID_TRADE_PARAMETERS:
         str = "Wrong trade function parameters" ;

         break ;
      case ERR_SERVER_BUSY:
         str = "Server is busy. Waiting..." ;
         res = EB_WAITTRY ;

         break ;
      case ERR_OLD_VERSION:
         str = "Old version of client terminal" ;

         break ;
      case ERR_NO_CONNECTION:
         str = "No connection with trade server. Waiting..." ;
         res = EB_WAITTRY ;

         break ;
      case ERR_NOT_ENOUGH_RIGHTS:
         str = "Not enough rights" ;

         break ;
      case ERR_TOO_MANY_REQUESTS:
      case ERR_TOO_FREQUENT_REQUESTS:
         str = "To many requests" ;

         break ;
      case ERR_MALFUNCTIONAL_TRADE:
         str = "Malfunctional trade" ;

         break ;
      case ERR_ACCOUNT_DISABLED:
         str = "The account is blocked" ;

         break ;
      case ERR_INVALID_ACCOUNT:
         str = "Invalid account" ;

         break ;
      case ERR_TRADE_TIMEOUT:
         str = "Trade timeout exceeded" ;
         res = EB_NEXTTRY ;

         break ;
      case ERR_INVALID_PRICE:
         str = "Wrong price" ;
         res = EB_NEXTTRY ;

         break ;
      case ERR_INVALID_STOPS:
         str = "Invalid stops" ;

         break ;
      case ERR_INVALID_TRADE_VOLUME:
         str = "Invalid trade volume" ;

         break ;
      case ERR_MARKET_CLOSED:
         str = "The market is closed" ;

         break ;
      case ERR_TRADE_DISABLED:
         str = "Trade is disabled" ;

         break ;
      case ERR_NOT_ENOUGH_MONEY:
         str = "Not enough money to complete operation" ;

         break ;
      case ERR_PRICE_CHANGED:
         str = "The price has changed, trying again" ;
         res = EB_NEXTTRY ;

         break ;
      case ERR_OFF_QUOTES:
         str = "The broker sent offquotes. Trying again" ;
         res = EB_NEXTTRY ;

         break ;
      case ERR_BROKER_BUSY:
         str = "The broker is budy. Waiting..." ;
         res = EB_WAITTRY ;

         break ;
      case ERR_REQUOTE:
         str = "The broker sent requote. Trying again" ;
         res = EB_WAITTRY ;

         break ;
      case ERR_ORDER_LOCKED:
         str = "The order is already processing" ;

         break ;
      case ERR_LONG_POSITIONS_ONLY_ALLOWED:
         str = "Only long positions allowed" ;

         break ;
      case ERR_TRADE_MODIFY_DENIED:
         str = "Modification is denied because the order is too close to the price" ;
         res = EB_WAITTRY ;

         break ;
      case ERR_TRADE_CONTEXT_BUSY:
         if(_IsNotTradeContextBusy() >= 0)
           {
            res = EB_NEXTTRY ;
           }
         return (res) ;

      case ERR_TRADE_EXPIRATION_DENIED:
         str = "Expiration date usage is denied by the broker" ;

         break ;
      case ERR_TRADE_TOO_MANY_ORDERS:
         str = "Too many orders" ;

         break ;
      case ERR_TRADE_HEDGE_PROHIBITED:
         str = "Hedging is denied by broker" ;

         break ;
      case ERR_TRADE_PROHIBITED_BY_FIFO:
         str = "Cannot close a deal because FIFO order is violated" ;

         break ;
      case 4107:
         str = "Wrong price for OrderSend function" ;

         break ;
      case 4051:
         str = "Wrong takeprofit for OrderModify function" ;
      default:

         str = "Unknown error ? " + DoubleToStr(err, 0) ;
     }
   str = StringConcatenate(str, " (the request is processed by broker in ", DoubleToStr(GetTickCount() - ms, 0), " ms)") ;

   Print(str) ;
   return (res) ;
  }


int CustomOrderSend(OrderInfo& order, OrderParams& params, int &ticket[])
  {
    if(order.action < TRADE_ACTION_BUY || order.action > TRADE_ACTION_SELLSTOP)
      {
        PrintFormat("Wrong trade action specified: %d", order.action) ;
        return 0;
      }
    RefreshRates() ;

    int ticket_count = 0, errors = 0;
    for (int i = 0; i < order.tp_count; i++)
      {
        int attempt = 1, tick = -1 ;
        while(attempt <= params.command_attempts && tick < 0)
          {
            string str = StringConcatenate("Attempt ", DoubleToStr(attempt, 0), " of sending order '", EnumTradeActionToStr(order.action), "' ") ;
            str = StringConcatenate(str, "at price ", DoubleToStr(order.price, Digits), " stop ", DoubleToStr(order.sl, Digits), " take ", DoubleToStr(order.tp[i], Digits)) ;
            Print(str) ;

            int ms = GetTickCount() ;
            tick = OrderSend(order.symbol, order.action, params.lot, order.price, params.max_slippage, order.sl, order.tp[i], "", params.initial_magic) ;
            if(tick < 0)
              {
                errors ++ ;
                int err = GetLastError() ;
                switch(ErrorBlock(err, ms))
                  {
                    case 0: // continue
                      break ;
                    case 1: // wait and continue
                      Sleep(wait_error);
                     break ;
                    case 2: // terminate
                      return ticket_count;
                  }
              }
            else
              {
                errors = 0 ;
                OrderSelect(tick, SELECT_BY_TICKET) ;

                str = StringConcatenate("Order was opened in ", DoubleToStr(GetTickCount() - ms, 0), " ms") ;
                double r_slp ;

                if(MathAbs(OrderOpenPrice() - order.price) >= Point)
                  {
                    if(OrderType() == OP_BUY)
                      {
                        r_slp = (OrderOpenPrice() - order.price) / Point ;
                      }
                    else
                      {
                        r_slp = (order.price - OrderOpenPrice()) / Point ;
                      }
                    str = StringConcatenate(str, " with slippage ", DoubleToStr(MathAbs(r_slp), 0), " pips") ;

                    if(r_slp < 0)
                      {
                      str = StringConcatenate(str, " in our benefit") ;
                      }
                  }
                Print(str) ;
              }
            
            if(errors > max_errors)
              {
                Print("Exceeded maximum errors count while trying to send trading command.") ;
                Print("To continue you should restart terminal or the EA") ;
                return ticket_count ;
              }
            attempt ++ ;

            if(attempt > params.command_attempts && tick < 0)
              {
                Print("Exeeded maximum number of simultaneous attempts of setting an order") ;
                return ticket_count ;
              }
            RefreshRates() ;

            // save ticket number
            ticket[ticket_count++] = tick;
          }
      }
     return ticket_count;
    }


// Function to get all current trade ticket numbers
int GetCurrentTradeTicketNumbers(int &ticketNumbers[], string symbol)
  {
    int totalOrders = OrdersTotal();
    int retCount = 0;
    ArrayResize(ticketNumbers, totalOrders);

    for (int i = 0; i < totalOrders; i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
        if (StringLen(symbol) > 0) {
          if (OrderSymbol() == symbol) {
             ticketNumbers[retCount++] = OrderTicket();
          }
        } else {
          ticketNumbers[retCount++] = OrderTicket();
        }
      }
    }
    return retCount;
  }


void CloseMarketOrders(OrderParams &params)
  {
    for(int i = 1; i <= OrdersTotal(); i++)
      {
        if (OrderSelect(i - 1, SELECT_BY_POS) == false) continue;
        int orderType = OrderType();
        if (orderType > TRADE_ACTION_SELL) continue;
        double price = OrderOpenPrice();
        int ticket = OrderTicket();
        double lots = OrderLots();
        double priceClose = -1;
        string text = "Unknown ";
                                                  
        while(true)        
          {
            switch(orderType)
              {
                case TRADE_ACTION_BUY: 
                  priceClose = Bid;
                  text = "Buy ";
                  break;
                case TRADE_ACTION_SELL:
                  priceClose = Ask;
                  text = "Sell ";
              }

            Print("Attempt to close ", text, " ", ticket, ". Awaiting response..");
            bool ret = OrderClose(ticket, lots, priceClose, 2);
            if (ret)
              {
                Print("Closed order ", text, " ", ticket);
                break;
              }

            // check for non-critical errors
            int error = GetLastError();
            switch(error)
              {
                case 135:
                  Print("The price has changed. Retrying..");
                  RefreshRates();
                  continue;
                case 136:
                  Print("No prices. Waiting for a new tick..");
                  while(RefreshRates() == false)
                    Sleep(1);
                  continue;
                case 146:
                  Print("Trading subsystem is busy. Retrying..");
                  Sleep(500);
                  RefreshRates();
                  continue;
              }

            // check for critical errors
            switch(error)
              {
                case 2:
                  Print("Common error.");
                  break;
                case 5:
                  Print("Old version of the client terminal.");
                  break;
                case 64:
                  Print("Account is blocked.");
                  break;
                case 133:
                  Print("Trading is prohibited");
                  break;
                default:
                  Print("Occurred error ", error); 
              }

            break;
          }
      }
  }

  string GetBrokerSymbol(string signalSymbol, OrderParams &params)
    {
      string tokens[];
      int tokens_count = StringSplit(params.symbol_alias, StringGetCharacter(",", 0), tokens);
      for (int i = 0; i < tokens_count; i++) {
        string pair_tokens[];
        int pairs_token_count = StringSplit(tokens[i], StringGetCharacter("=", 0), pair_tokens);
        if (pairs_token_count != 2) {
          continue;
        }
        if (StringFind(pair_tokens[0], signalSymbol) >= 0) {
          return pair_tokens[1];
        }
      }
      return signalSymbol;
    }

