from fastapi import APIRouter
from models.schemas import HouseInput
from models.services import predict_house_value

router = APIRouter()

@router.get("/saglik")
def saglik_kontrol():
    return{"status": "Helal Sana"}

@router.post("/tahmin")
def tahmin(data: HouseInput):
    predicted_price = predict_house_value(data)
    return {"predicted_price": predicted_price}

