# HCP CRM Architecture Documentation

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                      HCP CRM AI-First System                         │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │              PRESENTATION LAYER (React + Redux)              │   │
│  │                                                              │   │
│  │  ┌────────────────┐  ┌──────────────┐  ┌─────────────────┐ │   │
│  │  │  Dashboard     │  │ Log Interact │  │ Interactions    │ │   │
│  │  │  - Analytics   │  │ - Form       │  │ List            │ │   │
│  │  │  - Metrics     │  │ - Chat       │  │ - View          │ │   │
│  │  │  - Charts      │  │ - Submit     │  │ - Edit          │ │   │
│  │  └────────────────┘  └──────────────┘  └─────────────────┘ │   │
│  │                                                              │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │
│  │  │              Redux Store                            │   │   │
│  │  │  - interactionSlice (CRUD state)                   │   │   │
│  │  │  - uiSlice (UI state, tabs, sidebar)              │   │   │
│  │  └─────────────────────────────────────────────────────┘   │   │
│  │                                                              │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │
│  │  │           Sidebar Navigation Component              │   │   │
│  │  │  - Dashboard                                        │   │   │
│  │  │  - Log Interaction                                  │   │   │
│  │  │  - Interactions List                                │   │   │
│  │  └─────────────────────────────────────────────────────┘   │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │        API SERVICE LAYER (axios + TypeScript)               │   │
│  │                                                              │   │
│  │  ┌──────────────────────────────────────────────────────┐  │   │
│  │  │  interactionService                                 │  │   │
│  │  │  - getInteractions()                                │  │   │
│  │  │  - logInteractionForm()                             │  │   │
│  │  │  - logInteractionChat()                             │  │   │
│  │  │  - editInteraction()                                │  │   │
│  │  │  - deleteInteraction()                              │  │   │
│  │  └──────────────────────────────────────────────────────┘  │   │
│  │                                                              │   │
│  │  ┌──────────────────────────────────────────────────────┐  │   │
│  │  │  agentService                                        │  │   │
│  │  │  - chat()                                            │  │   │
│  │  │  - getTools()                                        │  │   │
│  │  └──────────────────────────────────────────────────────┘  │   │
│  │                                                              │   │
│  │  ┌──────────────────────────────────────────────────────┐  │   │
│  │  │  analyticsService                                    │  │   │
│  │  │  - getDashboard()                                    │  │   │
│  │  └──────────────────────────────────────────────────────┘  │   │
│  │                                                              │   │
│  │  HTTP Calls: http://localhost:8000/api                     │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              ▼ HTTP/REST                            │
└─────────────────────────────────────────────────────────────────────┘
                                 ▲
                                 │
                    ┌────────────┴────────────┐
                    ▼                        ▼
          http://localhost:3000    http://localhost:8000
          (React Frontend)          (FastAPI Backend)


