from flask import Flask, jsonify, request
from flask_cors import CORS
import sqlite3

app = Flask(__name__)
CORS(app)

PRODUCTS = [
    {"id": 1, "title": "Essence Mascara", "price": 8.94, "thumbnail": "https://images.unsplash.com/photo-1631214524020-7e18db9a8f92?w=400"},
    {"id": 2, "title": "Eyeshadow Palette", "price": 15.50, "thumbnail": "https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=400"},
    {"id": 3, "title": "Lip Gloss", "price": 5.99, "thumbnail": "https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=400"},
    {"id": 4, "title": "Face Powder", "price": 12.00, "thumbnail": "https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400"},
]

def init_db():
    conn = sqlite3.connect("cart.db")
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS cart_items 
                 (product_id INTEGER PRIMARY KEY, quantity INTEGER)''')
    conn.commit()
    conn.close()

def get_cart():
    conn = sqlite3.connect("cart.db")
    c = conn.cursor()
    c.execute("SELECT product_id, quantity FROM cart_items")
    items = c.fetchall()
    conn.close()
    result = []
    total = 0
    for pid, qty in items:
        product = next((p for p in PRODUCTS if p["id"] == pid), None)
        if product:
            item_total = product["price"] * qty
            total += item_total
            result.append({"product": product, "quantity": qty, "total": item_total})
    return {"items": result, "total": total}

@app.route('/products', methods=['GET'])
def products():
    return jsonify({"products": PRODUCTS})

@app.route('/cart', methods=['GET'])
def cart():
    return jsonify(get_cart())

@app.route('/cart/items', methods=['POST'])
def add_item():
    data = request.get_json()
    pid = data.get("product_id")
    conn = sqlite3.connect("cart.db")
    c = conn.cursor()
    c.execute("SELECT quantity FROM cart_items WHERE product_id=?", (pid,))
    row = c.fetchone()
    if row:
        c.execute("UPDATE cart_items SET quantity=? WHERE product_id=?", (row[0]+1, pid))
    else:
        c.execute("INSERT INTO cart_items (product_id, quantity) VALUES (?, 1)", (pid,))
    conn.commit()
    conn.close()
    return jsonify({"status": "ok"})

@app.route('/cart/items/<int:pid>', methods=['DELETE'])
def delete_item(pid):
    conn = sqlite3.connect("cart.db")
    c = conn.cursor()
    c.execute("DELETE FROM cart_items WHERE product_id=?", (pid,))
    conn.commit()
    conn.close()
    return jsonify({"status": "ok"})

if __name__ == '__main__':
    init_db()
    print("Backend running on http://localhost:8000")
    app.run(host='0.0.0.0', port=8000, debug=True)