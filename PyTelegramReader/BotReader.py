import requests
import json
from time import sleep

# Replace 'YOUR_BOT_TOKEN' with the actual token you received from BotFather
BOT_TOKEN = '6853804731:AAFCUQRIiYsjkQYS_ryekWxzOljx51HaGKg'

def get_updates(offset=None):
    # Define the API endpoint URL
    api_url = f'https://api.telegram.org/bot{BOT_TOKEN}/getUpdates'

    # Prepare the parameters
    params = {'offset': offset, 'timeout': 20}  # Adjust the timeout as needed

    # Make the API request
    response = requests.get(api_url, params=params)
    
    # Parse the JSON response
    updates = response.json().get('result', [])

    return updates

def process_updates(updates):
    for update in updates:
        # Extract relevant information from the update
        message_text = update.get('message', {}).get('text')
        chat_id = update.get('message', {}).get('chat', {}).get('id')

        # Print or process the received message
        print(f"Received message: '{message_text}' from chat ID: {chat_id}")

        # You can implement your custom logic here

def main():
    offset = None

    while True:
        # Get updates
        updates = get_updates(offset)

        # Process updates
        process_updates(updates)

        # Update the offset to avoid processing the same updates multiple times
        if updates:
            offset = max(updates, key=lambda x: x['update_id'])['update_id'] + 1

        # Add a delay to avoid making too many requests
        sleep(1)

if __name__ == '__main__':
    main()