┌─────────────────────────────────────────────────────────────────────┐
│                   BUSINESS LOGIC LAYER (FastAPI)                    │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │           Route Layer (app/main.py)                          │   │
│  │                                                              │   │
│  │  POST   /api/interactions/log-form   ─┐                      │   │
│  │  POST   /api/interactions/log-chat   ─┼─► Agent Router       │   │
│  │  GET    /api/interactions                                    │   │
│  │  GET    /api/interactions/{id}                               │   │
│  │  PUT    /api/interactions/{id}                               │   │
│  │  DELETE /api/interactions/{id}                               │   │
│  │  POST   /api/agent/chat             ─┤                       │   │
│  │  GET    /api/agent/tools            ─┘                       │   │
│  │  ...                                                         │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │     LangGraph AI Agent (app/agents/hcp_agent.py)            │   │
│  │                                                              │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │
│  │  │           StateGraph Workflow                       │   │   │
│  │  │                                                     │   │   │
│  │  │  [START]                                           │   │   │
│  │  │    │                                               │   │   │
│  │  │    ▼                                               │   │   │
│  │  │  ┌──────────────────┐                             │   │   │
│  │  │  │  Router Node     │                             │   │   │
│  │  │  │  - Analyze input │                             │   │   │
│  │  │  │  - Route to tool │                             │   │   │
│  │  │  └─────────┬────────┘                             │   │   │
│  │  │            │                                      │   │   │
│  │  │  ┌─────────┴──────────────────────────────┐       │   │   │
│  │  │  │                                        │       │   │   │
│  │  │  ▼                                        ▼       │   │   │
│  │  │┌──────────────┐ ┌──────────────────┐ ┌────────┐ │   │   │
│  │  ││ Tool Nodes   │ │                  │ │        │ │   │   │
│  │  ││              │ │                  │ │        │ │   │   │
│  │  ││1. log_inter  │ │ 2. edit_inter    │ │3. sched│ │   │   │
│  │  ││4. analyze    │ │ 5. prepare_cont  │ │        │ │   │   │
│  │  └──────┬───────┘ └────────┬─────────┘ └───┬────┘ │   │   │
│  │  │      │                  │                │      │   │   │
│  │  │      └──────────────────┼────────────────┘      │   │   │
│  │  │                         ▼                      │   │   │
│  │  │                  ┌──────────────┐             │   │   │
│  │  │                  │ Respond Node │             │   │   │
│  │  │                  │ Format output│             │   │   │
│  │  │                  └──────┬───────┘             │   │   │
│  │  │                         │                     │   │   │
│  │  │                         ▼                     │   │   │
│  │  │                      [END]                   │   │   │
│  │  │                                             │   │   │
│  │  └─────────────────────────────────────────────┘   │   │
│  │                                                      │   │
│  │  ┌─────────────────────────────────────────────────┐   │   │
│  │  │        Tool Coordination                        │   │   │
│  │  │  - Async execution                             │   │   │
│  │  │  - Error handling                              │   │   │
│  │  │  - LLM integration per tool                     │   │   │
│  │  └─────────────────────────────────────────────────┘   │   │
│  └──────────────────────────────────────────────────────────┘   │
│                              ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │          Tools Layer (app/tools/)                            │   │
│  │                                                              │   │
│  │  ┌──────────────────────────────────────────────────────┐   │   │
│  │  │ Tool #1: Log Interaction (log_interaction.py)       │   │   │
│  │  │ ├─ Input: Raw interaction content                   │   │   │
│  │  │ ├─ Processing:                                      │   │   │
│  │  │ │  ├─ Call Groq LLM for summarization               │   │   │
│  │  │ │  ├─ Entity extraction (products, conditions)      │   │   │
│  │  │ │  ├─ Sentiment analysis                            │   │   │
│  │  │ │  ├─ Action item extraction                        │   │   │
│  │  │ │  └─ Topic identification                          │   │   │
│  │  │ └─ Output: Enriched interaction data                │   │   │
│  │  └──────────────────────────────────────────────────────┘   │   │
│  │                                                              │   │
│  │  ┌──────────────────────────────────────────────────────┐   │   │
│  │  │ Tool #2: Edit Interaction (edit_interaction.py)     │   │   │
│  │  │ ├─ Input: Interaction ID + updates                  │   │   │
│  │  │ ├─ Validation: Check editable fields                │   │   │
│  │  │ └─ Output: Updated interaction data                 │   │   │
│  │  └──────────────────────────────────────────────────────┘   │   │
│  │                                                              │   │
│  │  ┌──────────────────────────────────────────────────────┐   │   │
│  │  │ Tool #3: Schedule Follow-up (schedule_followup.py)  │   │   │
│  │  │ ├─ Input: HCP ID + followup details                 │   │   │
│  │  │ ├─ Validation: Date/type/purpose                    │   │   │
│  │  │ └─ Output: Scheduled followup confirmation          │   │   │
│  │  └──────────────────────────────────────────────────────┘   │   │
│  │                                                              │   │
│  │  ┌──────────────────────────────────────────────────────┐   │   │
│  │  │ Tool #4: Analyze Territory (analyze_territory.py)   │   │   │
│  │  │ ├─ Input: Territory ID + interactions               │   │   │
│  │  │ ├─ Processing: LLM-based analysis                   │   │   │
│  │  │ │  ├─ Top performer identification                  │   │   │
│  │  │ │  ├─ Engagement pattern analysis                   │   │   │
│  │  │ │  └─ Strategic recommendations                     │   │   │
│  │  │ └─ Output: Territory insights                       │   │   │
│  │  └──────────────────────────────────────────────────────┘   │   │
│  │                                                              │   │
│  │  ┌──────────────────────────────────────────────────────┐   │   │
│  │  │ Tool #5: Prepare Sales Content (prepare_sales.py)   │   │   │
│  │  │ ├─ Input: HCP data + content type                   │   │   │
│  │  │ ├─ Processing: LLM generation                       │   │   │
│  │  │ │  ├─ Personalization analysis                      │   │   │
│  │  │ │  ├─ Content generation                            │   │   │
│  │  │ │  └─ Pain point addressing                         │   │   │
│  │  │ └─ Output: Generated content                        │   │   │
│  │  └──────────────────────────────────────────────────────┘   │   │
│  │                                                              │   │
│  │  All Tools Share:                                           │   │
│  │  - Groq LLM Integration (gemma2-9b-it)                     │   │
│  │  - Async execution (asyncio)                               │   │
│  │  - Error handling                                          │   │
│  │  - Type safety (Python types)                              │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              ▼                                       │
│                        Groq API                                      │
│                    (gemma2-9b-it LLM)                               │
│                  https://api.groq.com/openai/v1                     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│              DATA PERSISTENCE LAYER (SQLAlchemy ORM)               │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │        Database Models (app/models/interaction.py)          │   │
│  │                                                              │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │
│  │  │ Table: hcp_interactions                             │   │   │
│  │  │                                                     │   │   │
│  │  │ Columns:                                           │   │   │
│  │  │ - id (PK)                                          │   │   │
│  │  │ - hcp_id, hcp_name (FK)                            │   │   │
│  │  │ - interaction_type (enum)                          │   │   │
│  │  │ - interaction_date (DateTime)                      │   │   │
│  │  │ - location, specialty                              │   │   │
│  │  │ - raw_content (Text)                               │   │   │
│  │  │ - summary (AI-generated)                           │   │   │
│  │  │ - key_topics (JSON array)                          │   │   │
│  │  │ - entities (JSON object)                           │   │   │
│  │  │ - sentiment (enum)                                 │   │   │
│  │  │ - action_items (JSON array)                        │   │   │
│  │  │ - created_by, created_at, updated_at               │   │   │
│  │  │ - is_archived (soft delete)                        │   │   │
│  │  └─────────────────────────────────────────────────────┘   │   │
│  │                                                              │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │
│  │  │ Table: hcp_profiles                                │   │   │
│  │  │                                                     │   │   │
│  │  │ Columns:                                           │   │   │
│  │  │ - id (PK)                                          │   │   │
│  │  │ - hcp_id (UK)                                      │   │   │
│  │  │ - first_name, last_name                            │   │   │
│  │  │ - specialty, organization, location                │   │   │
│  │  │ - email, phone                                      │   │   │
│  │  │ - last_interaction_date                            │   │   │
│  │  │ - interaction_count                                │   │   │
│  │  │ - created_at                                       │   │   │
│  │  └─────────────────────────────────────────────────────┘   │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │           Database Connection Layer                          │   │
│  │           (app/database/connection.py)                       │   │
│  │                                                              │   │
│  │  - SQLAlchemy Engine Setup                                  │   │
│  │  - Database Type Detection                                  │   │
│  │  - Connection Pooling                                       │   │
│  │  - Session Management (get_db dependency)                   │   │
│  │  - Auto-migration Support                                   │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                 Database Options                             │   │
│  │                                                              │   │
│  │  Development: SQLite (hcp.db)                               │   │
│  │  ├─ Zero setup                                              │   │
│  │  ├─ File-based storage                                      │   │
│  │  └─ Perfect for testing                                     │   │
│  │                                                              │   │
│  │  Production: PostgreSQL                                     │   │
│  │  ├─ Scalable                                                │   │
│  │  ├─ High concurrency                                        │   │
│  │  └─ Enterprise features                                     │   │
│  │                                                              │   │
│  │  Optional: MySQL                                            │   │
│  │  ├─ Alternative SQL database                                │   │
│  │  ├─ MySQL connector support                                 │   │
│  │  └─ Configuration available                                 │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Component Interaction Flows

