#!/bin/bash

# HCP CRM Setup Script
# Run this script to automatically set up both backend and frontend

echo "================================"
echo "HCP CRM - AI-First CRM Setup"
echo "================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Python
echo -e "${YELLOW}Checking Python installation...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Python 3 is not installed. Please install Python 3.9+${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Python 3 found: $(python3 --version)${NC}"
echo ""

# Check Node.js
echo -e "${YELLOW}Checking Node.js installation...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}Node.js is not installed. Please install Node.js 16+${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js found: $(node --version)${NC}"
echo ""

# Backend Setup
echo -e "${YELLOW}Setting up Backend...${NC}"
cd backend

# Create virtual environment
echo "Creating virtual environment..."
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Setup environment
echo "Setting up environment..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo -e "${YELLOW}Created .env file. Please edit it and add your Groq API key:${NC}"
    echo "GROQ_API_KEY=your_actual_key_here"
fi

echo -e "${GREEN}✓ Backend setup complete!${NC}"
echo ""

# Frontend Setup
echo -e "${YELLOW}Setting up Frontend...${NC}"
cd ../frontend

# Install dependencies
echo "Installing dependencies..."
npm install

# Setup environment
echo "Setting up environment..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo -e "${YELLOW}Created .env file with default settings${NC}"
fi

echo -e "${GREEN}✓ Frontend setup complete!${NC}"
echo ""

# Summary
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "Next steps:"
echo ""
echo "1. Get your Groq API Key:"
echo "   - Visit https://console.groq.com"
echo "   - Create a new API key"
echo "   - Edit backend/.env and add: GROQ_API_KEY=your_key"
echo ""
echo "2. Start Backend (in one terminal):"
echo "   cd backend"
echo "   source venv/bin/activate  # Windows: venv\Scripts\activate"
echo "   uvicorn app.main:app --reload"
echo "   → Backend will run on http://localhost:8000"
echo ""
echo "3. Start Frontend (in another terminal):"
echo "   cd frontend"
echo "   npm start"
echo "   → Frontend will run on http://localhost:3000"
echo ""
echo "4. Test the system:"
echo "   - Open http://localhost:3000"
echo "   - Try the Form Interface"
echo "   - Try the Chat Interface"
echo "   - View Dashboard and Interactions List"
echo ""
echo "5. View API Documentation:"
echo "   http://localhost:8000/docs (Swagger)"
echo "   http://localhost:8000/redoc (ReDoc)"
echo ""
echo -e "${YELLOW}For more details, see QUICKSTART.md${NC}"
