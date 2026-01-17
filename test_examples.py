import requests
import json

examples = [
    "Just had a great call with Dr. Sarah Johnson at City Hospital. She's a cardiologist with about 50 patients. We discussed our new beta-blocker medication, and she's very interested. Mentioned she has 5 patients who could be good candidates. Wants samples and clinical trial data. She's open to a follow-up meeting next week.",
    
    "Met with Dr. Michael Chen today. He's a neurologist at Memorial Medical Center. We discussed our migraine treatment solution. He seemed skeptical at first but warmed up when I showed him the recent efficacy data. He wants to try it with 3 of his patients and said he'd call back with results in 2 weeks. Very promising interaction.",
]

for i, message in enumerate(examples, 1):
    data = {
        'user_message': message,
        'interaction_context': {}
    }
    
    try:
        response = requests.post('http://localhost:8000/api/interactions/log-chat', json=data, timeout=15)
        print(f"\n{'='*80}")
        print(f"Example {i}:")
        print(f"{'='*80}")
        print(f"Status Code: {response.status_code}")
        result = response.json()
        print(f"Summary: {result['result'].get('summary', 'N/A')}")
        print(f"Topics: {', '.join(result['result'].get('key_topics', []))}")
        print(f"Sentiment: {result['result'].get('sentiment', 'N/A')}")
        print(f"AI Response: {result['messages'][0]['content'] if result['messages'] else 'N/A'}")
    except Exception as e:
        print(f"Error: {str(e)}")
