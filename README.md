# HCP CRM AI Agent - AI-First Customer Relationship Management System

An advanced, AI-powered Customer Relationship Management (CRM) system specifically designed for Healthcare Professional (HCP) field representatives. This system leverages **LangGraph** and **LLM technology** (Groq) to intelligently process and manage HCP interactions with both structured forms and conversational chat interfaces.

![Architecture Diagram](docs/architecture.png)

## 🎯 Project Overview

This project implements an AI-first CRM module that allows field representatives to log, manage, and analyze healthcare professional interactions. The system uses cutting-edge AI technologies to automatically extract insights from raw interaction data.

### Key Features

- **Dual Interface for Interaction Logging**:
  - Structured Form: Traditional form-based interaction entry
  - Conversational Chat: Natural language interaction logging through AI agent
  
- **LangGraph AI Agent**: Manages complex workflows and tool execution
  - 5 specialized tools for sales and interaction management
  - Intelligent routing and action processing
  - Async request handling

- **AI-Powered Insights**:
  - Automatic summarization of interactions
  - Entity extraction (products, dosages, conditions)
  - Sentiment analysis
  - Action item identification
  - Topic extraction

- **Interactive Dashboard**:
  - Real-time analytics and metrics
  - Sentiment distribution visualization
  - Interaction type analysis
  - HCP engagement tracking

- **Database Support**:
  - SQLite (development, default)
  - PostgreSQL (production)
  - MySQL (optional)

## 📋 Tech Stack

### Backend
- **Framework**: FastAPI (Python)
- **AI Agent**: LangGraph
- **LLM**: Groq (llama-3.3-70b-versatile model)
- **Database**: SQLAlchemy ORM (SQLite/PostgreSQL/MySQL)
- **Async**: asyncio + ASGI with Uvicorn

### Frontend
- **Framework**: React 18.2
- **State Management**: Redux + Redux Toolkit
- **Styling**: Tailwind CSS + Custom CSS
- **UI Components**: React Icons
- **HTTP Client**: Axios
- **Notifications**: React Hot Toast

### Infrastructure
- **Font**: Google Inter
- **Version Control**: Git
- **Deployment Ready**: Docker support (optional)

## 🛠️ Architecture

### Backend Architecture

```
backend/
├── app/
│   ├── main.py                 # FastAPI application
│   ├── agents/
│   │   ├── hcp_agent.py       # LangGraph AI Agent
│   │   └── __init__.py
│   ├── tools/                  # LangGraph Tools
│   │   ├── log_interaction.py  # Tool #1: Log interaction with AI processing
│   │   ├── edit_interaction.py # Tool #2: Edit existing interactions
│   │   ├── schedule_followup.py # Tool #3: Schedule follow-ups
│   │   ├── analyze_territory.py # Tool #4: Territory analysis
│   │   ├── prepare_sales_content.py # Tool #5: Generate sales content
│   │   └── __init__.py
│   ├── models/
│   │   ├── interaction.py      # Database and Pydantic models
│   │   ├── schemas.py          # API request/response schemas
│   │   └── __init__.py
│   ├── database/
│   │   ├── connection.py       # Database setup and session management
│   │   └── __init__.py
│   └── __init__.py
├── requirements.txt            # Python dependencies
├── .env.example               # Environment variables template
└── README.md
```

### Frontend Architecture

```
frontend/
├── src/
│   ├── components/
│   │   ├── LogInteractionScreen.tsx # Main screen with tab switching
│   │   ├── FormInterface.tsx        # Structured form component
│   │   ├── ChatInterface.tsx        # Conversational chat component
│   │   ├── InteractionsList.tsx     # Interactions history list
│   │   ├── Dashboard.tsx            # Analytics dashboard
│   │   ├── Sidebar.tsx              # Navigation sidebar
│   │   └── __init__.ts
│   ├── redux/
│   │   ├── store.ts                 # Redux store configuration
│   │   └── slices/
│   │       ├── interactionSlice.ts  # Interactions state
│   │       └── uiSlice.ts           # UI state
│   ├── services/
│   │   └── api.ts                   # API client and endpoints
│   ├── pages/
│   ├── App.tsx                      # Main App component
│   ├── index.tsx                    # React entry point
│   └── index.css                    # Global styles
├── public/
│   └── index.html
├── package.json
├── tailwind.config.js
├── postcss.config.js
├── tsconfig.json
└── .env.example
```

## 🔧 LangGraph AI Agent & Tools

### Agent Overview

The HCP Agent is built on **LangGraph**, a state management framework for AI applications. It manages complex workflows and coordinates between different tools.

