from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/predict", methods=["POST"])
def predict():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files["file"]
    
    # ✅ Example: Dummy prediction (Replace with your ML model logic)
    result = {"prediction": "cat", "confidence": 98.5}  

    return jsonify(result)  # 🔹 Return JSON instead of raw data

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