### Flow 1: Form-Based Interaction Logging

```
User (React UI)
    │
    ├─ Fills form with HCP details
    │
    ├─ Clicks "Log Interaction"
    │
    ▼
Redux Store
    │
    ├─ Dispatch: setIsProcessing(true)
    │
    ▼
API Service (axios)
    │
    ├─ POST /api/interactions/log-form
    │
    ▼
FastAPI Route Handler
    │
    ├─ Parse request
    ├─ Validate input
    │
    ▼
LangGraph Agent
    │
    ├─ Route to "log_interaction" tool
    │
    ▼
Log Interaction Tool
    │
    ├─ Call Groq LLM
    │   ├─ Summarize content
    │   ├─ Extract entities
    │   ├─ Analyze sentiment
    │   ├─ Identify action items
    │   └─ Extract topics
    │
    ▼
Database (SQLAlchemy)
    │
    ├─ Save HCPInteractionDB record
    │
    ▼
Response
    │
    ├─ Return enriched interaction data
    │
    ▼
Redux Store
    │
    ├─ Dispatch: addInteraction(data)
    ├─ Dispatch: setIsProcessing(false)
    │
    ▼
React UI
    │
    ├─ Display success toast
    ├─ Update interactions list
    ├─ Reset form
    │
    ▼
User sees result
```