**Key Components**:
- **StateGraph**: Defines the workflow with nodes and edges
- **Tool Router**: Intelligent routing of user requests to appropriate tools
- **Tool Execution**: Async execution with error handling
- **Response Generation**: Formatted output for frontend

### 5 Core Tools

#### 1. **Log Interaction Tool** ⭐
**Purpose**: Capture and process HCP interactions with AI-powered analysis

**Functionality**:
- Accepts raw interaction content (form or chat-based)
- Uses LLM to generate:
  - Concise summaries (2-3 sentences)
  - Key discussion topics (3-5 items)
  - Entity extraction (products, dosages, conditions, demographics)
  - Sentiment classification (positive/neutral/negative)
  - Action items and follow-ups (auto-generated)

**Implementation**: [log_interaction.py](backend/app/tools/log_interaction.py)

**API Endpoint**:
```bash
POST /api/interactions/log-form
POST /api/interactions/log-chat
```

**Example Request**:
```json
{
  "hcp_id": "HCP001",
  "hcp_name": "Dr. Sarah Johnson",
  "interaction_type": "phone",
  "location": "St. Mary's Hospital",
  "specialty": "Cardiology",
  "raw_content": "Called Dr. Johnson about new heart medication. She expressed interest in our latest beta-blocker. Mentioned 5 cardiac patients who could benefit. She wants samples and comprehensive data.",
  "created_by": "rep_001"
}
```

**Example Response**:
```json
{
  "id": 1,
  "hcp_id": "HCP001",
  "summary": "Dr. Johnson showed strong interest in our new beta-blocker medication. She has 5 cardiac patients who could benefit from it and requested samples and detailed product data.",
  "key_topics": ["beta-blocker", "cardiac patients", "medication samples", "product data"],
  "entities": {
    "products": ["beta-blocker"],
    "conditions": ["cardiac condition"],
    "patient_demographics": ["5 patients"]
  },
  "sentiment": "positive",
  "action_items": [
    "Send medication samples to Dr. Johnson",
    "Prepare comprehensive beta-blocker data package",
    "Follow-up within 1 week"
  ]
}
```

#### 2. **Edit Interaction Tool** ✏️
**Purpose**: Modify and update logged interaction records

**Functionality**:
- Update raw content (if conversation needs correction)
- Modify generated insights (manual refinement)
- Update categorization (topics, entities)
- Edit action items
- Adjust sentiment classification

**Implementation**: [edit_interaction.py](backend/app/tools/edit_interaction.py)

**API Endpoint**:
```bash
PUT /api/interactions/{interaction_id}
```

**Example Request**:
```json
{
  "raw_content": "Updated conversation notes...",
  "action_items": [
    "Send samples by tomorrow",
    "Call back next Monday"
  ]
}
```

#### 3. **Schedule Follow-up Tool** 📅
**Purpose**: Book and manage follow-up interactions

**Functionality**:
- Schedule follow-up dates and times
- Specify interaction type (call, meeting, email)
- Define follow-up purpose and notes
- Automated calendar integration (extensible)
- Reminder management

**Implementation**: [schedule_followup.py](backend/app/tools/schedule_followup.py)

**Example Request**:
```json
{
  "hcp_id": "HCP001",
  "followup_date": "2024-01-25",
  "followup_type": "in-person",
  "purpose": "Deliver medication samples and discuss trial results",
  "notes": "Bring 3 boxes of samples and recent clinical data"
}
```

#### 4. **Analyze Territory Tool** 🗺️
**Purpose**: Provide strategic insights on territory performance

**Functionality**:
- Aggregate interaction data for a territory
- Identify top-performing HCPs
- Analyze engagement patterns
- Generate strategic recommendations using LLM
- Track interaction frequency and sentiment trends

**Implementation**: [analyze_territory.py](backend/app/tools/analyze_territory.py)

**Example Request**:
```json
{
  "territory_id": "WEST_01",
  "interactions_data": [
    {"hcp_name": "Dr. A", "interaction_type": "phone", "key_topics": ["product_x", "market"]},
    {"hcp_name": "Dr. B", "interaction_type": "visit", "key_topics": ["trial", "data"]}
  ]
}
```

**AI-Generated Output**:
```json
{
  "insights": "Top performing HCPs show 3x higher engagement rates. Recommend increasing in-person visits for cold prospects and phone follow-ups for warm leads.",
  "interaction_count": 15,
  "recommendations": [...]
}
```

#### 5. **Prepare Sales Content Tool** 🎯
**Purpose**: Generate personalized sales content for HCP engagement

**Functionality**:
- Analyze HCP profile and history
- Generate customized:
  - Presentation outlines
  - Email templates
  - Proposal documents
  - Pitch decks
