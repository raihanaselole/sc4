from flask import Flask, render_template, request

app = Flask(__name__)

@app.route("/")
def index():
    # contoh menampilkan pesan sederhana dan user agent
    info = {
        "message": "Hello welcome to the jungle",
        "status": "ok",
        "client": request.headers.get("User-Agent", "unknown")
    }
    return render_template("index.html", info=info)

# health endpoint (berguna untuk readiness/liveness)
@app.route("/health")
def health():
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)