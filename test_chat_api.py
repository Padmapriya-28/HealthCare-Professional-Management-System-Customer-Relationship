import requests
import json

data = {
    'user_message': 'Just had a call with Dr. Sarah Johnson about our new medication.',
    'interaction_context': {}
}

try:
    response = requests.post('http://localhost:8000/api/interactions/log-chat', json=data, timeout=10)
    print('Status Code:', response.status_code)
    print('Response:', json.dumps(response.json(), indent=2))
except Exception as e:
    print('Error:', str(e))