- Reference previous interactions
- Address specific pain points and interests
- Include relevant clinical data and case studies

**Implementation**: [prepare_sales_content.py](backend/app/tools/prepare_sales_content.py)

**Example Request**:
```json
{
  "hcp_data": {
    "hcp_name": "Dr. Sarah Johnson",
    "specialty": "Cardiology",
    "previous_interactions": ["Discussed beta-blockers", "Showed interest in ACE inhibitors"],
    "interests": ["clinical trials", "evidence-based medicine"],
    "pain_points": ["managing hypertension in diabetic patients", "drug interactions"]
  },
  "content_type": "presentation"
}
```

## 📦 Installation & Setup

### Prerequisites

- Python 3.9+
- Node.js 16+
- npm or yarn
- Git

### Backend Setup

1. **Clone and Navigate**:
```bash
cd hcp/backend
```

2. **Create Virtual Environment**:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install Dependencies**:
```bash
pip install -r requirements.txt
```

4. **Configure Environment**:
```bash
cp .env.example .env
# Edit .env and add your Groq API key
# GROQ_API_KEY=your_actual_groq_api_key_here
```

5. **Initialize Database**:
```bash
# Database will auto-initialize on first run
# Or manually run:
python -c "from app.database.connection import init_db; init_db()"
```

6. **Run Backend Server**:
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Backend will be available at: `http://localhost:8000`

**API Documentation** (auto-generated):
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

### Frontend Setup

1. **Navigate to Frontend**:
```bash
cd hcp/frontend
```

2. **Install Dependencies**:
```bash
npm install
```

3. **Configure Environment**:
```bash
cp .env.example .env
# Ensure REACT_APP_API_URL=http://localhost:8000/api
```

4. **Run Development Server**:
```bash
npm start
```

Frontend will be available at: `http://localhost:3000`

## 🚀 API Endpoints Reference

### Interactions Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/interactions/log-form` | Log interaction via structured form |
| POST | `/api/interactions/log-chat` | Log interaction via chat interface |
| GET | `/api/interactions` | Get all interactions (with filters) |
| GET | `/api/interactions/{id}` | Get single interaction |
| PUT | `/api/interactions/{id}` | Edit interaction |
| DELETE | `/api/interactions/{id}` | Archive interaction |

### Agent Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/agent/chat` | Chat with HCP agent |
| GET | `/api/agent/tools` | List available tools |

### HCP Profile Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/hcps` | Create HCP profile |
| GET | `/api/hcps` | List all HCPs |
| GET | `/api/hcps/{hcp_id}` | Get HCP profile |

### Analytics Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/analytics/dashboard` | Get dashboard analytics |

### Health Check

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Server health status |

## 💻 Usage Examples

### Example 1: Logging Interaction via Form

```bash
curl -X POST http://localhost:8000/api/interactions/log-form \
  -H "Content-Type: application/json" \
  -d '{
    "hcp_id": "HCP001",
    "hcp_name": "Dr. Sarah Johnson",
    "interaction_type": "phone",
    "location": "St. Mary Hospital",
    "specialty": "Cardiology",
    "raw_content": "Called Dr. Johnson about beta-blockers. Strong interest. Has 5 cardiac patients.",
    "created_by": "rep_001"
  }'
```

### Example 2: Chat-Based Interaction

```bash
curl -X POST http://localhost:8000/api/interactions/log-chat \
  -H "Content-Type: application/json" \
  -d '{
    "user_message": "I just spoke with Dr. Johnson about our new heart medication. She was very interested and wants samples.",
    "interaction_context": {
      "hcp_id": "HCP001",
      "hcp_name": "Dr. Sarah Johnson"
    }
  }'
```

### Example 3: Getting Available Tools

```bash
curl -X GET http://localhost:8000/api/agent/tools
```

Response:
```json
{
  "tools": [
    {
      "name": "log_interaction",
      "description": "Log and process HCP interactions with AI-powered summarization",
      "required_params": ["hcp_id", "hcp_name", "interaction_type", "raw_content", "created_by"]
    },
    {
      "name": "edit_interaction",
      "description": "Edit and update existing logged interactions",
      "required_params": ["interaction_id", "updates"]
    },
    ...
  ]
}
```

## 🎨 Frontend Features

### LogInteractionScreen Component

The main screen features dual interfaces:

1. **Structured Form Tab**:
   - HCP ID and name fields (required)
   - Interaction type dropdown (phone, in-person, email, video, other)
   - Location and specialty fields
   - Large text area for interaction summary
   - Submit button with loading state

