import os
import requests
from dotenv import load_dotenv

load_dotenv()

r = requests.post(
    'https://integrate.api.nvidia.com/v1/chat/completions',
    headers={
        'Authorization': f'Bearer {os.getenv("NVIDIA_NIM_API_KEY")}',
        'Content-Type': 'application/json'
    },
    json={
        'model': 'nvidia/nemotron-3-super-120b-a12b',
        'messages': [
            {'role': 'user', 'content': 'Sebut 1 beasiswa populer di Indonesia untuk S1. Singkat.'}
        ],
        'max_tokens': 100
    },
    timeout=60
)

print('Status:', r.status_code)
if r.status_code == 200:
    print(r.json()['choices'][0]['message']['content'])
else:
    print(r.text[:300])
