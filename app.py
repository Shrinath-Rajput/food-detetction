from flask import Flask, request, jsonify
import os
from werkzeug.utils import secure_filename
from src.Pipeline.predict_pipeline import PredictPipeline

# ✅ APP INIT
app = Flask(__name__)

UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# ✅ ABSOLUTE MODEL PATH FIX
BASE_DIR = os.getcwd()
MODEL_PATH = os.path.join(BASE_DIR, "artifacts", "model.tflite")

print("🔥 MODEL PATH:", MODEL_PATH)

# ✅ LOAD MODEL
predictor = PredictPipeline(MODEL_PATH)

CLASS_INDICES = {
    "freshapple": 0,
    "rottenapple": 1
}

# ================= HEALTH =================
@app.route("/api/health")
def health():
    return {"status": "OK"}


# ================= PREDICT =================
@app.route("/api/predict", methods=["POST"])
def predict():
    try:

        # ✅ CHECK FILE
        if "image" not in request.files:
            return jsonify({
                "success": False,
                "error": "No file uploaded"
            })

        file = request.files["image"]

        if file.filename == "":
            return jsonify({
                "success": False,
                "error": "Empty filename"
            })

        filename = secure_filename(file.filename)

        path = os.path.join(UPLOAD_FOLDER, filename)

        # ✅ SAVE FILE
        file.save(path)

        print("🔥 IMAGE SAVED:", path)

        # ✅ PREDICT
        result = predictor.predict(path, CLASS_INDICES)

        print("🔥 RESULT:", result)

        # ✅ DELETE TEMP FILE
        if os.path.exists(path):
            os.remove(path)

        # ✅ SAFETY CHECK
        if not result:
            return jsonify({
                "success": False,
                "error": "Prediction returned None"
            })

        if "class" not in result:
            return jsonify({
                "success": False,
                "error": "Class not found in result"
            })

        freshness = "Fresh"

        if "rotten" in result["class"].lower():
            freshness = "Rotten"

        return jsonify({
            "success": True,
            "prediction": {
                "class": result["class"],
                "freshness": freshness,
                "confidence": float(result["confidence"])
            }
        })

    except Exception as e:

        print("❌ ERROR:", str(e))

        return jsonify({
            "success": False,
            "error": str(e)
        })


# ================= START =================
if __name__ == "__main__":

    port = int(os.environ.get("PORT", 8000))

    app.run(
        host="0.0.0.0",
        port=port,
        debug=False
    )