2. **Chat Interface Tab**:
   - Conversational message interface
   - Natural language input for interactions
   - AI agent processing indicator
   - Message history with role-based styling
   - Real-time feedback

### Additional Pages

- **Dashboard**: Analytics and metrics visualization
- **Interactions List**: History of all logged interactions with edit/delete options
- **Sidebar Navigation**: Easy page switching

## 🗄️ Database Schema

### HCPInteractionDB Table
```sql
CREATE TABLE hcp_interactions (
  id INTEGER PRIMARY KEY,
  hcp_id VARCHAR(255),
  hcp_name VARCHAR(255),
  interaction_type VARCHAR(100),
  interaction_date DATETIME,
  location VARCHAR(255),
  specialty VARCHAR(255),
  raw_content TEXT,
  summary TEXT,
  key_topics JSON,
  entities JSON,
  sentiment VARCHAR(50),
  action_items JSON,
  created_by VARCHAR(255),
  created_at DATETIME,
  updated_at DATETIME,
  is_archived BOOLEAN DEFAULT FALSE
);
```

### HCPProfile Table
```sql
CREATE TABLE hcp_profiles (
  id INTEGER PRIMARY KEY,
  hcp_id VARCHAR(255) UNIQUE,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  specialty VARCHAR(255),
  organization VARCHAR(255),
  location VARCHAR(255),
  email VARCHAR(255),
  phone VARCHAR(20),
  last_interaction_date DATETIME,
  interaction_count INTEGER,
  created_at DATETIME
);
```

## 🧪 Testing the System

### Test Scenario 1: Log Form Interaction

1. Navigate to `http://localhost:3000`
2. Click "Log Interaction" in sidebar
3. Select "Structured Form" tab
4. Fill form:
   - HCP ID: `HCP001`
   - HCP Name: `Dr. Sarah Johnson`
   - Interaction Type: `Phone Call`
   - Location: `City Hospital`
   - Specialty: `Cardiology`
   - Summary: `Discussed new beta-blocker. She has 5 patients who could benefit.`
5. Click "Log Interaction"
6. Verify: AI processing completes, interaction appears in list with generated insights

### Test Scenario 2: Chat-Based Interaction

1. Go to "Log Interaction" → "Chat Interface" tab
2. Type: `Just called Dr. Johnson. She's very interested in our new heart medication and wants samples.`
3. Press Send
4. Observe: AI agent processes request, extracts interaction details, generates summary

### Test Scenario 3: Analytics Dashboard

1. Click "Dashboard" in sidebar
2. View statistics:
   - Total interactions count
   - Total HCPs
   - Sentiment distribution
   - Interaction type breakdown

## 🔐 Environment Variables

### Backend (.env)
```
GROQ_API_KEY=your_actual_groq_api_key_here
DATABASE_URL=sqlite:///./hcp.db
ENVIRONMENT=development
```

### Frontend (.env)
```
REACT_APP_API_URL=http://localhost:8000/api
REACT_APP_ENVIRONMENT=development
```

## 🐳 Docker Support (Optional)

Create `Dockerfile` in backend:
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

Run with Docker:
```bash
docker build -t hcp-crm-backend .
docker run -p 8000:8000 -e GROQ_API_KEY=your_key hcp-crm-backend
```

## 📊 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────┐
│                   Frontend (React + Redux)              │
│  ┌──────────────────────┐      ┌──────────────────────┐ │
│  │  Form Interface      │      │  Chat Interface      │ │
│  │  (Structured)        │      │  (Conversational)    │ │
│  └──────────┬───────────┘      └──────────┬───────────┘ │
└─────────────┼────────────────────────────┼──────────────┘
              │                            │
              ▼ POST /api/interactions      ▼
        ┌─────────────────────────────────────────┐
        │   FastAPI Backend                      │
        │  ┌─────────────────────────────────────┤
        │  │  Route Handler                      │
        │  └──────────────────┬──────────────────┤
        │                     ▼                  │
        │  ┌─────────────────────────────────────┤
        │  │  LangGraph Agent                    │
        │  │  - Router Node                      │
        │  │  - Tool Execution                   │
        │  │  - Response Generation              │
        │  └──────────┬───────────────────────────┤
        │             ▼                          │
        │  ┌──────────────────────────────────────┤
        │  │  Tools (5x)                         │
        │  │  1. Log Interaction                 │
        │  │  2. Edit Interaction                │
        │  │  3. Schedule Follow-up              │
        │  │  4. Analyze Territory               │
        │  │  5. Prepare Sales Content           │
        │  └──────────┬───────────────────────────┤
        │             │                          │
        │             ├────────┬─────────────────┤
        │             ▼        ▼                 │
        │      ┌──────────────────────┐          │
        │      │ Groq LLM             │          │
        │      │ (llama3-70b-8192)    │          │
        │      └──────┬───────────────┘          │
        │             ▼                          │
        │  ┌──────────────────────────────────────┤
        │  │  AI Processing                      │
        │  │  - Summarization                    │
        │  │  - Entity Extraction                │
        │  │  - Sentiment Analysis               │
        │  │  - Action Item Extraction           │
        │  └──────────┬───────────────────────────┤
        │             ▼                          │
        │  ┌──────────────────────────────────────┤
        │  │  Database                           │
        │  │  - HCP Interactions                 │
        │  │  - HCP Profiles                     │
        │  └──────────────────────────────────────┤
        └─────────────────────────────────────────┘
              ▲
              │ Response (JSON)
              │
        ┌─────┴──────────────────────────────────┐
        │  Redux State Update                    │
        │  - Interactions List                   │
        │  - Dashboard Analytics                │
        │  - UI State                            │
        └──────────────────────────────────────┘
