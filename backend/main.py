from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from pymongo import MongoClient
import random
from typing import List

# Initialize FastAPI app
app = FastAPI()

# MongoDB connection
client = MongoClient("mongodb://localhost:27017/")
db = client["drive_test_db"]

rf_data_collection = db["rf_data"]
rf_data_collection.create_index("cell_id", unique=False)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace "*" with your React app URL in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Pydantic model for RF data
class RFData(BaseModel):
    type: str
    cgi: str
    psc: int
    cid: str
    rssi: int
    lac: float
    NetworkIso: str
    MCC: int
    MNC: int
    band: str
    downlink: str
    cellNumber: str
    ecNo: int



# Helper function to serialize MongoDB documents
def serialize_mongo_doc(doc):
    return {**doc, "_id": str(doc["_id"])}


# Endpoint to collect RF data
@app.post("/collect-data/")
async def collect_data(data: RFData):
    db["rf_data"].insert_one(data.dict())
    return {"status": "success", "data": data}


# Endpoint to retrieve RF data by cell_id
@app.get("/get-data/{cell_id}")
async def get_data(cell_id: str):
    """Get the data by cell ID."""
    data = list(db["rf_data"].find({"cell_id": cell_id}))
    if not data:
        raise HTTPException(status_code=404, detail="No data found for the given cell_id")
    serialized_data = [serialize_mongo_doc(doc) for doc in data]
    return {"status": "success", "data": serialized_data}


# Pydantic model for dummy cell info
class DummyCellInfo(BaseModel):
    type: str
    cgi: str
    psc: int
    cid: str
    rssi: int
    lac: float
    NetworkIso: str
    MCC: int
    MNC: int
    band: str
    downlink: str
    cellNumber: str
    ecNo: int


# Endpoint to generate dummy cell info data
@app.get("/cell-info/{cell_id}", response_model=List[DummyCellInfo])
async def get_cell_info(cell_id: str):
    """Return dummy data about cell info from 100 devices."""
    dummy_data = [
        {
            "cid": f"{cell_id}_{i}",
            "lat": round(random.uniform(-90.0, 90.0), 6),
            "lac": round(random.uniform(-180.0, 180.0), 6),
            "band": random.choice(["LTE", "5G", "4G", "3G"]),
            "cgi": round(random.uniform(800.0, 3800.0), 2),
            "psc": random.randint(0, 503),
            "rssi": round(random.uniform(-120.0, -60.0), 2),
            "type": random.choice(["WCDMA", "GSM", "LTE"]),
            "ConnectionStatus": random.choice(["PrimaryConnection()", "SecondaryConnection()", "Idle"]),
            "NetworkIso": random.choice(["US", "IN", "CN", "CM"]),
            "MCC": random.randint(200, 999),
            "MNC": random.randint(0, 999),
            "Downlink": random.choice(["Up", "Active", "Idle", "Inactive"]),
            "cellNumber": round(random.uniform(0, 999999), 9),
            "ecNo": round(random.uniform(0, 100), 2
                          ),
        }
        for i in range(100)
    ]
    return dummy_data


# Root endpoint
@app.get("/")
async def root():
    return {"message": "Hello, FastAPI"}
