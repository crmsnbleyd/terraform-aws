import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def health():
    return jsonify({
        "status": "healthy",
        "environment": os.getenv("ENV", "unknown")
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