```

## 🚀 Deployment

### Production Considerations

1. **Groq API Key**: Store securely in environment variables
2. **Database**: Migrate to PostgreSQL for production
3. **Frontend**: Build and serve static files
4. **CORS**: Configure allowed origins
5. **SSL/TLS**: Enable HTTPS
6. **Rate Limiting**: Implement request throttling
7. **Logging**: Set up comprehensive logging
8. **Monitoring**: Use APM tools (optional)

### Deployment Steps

1. **Backend**:
   ```bash
   pip install gunicorn
   gunicorn app.main:app --workers 4 --worker-class uvicorn.workers.UvicornWorker
   ```

2. **Frontend**:
   ```bash
   npm run build
   # Serve dist folder with nginx or similar
   ```

## 📝 Code Flow Explanation

### Adding an Interaction

1. **User Input**: User fills form or types chat message
2. **Frontend Dispatch**: Redux action dispatches API call
3. **Backend Route**: FastAPI endpoint receives request
4. **Tool Selection**: LangGraph routes to appropriate tool
5. **LLM Processing**: Groq LLM processes raw content
6. **AI Insights**: System extracts summary, topics, entities, sentiment, actions
7. **Database Save**: SQLAlchemy saves to database
8. **Response**: API returns enriched interaction data
9. **Frontend Update**: Redux updates store and UI renders new interaction

### Chat Interface Flow

1. **User Message**: Conversational input sent to `/api/interactions/log-chat`
2. **Agent Processing**: LangGraph agent analyzes intent
3. **Tool Execution**: Appropriate tool (usually log_interaction) executes
4. **LLM Analysis**: Groq extracts structured data from natural language
5. **Response Generation**: Agent formats response for display
6. **UI Update**: Chat interface displays assistant message
7. **Optional Save**: If valid interaction detected, auto-save to database

## 🤝 Contributing

To extend this system:

1. **Adding New Tools**:
   - Create new file in `app/tools/`
   - Implement with execute() method
   - Register in `app/agents/hcp_agent.py`
   - Add endpoint in `app/main.py`

2. **Extending Frontend**:
   - Add components in `src/components/`
   - Create Redux slices as needed
   - Extend API service in `src/services/api.ts`

## 📚 Additional Resources

- [LangGraph Documentation](https://python.langchain.com/docs/langgraph/)
- [Groq API Docs](https://console.groq.com/docs/models)
- [FastAPI Guide](https://fastapi.tiangolo.com/)
- [React Documentation](https://react.dev/)
- [Redux Toolkit](https://redux-toolkit.js.org/)
- [Tailwind CSS](https://tailwindcss.com/)

## 📄 License

This project is provided as-is for educational and commercial use.

## 🎓 Key Learnings & Architecture

### AI-First Design Philosophy

This system demonstrates the **AI-First CRM** paradigm:

1. **Conversational Interfaces**: Allow natural language input instead of rigid forms
2. **Intelligent Processing**: Use LLMs to extract structured data from unstructured input
3. **Automated Insights**: Generate summaries, extract entities, analyze sentiment without manual effort
4. **Workflow Automation**: LangGraph manages complex multi-step workflows
5. **Scalability**: Modular tool architecture allows easy extension

### Key Technical Decisions

1. **LangGraph Over Raw LLMs**: Provides state management and workflow orchestration
2. **Dual Interface**: Form for users preferring structure, chat for natural users
3. **Tool-Based Architecture**: Each capability is a discrete, testable tool
4. **Client-Side State Management**: Redux for local state, API for persistence
5. **SQLAlchemy ORM**: Database-agnostic, supports multiple SQL backends
