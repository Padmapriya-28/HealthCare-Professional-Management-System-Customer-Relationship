import requests
import json

data = {
    'user_input': 'Just had a call with Dr. Sarah Johnson about our new medication.',
    'interaction_type': 'chat'
}

try:
    response = requests.post('http://localhost:8000/api/process', json=data, timeout=10)
    print('Status Code:', response.status_code)
    print('Response:', json.dumps(response.json(), indent=2))
except Exception as e:
    print('Error:', str(e))