### Flow 2: Chat-Based Interaction Logging

```
User (Chat Interface)
    │
    ├─ Types natural language message
    │
    ├─ Clicks Send
    │
    ▼
Redux Store
    │
    ├─ Dispatch: setIsProcessing(true)
    │
    ▼
API Service
    │
    ├─ POST /api/interactions/log-chat
    │
    ▼
FastAPI Route Handler
    │
    ├─ Parse user message
    │
    ▼
LangGraph Agent
    │
    ├─ Node: router
    │   └─ Analyze user intent
    │   └─ Route to appropriate tool
    │
    ├─ Node: tool_execution (e.g., log_interaction)
    │   │
    │   └─ Call Log Interaction Tool
    │       └─ LLM processes message
    │       └─ Extracts interaction structure
    │
    ├─ Node: respond
    │   └─ Format response
    │
    ▼
Response
    │
    ├─ Return agent action + result
    │
    ▼
Chat Interface
    │
    ├─ Display assistant message
    │
    ▼
Redux Store
    │
    ├─ Dispatch: setIsProcessing(false)
    │
    ▼
User sees AI-processed result
```

### Flow 3: Analyzing Territory

```
User clicks "Analyze Territory"
    │
    ├─ Selects territory
    │
    ▼
API Service
    │
    ├─ Fetches all interactions for territory
    │
    ▼
LangGraph Agent
    │
    ├─ Routes to "analyze_territory" tool
    │
    ▼
Analyze Territory Tool
    │
    ├─ Receives interactions data
    │
    ├─ Calls Groq LLM
    │   ├─ Identify top HCPs
    │   ├─ Detect engagement patterns
    │   ├─ Generate recommendations
    │
    ▼
Response
    │
    ├─ Return insights and analysis
    │
    ▼
Dashboard
    │
    ├─ Display territory insights
    │
    ▼
User sees strategic recommendations
```

