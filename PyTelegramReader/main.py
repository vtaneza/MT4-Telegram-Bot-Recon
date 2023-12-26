import configparser
import json
import re
import utils
from telethon.errors import SessionPasswordNeededError
from telethon import TelegramClient, events, sync
from telethon.tl.functions.messages import GetHistoryRequest
from telethon.tl.types import InputPeerChannel, PeerChannel
from ppretty import ppretty
from KelvinGoldMaster import KelvinGoldMasterParser

api_id = ''
api_hash = ''
phone = ''

'''
Creates a telegram client by logging in to the specified account.
If 2FA is configured, a code will be sent to the registered mobile
number for verification.
'''
client = TelegramClient(phone, api_id, api_hash)
client.connect()
if not client.is_user_authorized():
	client.send_code_request(phone)
	client.sign_in(phone, input('Enter the code: '))

print('Connected.')

@client.on(events.NewMessage())
async def new_message_listener(event):
	'''
	Listens for new telegram message, filters only forex signal-related
	messages, and pass to appropriate parser based on the source of the 
	message. Each signal provider may have different signal message format
	'''

	# Display message structure
	#print('-----------------------------------------------------')
	#attrs = vars(event.message)
	#for item in attrs:
	#	print(item , ' : ' , attrs[item])

	# define table of sender to parser
	sender_to_parser_dict = {
		'1180396097': { # from 'Mine SunLTE'
			'parser': KelvinGoldMasterParser, 
			'bots': [
				'@kelvin_gold_master_bot'
			]
		}, 
	}

	# get either channel name (string) or user id (number)
	if event.message._chat == None:
		message_from = str(event.message.from_id.user_id)
	else:
		message_from = event.message._chat.title
	
	# get parser class and parse message
	parser_class = sender_to_parser_dict[message_from]['parser'] if message_from in sender_to_parser_dict else None
	if parser_class:
		parser_obj = parser_class(event.message.message)
		parser_obj.parse_message()

		if parser_obj.is_signal_valid():		
			await client.send_message('@kamrinom', json.dumps(parser_obj.get_signal_json(), indent=2))
			
			# notify signal to all subscribing bots
			bots_to_notify = sender_to_parser_dict[message_from]['bots'] if message_from in sender_to_parser_dict else None
			if bots_to_notify:
				# get take profits
				tps = parser_obj.get_take_profits()
				strtps = None
				for tp in tps:
					if not strtps:
						strtps = f"{tp}"
					else:
						strtps = f"{strtps},{tp}"
					
				# prepare bot's /ordersend command message
				message_to_send = f"""
/ordersend
SYMBOL: {parser_obj.get_trade_symbol().upper()}
ACTION: {parser_obj.get_trade_action().upper()}
ENTRY: {parser_obj.get_entry_price()}
SL: {parser_obj.get_stop_loss()}
TPS: {strtps}
"""
				print(f"Message: {message_to_send}")

				for bot_to_notify in bots_to_notify:
					# send message now
					await client.send_message(bot_to_notify, message_to_send)

with client:
  client.run_until_disconnected()
