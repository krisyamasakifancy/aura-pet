"""
Aura-Pet Backend - Real-time Updates via SSE
Server-Sent Events for instant pet state sync
"""

from fastapi import APIRouter, Depends
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
import asyncio
import json
import time
from datetime import datetime
from typing import Dict, Set
from collections import defaultdict

from .models.database import get_db
from .models.auth import get_current_user
from .models.models import User, Pet

# ============================================
# SSE CONNECTION MANAGER
# ============================================

class SSEManager:
    """Manages SSE connections for real-time updates."""
    
    def __init__(self):
        # user_id -> set of response objects
        self.connections: Dict[str, Set] = defaultdict(set)
        # Lock for thread safety
        self._lock = asyncio.Lock()
    
    async def connect(self, user_id: str) -> asyncio.Queue:
        """Add a new SSE connection for a user."""
        queue = asyncio.Queue()
        async with self._lock:
            self.connections[user_id].add(queue)
        return queue
    
    async def disconnect(self, user_id: str, queue: asyncio.Queue):
        """Remove SSE connection."""
        async with self._lock:
            if queue in self.connections[user_id]:
                self.connections[user_id].discard(queue)
    
    async def broadcast(self, user_id: str, event_type: str, data: dict):
        """Send event to all connections of a user."""
        message = {
            "event": event_type,
            "data": data,
            "timestamp": datetime.now().isoformat()
        }
        
        async with self._lock:
            queues = list(self.connections.get(user_id, set()))
        
        for queue in queues:
            try:
                await queue.put(message)
            except Exception:
                pass  # Connection might be closed
    
    async def broadcast_all(self, event_type: str, data: dict):
        """Broadcast to all connected users."""
        for user_id in self.connections:
            await self.broadcast(user_id, event_type, data)

# Global SSE manager
sse_manager = SSEManager()

# ============================================
# SSE ROUTER
# ============================================

router = APIRouter(prefix="/api/v1/sse", tags=["SSE"])

@router.get("/connect")
async def sse_connect(
    user: User = Depends(get_current_user)
):
    """
    SSE endpoint for real-time pet updates.
    
    Connect: GET /api/v1/sse/connect
    Events:
    - pet_state_update: Pet mood/stats changed
    - meal_logged: New meal recorded
    - coin_update: Coins changed
    - achievement: New achievement unlocked
    - animation_trigger: Pet should animate
    """
    
    async def event_stream():
        queue = await sse_manager.connect(str(user.id))
        
        try:
            # Send initial connection event
            yield f"event: connected\ndata: {json.dumps({'user_id': str(user.id)}}\n\n"
            
            # Heartbeat every 30 seconds
            heartbeat_interval = 30
            last_heartbeat = time.time()
            
            while True:
                try:
                    # Wait for events with timeout
                    message = await asyncio.wait_for(queue.get(), timeout=1.0)
                    
                    # Format as SSE
                    event_data = f"event: {message['event']}\ndata: {json.dumps(message['data'])}\n\n"
                    yield event_data
                    
                except asyncio.TimeoutError:
                    # Send heartbeat
                    current_time = time.time()
                    if current_time - last_heartbeat >= heartbeat_interval:
                        yield f"event: heartbeat\ndata: {json.dumps({'time': datetime.now().isoformat()})}\n\n"
                        last_heartbeat = current_time
                        
                except Exception:
                    break
                    
        finally:
            await sse_manager.disconnect(str(user.id), queue)
    
    return StreamingResponse(
        event_stream(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no"
        }
    )

# ============================================
# EVENT BROADCASTING HELPERS
# ============================================

async def broadcast_pet_state(user_id: str, pet: dict, animation: str = None):
    """Broadcast pet state update with optional animation."""
    data = {
        "pet_id": pet.get("id"),
        "name": pet.get("name"),
        "mood": pet.get("current_mood"),
        "stats": {
            "hunger": pet.get("hunger"),
            "joy": pet.get("joy"),
            "vigor": pet.get("vigor"),
            "affinity": pet.get("affinity"),
            "evolution_xp": pet.get("evolution_xp"),
            "evolution_level": pet.get("evolution_level")
        }
    }
    
    if animation:
        data["animation"] = animation
    
    await sse_manager.broadcast(user_id, "pet_state_update", data)

async def broadcast_meal_logged(user_id: str, meal: dict, rewards: dict):
    """Broadcast new meal logged event."""
    await sse_manager.broadcast(user_id, "meal_logged", {
        "meal_id": meal.get("id"),
        "food_name": meal.get("food_name"),
        "calories": meal.get("estimated_calories"),
        "anxiety_relief_label": meal.get("anxiety_relief_label"),
        "rewards": rewards
    })

async def broadcast_coins(user_id: str, new_balance: int, earned: int):
    """Broadcast coin update."""
    await sse_manager.broadcast(user_id, "coin_update", {
        "new_balance": new_balance,
        "earned": earned
    })

async def broadcast_animation(user_id: str, animation_type: str, dialogue: str):
    """Broadcast animation trigger to frontend."""
    await sse_manager.broadcast(user_id, "animation_trigger", {
        "type": animation_type,
        "dialogue": dialogue,
        "timestamp": datetime.now().isoformat()
    })