---

## Data Models & Relationships

```
HCPProfile (1) ──────── (many) HCPInteraction
    │                          │
    ├─ hcp_id (PK, UK)        ├─ id (PK)
    ├─ first_name             ├─ hcp_id (FK)
    ├─ last_name              ├─ hcp_name
    ├─ specialty              ├─ interaction_type
    ├─ organization           ├─ interaction_date
    ├─ location               ├─ location
    ├─ email                  ├─ specialty
    ├─ phone                  ├─ raw_content
    ├─ last_interaction_date  ├─ summary (AI)
    └─ interaction_count      ├─ key_topics (AI)
                              ├─ entities (AI)
                              ├─ sentiment (AI)
                              ├─ action_items (AI)
                              ├─ created_by
                              ├─ created_at
                              ├─ updated_at
                              └─ is_archived
```

---

## API Request/Response Flow

```
┌─────────────────────────────────────────────┐
│ Client (React Frontend)                     │
│  - Validates input                          │
│  - Calls API service                        │
│  - Handles response                         │
│  - Updates Redux store                      │
│  - Re-renders UI                            │
└────────────┬────────────────────────────────┘
             │ HTTP Request (POST/GET/PUT/DELETE)
             │ JSON payload + headers
             │
             ▼
┌─────────────────────────────────────────────┐
│ Server (FastAPI)                            │
│  ├─ Receives request                        │
│  ├─ Route matching (path + method)          │
│  ├─ Request validation (Pydantic)           │
│  ├─ Authentication (future)                 │
│  ├─ Authorization (future)                  │
│  └─ Handler execution                       │
└────────────┬────────────────────────────────┘
             │
             ├─ For POST /interactions/log-form:
             │   │
             │   ├─ Extract form data
             │   │
             │   ├─ Call Log Interaction Tool
             │   │   └─ LLM processing
             │   │
             │   └─ Save to database
             │
             │
             ├─ For GET /interactions:
             │   │
             │   └─ Query database
             │
             │
             └─ For Other endpoints...
             │
             ▼
         Response
         - Status code
         - JSON data
         - Headers
             │
             ▼
┌─────────────────────────────────────────────┐
│ Client Receives Response                    │
│  ├─ Status check                            │
│  ├─ Data extraction                         │
│  ├─ Error handling                          │
│  └─ UI update                               │
└─────────────────────────────────────────────┘
```

---

## LangGraph Agent Workflow States

```
┌─────────────────────────────────────────┐
│ AgentState (Pydantic Model)             │
│                                         │
│ - user_input: str                       │
│ - action: str (tool name)               │
│ - action_input: Dict                    │
│ - result: Optional[Dict]                │
│ - error: Optional[str]                  │
│ - messages: List[Dict]                  │
└─────────────────────────────────────────┘
         ▲
         │
         │ State transitions through nodes
         │
         ▼
┌─────────────────────────────────────────┐
│           Workflow Nodes                │
│                                         │
│ 1. [START]                              │
│    └──► router node                     │
│                                         │
│ 2. router node                          │
│    └──► conditionally route to:         │
│                                         │
│    ├─► log_interaction_node             │
│    ├─► edit_interaction_node            │
│    ├─► schedule_followup_node           │
│    ├─► analyze_territory_node           │
│    ├─► prepare_content_node             │
│    └─► respond (default)                │
│                                         │
│ 3. Tool nodes                           │
│    └──► respond node                    │
│                                         │
│ 4. respond node                         │
│    └──► [END]                           │
│                                         │
└─────────────────────────────────────────┘
```

---

## Technology Stack Layers

