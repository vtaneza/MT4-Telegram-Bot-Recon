class SignalParser:
	'''
	Signal parser template or base class
	'''

	def __init__(self, message):
		self.message = message;
		self.take_profits = []
		self.entry_price = None
		self.stop_loss = None
		self.action = None
		self.symbol = None

	def parse_message(self):
		pass # parsing is to be implemented by deriving classes

	def get_entry_price(self):
		return self.entry_price

	def get_stop_loss(self):
		return self.stop_loss

	def get_take_profits(self):
		return self.take_profits
	
	def get_trade_action(self):
		return self.action
	
	def get_trade_symbol(self):
		return self.symbol
	
	def is_signal_valid(self, check_sl=False, check_tps=False):
		is_valid = True if (self.symbol and self.action and self.entry_price) else False
		if check_sl:
			is_valid = True if (is_valid and self.stop_loss) else False
		if check_tps:
			is_valid = True if (is_valid and self.take_profits) else False
		return is_valid
	
	def get_signal_json(self):
		return {
			'symbol': self.symbol,
			'action': self.action,
			'entry_price': self.entry_price,
			'stop_loss': self.stop_loss,
			'take_profits': [ take_profit for take_profit in self.take_profits ]
		}
