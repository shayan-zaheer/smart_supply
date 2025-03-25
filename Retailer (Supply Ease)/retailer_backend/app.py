from flask import Flask,render_template, request
from flask_cors import CORS
from flask_mysqldb import MySQL
from flask import jsonify
from collections import defaultdict
from datetime import datetime

app = Flask(__name__)
CORS(app)  # This will enable CORS for all routes

app.config['MYSQL_HOST'] = '127.0.0.1'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'saqib0099'
app.config['MYSQL_DB'] = 'SmartSupply'
 
mysql = MySQL(app)
@app.route('/retailer_login', methods=['POST'])
def retailer_login():
    data = request.get_json()

    # Extract data from the request
    email = data.get('email')
    password = data.get('password')
    print(email,password)

    # Verify login credentials
    try:
        cursor = mysql.connection.cursor()

        query = """
            SELECT RetailerId, RetailerEmail, RetailerPassword, RetailerName
            FROM retailer WHERE RetailerEmail = %s AND RetailerPassword = %s
        """
        cursor.execute(query, (email, password))
        retailer = cursor.fetchone()
        print(retailer)

        cursor.close()

        if retailer:
            # Extract the RetailerId from the result
            retailer_id = retailer[0]  # RetailerId is the first column in the result tuple
            email=retailer[1]
            password=retailer[2]
            retailer_name=retailer[3]


            return jsonify({'message': 'Login successful', 'retailer_id': retailer_id, 'retailer': retailer_name,'retailer_email':email }), 200
        else:
            return jsonify({'error': 'Invalid email or password'}), 401
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/retailer_signup', methods=['POST'])
def retailer_signup():
    data = request.get_json()

    # Extract data from the request
    name = data.get('name')
    email = data.get('email')
    phone = data.get('phone')
    password = data.get('password')
    address = data.get('address')


    # Insert data into the database
    try:

        cursor = mysql.connection.cursor()

        query = """
            INSERT INTO retailer (RetailerName, RetailerEmail, RetailerPassword)
            VALUES (%s, %s, %s)
        """
        cursor.execute(query, (name, email, password))
        mysql.connection.commit()

        cursor.close()
        

        return jsonify({'message': 'Retailer signup successful'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/products', methods=['GET'])
def get_products():
    # Creating a cursor to interact with the MySQL database
    cursor = mysql.connection.cursor()

    # Executing the SQL query to fetch all products
    cursor.execute('''SELECT * FROM product WHERE ProductPayment = 'false' ''')

    
    # Fetching all the results from the executed query
    products = cursor.fetchall()
    
    # Closing the cursor after operation
    mysql.connection.commit()
    cursor.close()
    
    
    # Converting the products into a list of dictionaries for easy handling (optional)
    product_list = []
    for product in products:
        product_data = {
            'ProductId': product[0],
            'ProductName': product[1],
            'ProductType': product[2],
            'ProductPrice': product[3],
            'ProductQuantity': product[4],
            'ProductDescription': product[5],
            'ProductExpiryDate': product[6],
            'ProductPayment': product[7],
            'ProductImage': product[8],
            'SellerId': product[9]
        }
        product_list.append(product_data)
    
    # Returning the products as JSON
    return jsonify(product_list)

from flask import request, jsonify
from collections import defaultdict
import MySQLdb

@app.route('/fetchorders', methods=['GET'])
def order_history():
    try:
        # Get retailer_id from query parameters
        retailer_id = request.args.get('RetailerId')
        
        # Ensure retailer_id is provided
        if not retailer_id:
            return jsonify({"error": "RetailerId is required"}), 400
        
        # Prepare the SQL query with parameterization
        query = """SELECT 
            o.OrderId,
            o.OrderDateTime,
            o.RetailerId,
            r.RetailerEmail,
            o.TotalPrice,
            od.ProductId,
            p.ProductName
        FROM `order` o
        JOIN retailer r ON o.RetailerId = r.RetailerId
        JOIN orderdetail od ON o.OrderId = od.OrderId
        JOIN product p ON od.ProductId = p.ProductId 
        WHERE o.RetailerId = %s"""
        
        # Execute the query with retailer_id parameter
        cur = mysql.connection.cursor()
        cur.execute(query, (retailer_id,))
        orders = cur.fetchall()

        mysql.connection.commit()
        cur.close()
        
        
        
        # Group orders by OrderId
        grouped_orders = defaultdict(lambda: {
            "OrderId": None,
            "OrderDateTime": None,
            "RetailerId": None,
            "RetailerEmail": None,
            "TotalPrice": None,
            "Products": []
        })
        
        for order in orders:
            order_id = order[0]
            if not grouped_orders[order_id]["OrderId"]:
                grouped_orders[order_id].update({
                    "OrderId": order[0],
                    "OrderDateTime": order[1],
                    "RetailerId": order[2],
                    "RetailerEmail": order[3],
                    "TotalPrice": order[4]
                })
            grouped_orders[order_id]["Products"].append({
                "ProductId": order[5],
                "ProductName": order[6]
            })
        
        # Return the grouped order data as a JSON response
        return jsonify(list(grouped_orders.values())), 200
    
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500

@app.route('/placeorder', methods=['POST'])
def place_order():
    try:
        order_data = request.get_json()
        retailer_id = order_data.get('RetailerId')
        total_price = order_data.get('TotalPrice')
        product_details = order_data.get('Products')

        if not retailer_id or not total_price or not product_details:
            return jsonify({"error": "Missing required fields: RetailerId, TotalPrice, or Products"}), 400

        order_datetime = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        cursor = mysql.connection.cursor()

        cursor.execute('''INSERT INTO `order` (OrderDateTime, RetailerId, TotalPrice) 
                           VALUES (%s, %s, %s)''', (order_datetime, retailer_id, total_price))

        order_id = cursor.lastrowid  # Retrieve the last inserted OrderId

        for product in product_details:
            product_id = product.get('ProductId')
            if product_id:
                cursor.execute('''INSERT INTO `orderdetail` (OrderId, ProductId) 
                                   VALUES (%s, %s)''', (order_id, product_id))
                
                # Update ProductPayment to 'TRUE' for the product
                cursor.execute('''UPDATE `product` 
                                  SET `ProductPayment` = 'true' 
                                  WHERE `ProductId` = %s''', (product_id,))

     

        mysql.connection.commit()
        cursor.close()


        return jsonify({"message": f"Order placed successfully with OrderId: {order_id}"}), 201

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500
app.run(host='localhost', port=5000)
