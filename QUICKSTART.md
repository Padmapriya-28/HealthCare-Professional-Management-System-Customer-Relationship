# Quick Start Guide - HCP CRM

## 🚀 Get Started in 5 Minutes

### Step 1: Backend Setup
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env
# Edit .env and add your Groq API key
uvicorn app.main:app --reload
```
✅ Backend running at: `http://localhost:8000`

### Step 2: Frontend Setup
```bash
cd ../frontend
npm install
cp .env.example .env
npm start
```
✅ Frontend running at: `http://localhost:3000`

### Step 3: Test the System
1. Open `http://localhost:3000`
2. Click "Log Interaction" in sidebar
3. Try the **Structured Form** tab first:
   - Fill in HCP details
   - Describe the interaction
   - Click "Log Interaction"
4. Then try **Chat Interface**:
   - Type a natural description of an interaction
   - Watch the AI process it

### Step 4: Explore Features
- **Dashboard**: View analytics and metrics
- **Interactions List**: See all logged interactions with AI-generated insights
- **API Docs**: Visit `http://localhost:8000/docs` for Swagger UI

## 📝 Sample Test Data

### Test Interaction 1
```
HCP ID: HCP001
Name: Dr. Sarah Johnson
Type: Phone Call
Location: City Hospital
Specialty: Cardiology
Summary: "Called about new beta-blocker. She has 5 cardiac patients interested. Wants samples and clinical data."
```

### Test Interaction 2 (Chat)
```
"Just spoke with Dr. Johnson about our heart medication. She's very interested and mentioned she has several patients who could benefit from it."
```

## 🎯 Next Steps

1. **Customize**: Edit components in `frontend/src/components/`
2. **Add Tools**: Create new tools in `backend/app/tools/`
3. **Extend Database**: Add fields to `backend/app/models/interaction.py`
4. **Deploy**: See README.md for deployment instructions

## ⚠️ Troubleshooting

### Backend won't start
- Check Python version (3.9+)
- Verify Groq API key is set
- Check if port 8000 is available

### Frontend won't start
- Verify Node.js version (16+)
- Delete `node_modules` and run `npm install` again
- Check if port 3000 is available

### API calls failing
- Ensure backend is running
- Check `REACT_APP_API_URL` in frontend `.env`
- Look at network tab in browser DevTools

## 📚 Key Files to Know

**Backend**:
- `app/main.py` - FastAPI app & routes
- `app/agents/hcp_agent.py` - LangGraph agent
- `app/tools/` - The 5 tools implementations
- `app/models/interaction.py` - Database models

**Frontend**:
- `src/App.tsx` - Main app component
- `src/components/LogInteractionScreen.tsx` - Main interface
- `src/redux/` - State management
- `src/services/api.ts` - API calls

## 🔑 Important: Get Your Groq API Key

1. Go to https://console.groq.com
2. Sign up / Log in
3. Create new API key
4. Copy to `.env` file: `GROQ_API_KEY=your_key_here`

---

Happy building! 🎉