```
┌─────────────────────────────────────────────────────────┐
│ PRESENTATION LAYER                                      │
│ ├─ React 18.2 (UI framework)                           │
│ ├─ Redux + Redux Toolkit (state management)            │
│ ├─ Tailwind CSS (styling)                              │
│ ├─ TypeScript (type safety)                            │
│ └─ Axios (HTTP client)                                 │
└─────────────────────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────┐
│ API LAYER                                               │
│ ├─ FastAPI (web framework)                             │
│ ├─ Pydantic (validation)                               │
│ ├─ CORS (cross-origin)                                 │
│ └─ OpenAPI (documentation)                             │
└─────────────────────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────┐
│ ORCHESTRATION LAYER                                     │
│ ├─ LangGraph (workflow)                                │
│ ├─ StateGraph (state management)                       │
│ └─ Async/await (concurrency)                           │
└─────────────────────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────┐
│ TOOLS LAYER                                             │
│ ├─ Log Interaction Tool                                │
│ ├─ Edit Interaction Tool                               │
│ ├─ Schedule Follow-up Tool                             │
│ ├─ Analyze Territory Tool                              │
│ └─ Prepare Sales Content Tool                          │
└─────────────────────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────┐
│ AI LAYER                                                │
│ ├─ LangChain (LLM abstractions)                         │
│ ├─ Groq (LLM provider)                                 │
│ ├─ gemma2-9b-it (model)                                │
│ └─ ChatGroq (integration)                              │
└─────────────────────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────┐
│ DATA LAYER                                              │
│ ├─ SQLAlchemy (ORM)                                    │
│ ├─ Pydantic (models)                                   │
│ ├─ SQLite/PostgreSQL/MySQL (database)                  │
│ └─ Connection pooling (performance)                    │
└─────────────────────────────────────────────────────────┘
```

---

## Performance & Scalability

### Current Architecture
- **Frontend**: Single-page app (fast)
- **Backend**: Async FastAPI (handles concurrent requests)
- **LLM**: Groq (fast inference)
- **Database**: SQLAlchemy (connection pooling)

### Scaling Strategies
1. **Horizontal**: Add more FastAPI instances behind load balancer
2. **Vertical**: Increase server resources
3. **Caching**: Redis for frequently accessed data
4. **Database**: Connection pooling, read replicas
5. **LLM**: Batch requests, rate limiting

### Performance Targets
- Form submission: 2-3 seconds (LLM processing)
- Chat response: 2-3 seconds (LLM processing)
- API response: <100ms (average)
- Frontend build: ~60 seconds
- Page load: <2 seconds

---

## Security Architecture

```
┌──────────────────────────────────────┐
│ Frontend Security                    │
│ ├─ XSS Protection (React automatic)  │
│ ├─ CSRF Tokens (future)              │
│ ├─ Input validation                  │
│ └─ Secure storage (localStorage)     │
└──────────────────────────────────────┘
              ▼
┌──────────────────────────────────────┐
│ Network Security                     │
│ ├─ HTTPS/TLS (future)                │
│ ├─ CORS policy                       │
│ └─ Rate limiting (future)            │
└──────────────────────────────────────┘
              ▼
┌──────────────────────────────────────┐
│ Application Security                 │
│ ├─ Pydantic validation               │
│ ├─ Error handling                    │
│ ├─ Logging & monitoring              │
│ └─ Authentication (future)           │
└──────────────────────────────────────┘
              ▼
┌──────────────────────────────────────┐
│ Data Security                        │
│ ├─ SQL injection prevention (ORM)    │
│ ├─ Connection pooling                │
│ ├─ Encryption (future)               │
│ └─ Backups (operational)             │
└──────────────────────────────────────┘
              ▼
┌──────────────────────────────────────┐
│ API Security                         │
│ ├─ Input validation                  │
│ ├─ Output encoding                   │
│ ├─ API key management                │
│ └─ Environment variables             │
└──────────────────────────────────────┘
```

---

**Architecture Version**: 1.0.0  
**Last Updated**: January 2026  
**Status**: Production Ready
