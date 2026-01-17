# Backend API Documentation

## Base URL
```
http://localhost:8000/api
```

## Health Check

### GET `/health`
Server health status

**Response**: 
```json
{
  "status": "healthy",
  "timestamp": "2024-01-16T10:30:00",
  "service": "HCP CRM AI Agent"
}
```

---

## Interactions API

### POST `/interactions/log-form`
Log an HCP interaction via structured form

**Request Body**:
```json
{
  "hcp_id": "HCP001",
  "hcp_name": "Dr. Sarah Johnson",
  "interaction_type": "phone",
  "location": "City Hospital",
  "specialty": "Cardiology",
  "raw_content": "Discussion about new cardiac medication...",
  "created_by": "rep_001"
}
```

**Response** (200):
```json
{
  "id": 1,
  "hcp_id": "HCP001",
  "hcp_name": "Dr. Sarah Johnson",
  "interaction_type": "phone",
  "interaction_date": "2024-01-16T10:30:00",
  "location": "City Hospital",
  "specialty": "Cardiology",
  "raw_content": "Discussion about new cardiac medication...",
  "summary": "Dr. Johnson showed interest in new cardiac medication. She has 5 patients who could benefit.",
  "key_topics": ["cardiac medication", "patient interest", "samples"],
  "entities": {
    "products": ["cardiac medication"],
    "patient_demographics": ["5 patients"]
  },
  "sentiment": "positive",
  "action_items": ["Send samples", "Follow up next week"],
  "created_by": "rep_001",
  "created_at": "2024-01-16T10:30:00",
  "updated_at": "2024-01-16T10:30:00"
}
```

---

### POST `/interactions/log-chat`
Log an HCP interaction via conversational chat

**Request Body**:
```json
{
  "user_message": "Just spoke with Dr. Johnson about our new medication. She's interested and wants samples.",
  "interaction_context": {
    "hcp_id": "HCP001"
  }
}
```

**Response** (200):
```json
{
  "action": "log_interaction",
  "result": {
    "hcp_id": "HCP001",
    "summary": "Dr. Johnson expressed interest in new medication and requested samples.",
    "key_topics": ["medication", "samples"],
    "sentiment": "positive",
    "action_items": ["Send samples"]
  },
  "messages": [
    {
      "role": "assistant",
      "content": "Interaction logged successfully. Dr. Johnson is interested in the medication and needs samples."
    }
  ],
  "error": null
}
```

---

### GET `/interactions`
Retrieve interactions with optional filtering

**Query Parameters**:
- `hcp_id` (optional): Filter by HCP ID
- `limit` (optional, default: 50): Number of results
- `offset` (optional, default: 0): Pagination offset

**Example**: `GET /interactions?hcp_id=HCP001&limit=10&offset=0`

**Response** (200):
```json
{
  "total": 5,
  "interactions": [
    {
      "id": 1,
      "hcp_id": "HCP001",
      "hcp_name": "Dr. Sarah Johnson",
      ...
    }
  ]
}
```

---

### GET `/interactions/{interaction_id}`
Retrieve a specific interaction by ID

**Example**: `GET /interactions/1`

**Response** (200): Single interaction object (same structure as log-form response)

**Error** (404):
```json
{
  "detail": "Interaction not found"
}
```

---

### PUT `/interactions/{interaction_id}`
Edit an existing interaction

**Request Body** (all fields optional):
```json
{
  "raw_content": "Updated notes...",
  "summary": "New summary",
  "key_topics": ["new", "topics"],
  "entities": {},
  "sentiment": "neutral",
  "action_items": ["new items"]
}
```

**Response** (200): Updated interaction object

---

### DELETE `/interactions/{interaction_id}`
Archive an interaction (soft delete)

**Response** (200):
```json
{
  "message": "Interaction archived successfully"
}
```

---

## HCP Profile API

### POST `/hcps`
Create a new HCP profile

**Request Body**:
```json
{
  "hcp_id": "HCP001",
  "first_name": "Sarah",
  "last_name": "Johnson",
  "specialty": "Cardiology",
  "organization": "City Hospital",
  "location": "New York",
  "email": "sarah@hospital.com",
  "phone": "555-0123"
}
```

