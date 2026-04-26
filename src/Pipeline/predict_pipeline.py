import os
import numpy as np
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import load_img, img_to_array

class PredictPipeline:
    def __init__(self, model_path="artifacts/model.h5"):
        if not os.path.exists(model_path):
            raise Exception("Model not found")
        self.model = load_model(model_path)

    def predict(self, image_path, class_indices):
        try:
            img = load_img(image_path, target_size=(224, 224))
            img = img_to_array(img) / 255.0
            img = np.expand_dims(img, axis=0)

            preds = self.model.predict(img)[0]

            print("🔥 RAW:", preds)

            idx = int(np.argmax(preds))
            confidence = float(preds[idx])

            # ✅ SAFE MAPPING (NO CRASH)
            class_names = list(class_indices.keys())

            if len(class_names) == 0:
                return {"class": "unknown", "confidence": 0}

            if idx >= len(class_names):
                idx = 0   # fallback

            class_name = class_names[idx]

            return {
                "class": class_name,
                "confidence": confidence
            }

        except Exception as e:
            print("❌ ERROR IN PREDICT:", e)
            return {"class": "unknown", "confidence": 0}