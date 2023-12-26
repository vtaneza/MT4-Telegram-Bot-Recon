import utils, re
from SignalParser import SignalParser

class KelvinGoldMasterParser(SignalParser):
	'''
	Parser for "Kelvin Gold Master" telegram signal provider
	Sample signal format:
	==========================
		GOLD BUY NOW @ 2035-2032

		SL : 2030

		TP1 : 2037
		TP2 : 2040
	==========================
	'''

	def __init__(self, message):
		super().__init__(message)

	def parse_message(self):
		symbols = utils.get_symbols()
		actions = ['BUY', 'SELL']
		pendings = ['STOP', 'LIMIT']
		lines = self.message.split('\n')
		lineno = 0
		pattern = r'\s+|[@\-:]' 

		for line in lines:
			line_tokens = re.split(pattern, line) # split with whitespace, @, - and : symbols
			if lineno == 0:
				# parse first line to get symbol, action, and entry price
				symline_tokens = line_tokens
				for symline_token in symline_tokens:
					if symline_token in symbols:
						self.symbol=symline_token
					if symline_token in actions:
						self.action=symline_token
					if symline_token in pendings:
						self.action=f"{self.action} {symline_token}"
					if not self.entry_price and utils.is_number(symline_token):
						self.entry_price = symline_token
			else:
				# parse other lines to get stop loss and take profit levels
				for line_token in line_tokens:
					if utils.is_number(line_token):
						if line.find('SL') != -1:
							self.stop_loss = float(line_token)
						elif line.find('TP') != -1:
							self.take_profits.append(float(line_token))

			# increment line processed
			lineno = lineno + 1