**Response** (200): HCP profile object

---

### GET `/hcps`
List all HCP profiles

**Query Parameters**:
- `limit` (optional, default: 50): Number of results
- `offset` (optional, default: 0): Pagination offset

**Response** (200):
```json
{
  "total": 10,
  "profiles": [
    {
      "hcp_id": "HCP001",
      "first_name": "Sarah",
      "last_name": "Johnson",
      ...
    }
  ]
}
```

---

### GET `/hcps/{hcp_id}`
Get a specific HCP profile

**Response** (200): HCP profile object

---

## Agent API

### POST `/agent/chat`
Chat with the HCP AI agent

**Request Body**:
```json
{
  "user_message": "Log my interaction with Dr. Johnson"
}
```

**Response** (200):
```json
{
  "action": "log_interaction",
  "result": {
    "status": "success",
    ...
  },
  "messages": [
    {
      "role": "assistant",
      "content": "Response from agent"
    }
  ],
  "error": null
}
```

---

### GET `/agent/tools`
Get list of available agent tools

**Response** (200):
```json
{
  "tools": [
    {
      "name": "log_interaction",
      "description": "Log and process HCP interactions...",
      "required_params": ["hcp_id", "hcp_name", "interaction_type", "raw_content", "created_by"]
    },
    {
      "name": "edit_interaction",
      "description": "Edit existing interactions",
      "required_params": ["interaction_id", "updates"]
    },
    {
      "name": "schedule_followup",
      "description": "Schedule follow-up interactions",
      "required_params": ["hcp_id", "followup_date", "followup_type", "purpose"]
    },
    {
      "name": "analyze_territory",
      "description": "Analyze territory performance",
      "required_params": ["territory_id", "interactions_data"]
    },
    {
      "name": "prepare_sales_content",
      "description": "Generate personalized sales content",
      "required_params": ["hcp_data", "content_type"]
    }
  ]
}
```

---

## Analytics API

### GET `/analytics/dashboard`
Get dashboard analytics data

**Response** (200):
```json
{
  "total_interactions": 42,
  "total_hcps": 15,
  "sentiment_distribution": {
    "positive": 28,
    "neutral": 10,
    "negative": 4
  },
  "interaction_type_distribution": {
    "phone": 25,
    "in-person": 12,
    "email": 5
  }
}
```

---

## Error Responses

### 400 Bad Request
```json
{
  "detail": "Invalid request parameters"
}
```

### 404 Not Found
```json
{
  "detail": "Resource not found"
}
```

### 500 Internal Server Error
```json
{
  "detail": "Internal server error message"
}
```

---

## Rate Limiting & Pagination

- Default limit: 50 items
- Max limit: 1000 items
- Use `offset` for pagination

---

## Authentication

Currently, the API is open (no authentication). For production, implement:
- JWT tokens
- API keys
- OAuth2

---

## CORS Headers

Allowed origins: All (*)

For production, restrict to specific domains in FastAPI CORS middleware.

---

## Webhook Support (Future)

Plan to add webhooks for:
- Interaction logged
- Follow-up scheduled
- Analysis completed

---

## SDKs & Examples

### Python
```python
import requests

BASE_URL = "http://localhost:8000/api"

# Log interaction
response = requests.post(
    f"{BASE_URL}/interactions/log-form",
    json={
        "hcp_id": "HCP001",
        "hcp_name": "Dr. Sarah Johnson",
        "interaction_type": "phone",
        "raw_content": "...",
        "created_by": "rep_001"
    }
)
```

### JavaScript/cURL
```bash
curl -X POST http://localhost:8000/api/interactions/log-form \
  -H "Content-Type: application/json" \
  -d '{
    "hcp_id": "HCP001",
    "hcp_name": "Dr. Sarah Johnson",
    "interaction_type": "phone",
    "raw_content": "...",
    "created_by": "rep_001"
  }'
```

---

## Swagger Documentation

Full interactive API documentation available at:
```
http://localhost:8000/docs
```

ReDoc documentation available at:
```
http://localhost:8000/redoc
```

---

**Last Updated**: January 2026  
**API Version**: 1.0.0
