import sys
sys.path.insert(0, 'e:\\hcp\\backend')

from app.agents.hcp_agent import HCPAgent
import asyncio
import traceback

async def test():
    agent = HCPAgent()
    try:
        result = await agent.process_request("Just spoke with Dr. Sarah about cardiac medication")
        print("Result:", result)
    except Exception as e:
        print("Error:", str(e))
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(test())
