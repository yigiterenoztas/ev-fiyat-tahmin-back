import pickle
import pandas as pd
from models.schemas import HouseInput

# 🔹 Modeli yükle
with open(r"C:\Users\oulku\OneDrive\Desktop\auu_back\backend\app\models\final_model.pkl", "rb") as f:
    model = pickle.load(f)

# 🔹 'Column_0' gibi gereksiz sütunları çıkar
model_features = [f for f in model.feature_names_in_ if f != 'Column_0']

# okyanus yakınlığı değeri için encoding fonksiyonu
# Bu fonksiyon, modelin beklediği özellik adlarıyla eşleşen bir sözlük döndürür.
def encode_ocean_proximity(value: str, model_features: list) -> dict:
    possible_keys = [
        'ocean_proximity_INLAND',
        'ocean_proximity_NEAR BAY',
        'ocean_proximity_NEAR OCEAN',
        'ocean_proximity_ISLAND',
        'ocean_proximity_<1H OCEAN'
    ]
    encoded = {}
    selected_key = f"ocean_proximity_{value.upper()}"
    for key in possible_keys:
        if key in model_features:
            encoded[key] = 1 if key == selected_key else 0
    return encoded

# Tahmin fonksiyonu
def predict_house_value(data: HouseInput) -> float:
    # Ana giriş verileri
    features = {
        "longitude": data.longitude,
        "latitude": data.latitude,
        "housing_median_age": data.housing_median_age,
        "total_rooms": data.total_rooms,
        "bedrooms": data.total_bedrooms,
        "population": data.population,
        "households": data.households,
        "median_income": data.median_income
    }
    

    # encoding işlemi
    ocean_encoded = encode_ocean_proximity(data.ocean_proximity, model_features)
    features.update(ocean_encoded)

    # Sadece modelin beklediği sütunları sırayla al (eksik varsa sıfırla)
    ordered_data = {key: features.get(key, 0) for key in model_features}

    # DataFrame oluştur ve tahmini al
    df = pd.DataFrame([ordered_data])
    predicted_price = model.predict(df)[0]

    print("📊 Girdi verisi:")
    print(df)
    print("📈 Tahmin sonucu:", predicted_price)

    return float(predicted_price)