def is_number(s):
  '''
  Checks if string is a number (float or int)
  '''
  
  try:
    float(s)
    return True
  except ValueError:
    return False


def get_symbols(fx_majors=True, fx_crosses=True, fx_exotics=True, metals=True, indexes=True, oils=True, cryptos=True):
  
	'''
  Returns supported tradable instruments such as currency pairs, metals, indeces and crypto.
  The default function call will only return FX crosses. Please set appropriate flags accordingly
  '''
  
	forex_majors = [
		'EURUSD',  # Euro/US Dollar
		'USDJPY',  # US Dollar/Japanese Yen
		'GBPUSD',  # British Pound/US Dollar
		'USDCHF',  # US Dollar/Swiss Franc
		'AUDUSD',  # Australian Dollar/US Dollar
		'USDCAD',  # US Dollar/Canadian Dollar
		'NZDUSD',  # New Zealand Dollar/US Dollar
	]

	forex_crosses = [
		'EURGBP', # Euro / British Pound
		'EURCHF', # Euro / Swiss Franc
		'EURJPY', # Euro / Japanese Yen
		'EURAUD', # Euro / Australian Dollar
		'EURCAD', # Euro / Canadian Dollar
		'EURNZD', # Euro / New Zealand Dollar
		'GBPCHF', # British Pound / Swiss Franc
		'GBPJPY', # British Pound / Japanese Yen
		'GBPAUD', # British Pound / Australian Dollar
		'GBPCAD', # British Pound / Canadian Dollar
		'GBPNZD', # British Pound / New Zealand Dollar
		'CADJPY', # Canadian Dollar / Japanese Yen
		'AUDJPY', # Australian Dollar / Japanese Yen
		'CHFJPY', # Swiss Franc / Japanese Yen
		'NZDJPY', # New Zealand Dollar / Japanese Yen
		'CADCHF', # Canadian Dollar / Swiss Franc
		'AUDCHF', # Australian Dollar / Swiss Franc
		'NZDCHF', # New Zealand Dollar / Swiss Franc
		'AUDCAD', # Australian Dollar / Canadian Dollar
		'AUDNZD', # Australian Dollar / New Zealand Dollar
		'AUDCHF', # Australian Dollar / Swiss Franc
		'CADJPY', # Canadian Dollar / Japanese Yen
		'CADCHF', # Canadian Dollar / Swiss Franc
		'NZDCHF', # New Zealand Dollar / Swiss Franc
		'NZDCAD', # New Zealand Dollar / Canadian Dollar
	]
  
	exotic_pairs = [
		'USDBRL', # US Dollar / Brazilian Real
		'USDCNY', # US Dollar / Chinese Yuan
		'USDINR', # US Dollar / Indian Rupee
		'USDKRW', # US Dollar / South Korean Won
		'USDRUB', # US Dollar / Russian Ruble
		'USDTRY', # US Dollar / Turkish Lira
		'USDMXN', # US DOllar / Mexican Peso
		'USDZAR', # US Dollar / South African Rand
		'USDHKD', # US Dollar / Hongkong Dollar
		'USDSGD', # US Dollar / Singapore Dollar
		'USDTHB', # US Dollar / Thai Baht
		'USDSEK', # US Dollar / Swedish Krona
		'USDDKK', # US Dollar / Danish Krone
		'USDNOK', # US Dollar / Norwegian Krone
	]
    
	metal_symbols = [
		'XAUUSD',    # Gold/US Dollar
		'XAGUSD',    # Silver/US Dollar
		'XPTUSD',    # Platinum/US Dollar
		'XPDUSD',    # Palladium/US Dollar
		'COPUSD',    # Copper/US Dollar (industrial metal)
		'GOLD',      # same as Gold/US dollar
		'SILVER',    # same as Silver/US Dollar,
		'PLATINUM',  # same as XPTUSD
		'PALLADIUM', # same as XPDUSD
		'COPPER',    # same as COPUSD 
	]
    
	index_symbols = [
		'US30',    # Dow Jones Industrial Average
		'SPX500',  # S&P 500
		'NAS100',  # Nasdaq 100
		'UK100',   # FTSE 100
		'DE30',    # DAX 30
		'JP225',   # Nikkei 225
		'HK50',    # Hang Seng Index
		'AUS200',  # Australia 200
		'ESP35',   # IBEX 35 (Spain)
		'FRA40',   # CAC 40 (France)
	]
  
	crypto_pairs = [
		'BTCUSD',  # Bitcoin / US Dollar
		'ETHUSD',  # Ethereum / US Dollar
		'XRPUSD',  # Ripple / US Dollar
		'LTCUSD',  # Litecoin / US Dollar
		'BCHUSD',  # Bitcoin Cash / US Dollar
		'EOSUSD',  # EOS / US Dollar
		'XMRUSD',  # Monero / US Dollar
		'ADAUSD',  # Cardano / US Dollar
		'XLMUSD',  # Stellar / US Dollar
		'NEOUSD',  # NEO / US Dollar
	]
     
	oil_symbols = [
		'WTIUSD',   # West Texas Intermediate (WTI) Crude Oil / US Dollar
		'BRENTUSD', # Brent Crude Oil / US Dollar
		'USOILUSD', # US Oil (Continuous Contract) / US Dollar
		'UKOILUSD', # UK Oil (Continuous Contract) / US Dollar
	]

	reply_symbols = []
	
	if fx_majors:
		reply_symbols.extend(forex_majors)
	if fx_crosses:
		reply_symbols.extend(forex_crosses)
	if fx_exotics:
		reply_symbols.extend(exotic_pairs)
	if metals:
		reply_symbols.extend(metal_symbols)
	if oils:
		reply_symbols.extend(oil_symbols)
	if indexes:
		reply_symbols.extend(index_symbols)
	if cryptos:
		reply_symbols.extend(crypto_pairs)

	return reply_symbols

