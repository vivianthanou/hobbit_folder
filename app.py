from flask import Flask, request, jsonify
import mysql.connector
import secrets
#from passlib.hash import bcrypt  # Use bcrypt to hash passwords
from flask_cors import CORS
import traceback
import os
from werkzeug.utils import secure_filename

app = Flask(__name__)
CORS(app)

def get_db_connection():
 conn = mysql.connector.connect(
            host="192.168.150.2",
            port=3306,
            user="root",
            password="",  # Add your database password here (if any)
            database="hobbit2",
            charset="utf8mb4",
            collation="utf8mb4_general_ci"
        )
 return conn

@app.route("/login", methods=['POST'])
def login():
    if request.method == 'POST':
        data = request.get_json() 

        email = data.get('email')
        password = data.get('password')

       
        
        db=get_db_connection()

        with db.cursor() as cursor:
            query = "SELECT * FROM user WHERE email = %s AND password = %s"
            cursor.execute(query, (email, password))
            user = cursor.fetchone()

            if user:
                return jsonify(user)
            else:
                return jsonify({"error": "Invalid credentials"}), 401  # Unauthorized

    return jsonify({"error": "Method not allowed"}), 405  # Method not allowed


@app.route('/signup', methods = ['GET','POST'])
def signup():
    try:
        # Assuming data is sent as JSON in the request body
        data = request.get_json()

        # Extract data from JSON payload
        username = data.get('username')
        password = data.get('password')
        email = data.get('email')
        first_name = data.get('first_name')
        last_name = data.get('last_name')
        date_of_birth = data.get('date_of_birth')
        interests = data.get('interests')  # Assuming 'interests' is a list
         
      
        db=get_db_connection()
        cursor = db.cursor()

        # Insert user data into the 'user' table
        cursor.execute("""
            INSERT INTO user
            (first_name, last_name, username, password, date_of_birth, email)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (first_name, last_name, username, password, date_of_birth, email))

        # Get the last inserted id to use it for inserting into user_interests table
        user_id = cursor.lastrowid

        # Insert interests into the 'user_interests' table
        for interest in interests:
            cursor.execute("""
                INSERT INTO user_interests (user_id, interest)
                VALUES (%s, %s)
            """, (user_id, interest))

        db.commit()
        cursor.close()
        return jsonify({"message": "Signup successful"}), 200

    except Exception as e:
        print(f"Error: {e}")
        # Rollback in case there is any error
        db.rollback()
        return jsonify({"error": "Internal Server Error"}), 500

@app.route('/getdata', methods=['GET'])
def get_user_data():
    user_id = request.args.get('userId')
    cursor = None


    db=get_db_connection()
    try:
        cursor = db.cursor(dictionary=True)
        query = """
        SELECT u.*, GROUP_CONCAT(ui.interest) as interests
        FROM user u
        LEFT JOIN user_interests ui ON u.user_id = ui.user_id
        WHERE u.user_id = %s
        GROUP BY u.user_id
        """
        cursor.execute(query, (user_id,))
        user_data = cursor.fetchone()

        if user_data:
            return jsonify(user_data), 200
        else:
            return jsonify({'error': 'User not found'}), 404
    except Exception as e:
        print(e)  # For debugging
        return jsonify({'error': 'Server error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db and db.is_connected():
            db.close()


@app.route('/updateUsername', methods=['POST'])
def update_username():
    user_id = request.json.get('userId')
    new_username = request.json.get('newUsername')

    
    cursor = None
   
    db=get_db_connection()
    try:
        cursor = db.cursor()
        query = "UPDATE user SET username = %s WHERE user_id = %s"
        cursor.execute(query, (new_username, user_id))
        db.commit()

        if cursor.rowcount > 0:
            return jsonify({'message': 'Username updated successfully'}), 200
        else:
            return jsonify({'error': 'No user found with the provided ID'}), 404
    except Exception as e:
        print(e)  # For debugging
        return jsonify({'error': 'Server error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db and db.is_connected():
            db.close()

@app.route('/updateDescription', methods=['POST'])
def update_description():
    user_id = request.json.get('userId')
    new_description = request.json.get('newDescription')

    
    cursor = None
   
    db=get_db_connection()
    try:
        cursor = db.cursor()
        query = "UPDATE user SET user_description = %s WHERE user_id = %s"
        cursor.execute(query, (new_description, user_id))
        db.commit()

        if cursor.rowcount > 0:
            return jsonify({'message': 'Descripton updated successfully'}), 200
        else:
            return jsonify({'error': 'No user found with the provided ID'}), 404
    except Exception as e:
        print(e)  # For debugging
        return jsonify({'error': 'Server error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db and db.is_connected():
            db.close()

@app.route('/updateImage', methods=['POST'])
def update_image():
    user_id = request.json.get('userId')
    new_image = request.json.get('newImage')
    
    
    cursor = None
 
    db=get_db_connection()
    try:
        cursor = db.cursor()
        query = "UPDATE user SET photo = %s WHERE user_id = %s"
        cursor.execute(query, (new_image, user_id))
        db.commit()

        if cursor.rowcount > 0:
            return jsonify({'message': 'Image updated successfully'}), 200
        else:
            return jsonify({'error': 'No user found with the provided ID'}), 404
    except Exception as e:
        print(e)  # For debugging
        return jsonify({'error': 'Server error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db and db.is_connected():
            db.close()

@app.route('/updateInterests', methods=['POST'])
def update_interests():
    user_id = request.json.get('userId')
    new_interest = request.json.get('newInterest')
    
    
    cursor = None
    
    db=get_db_connection()
    try:
        cursor = db.cursor()
        query = "INSERT INTO user_interests (user_id,interest) VALUES (%s,%s)"
        cursor.execute(query, (user_id,new_interest))
        db.commit()

        if cursor.rowcount > 0:
            return jsonify({'message': 'Interest updated successfully'}), 200
        else:
            return jsonify({'error': 'No user found with the provided ID'}), 404
    except Exception as e:
        print(e)  # For debugging
        return jsonify({'error': 'Server error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db and db.is_connected():
            db.close()

@app.route('/create_event', methods =['GET','POST'])
def create_event():
    try:
        # Assuming data is sent as JSON in the request body
        data = request.get_json()
        
        # Extract data from JSON payload
        title = data.get('title')
        date = data.get('date')
        time = data.get('time')
        location = data.get('location')
        latitude = data['latitude']
        longitude = data['longitude']
        photo = data.get('photo')
        description = data.get('description')
        category = data.get('category')
        host_id = data.get('host_id')
        image = request.files['image'] if 'image' in request.files else None
        print(host_id)
        db=get_db_connection()

        if image:
            filename = secure_filename(image.filename)
            filepath = os.path.join('path/to/save', filename)
            image.save(filepath)
         
        cursor = db.cursor()

        # Insert user data into the 'user' table
        cursor.execute("""
            INSERT INTO events (title, date, time, location, photo, description, category, host_id, latitude, longitude, image_url)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (title, date, time, location, photo, description,category,host_id,latitude, longitude, image))
        db.commit()
        cursor.close()
        return jsonify({"message": "Event created successfully"}), 200


    except Exception as e:
       return jsonify({'error': f'Event not created: {str(e)}'}), 500
    
@app.route('/getUserEvents', methods=['GET'])
def get_user_events():
    user_id = request.args.get('userId')
   
    db=get_db_connection()

    try:
        with db.cursor() as cursor:
            # Execute SQL query to fetch events created by the user
            sql = "select title,date,time,location from events; WHERE host_id = %s"
            cursor.execute(sql, (user_id,))
            result = cursor.fetchall()
            return jsonify(result)
    except Exception as e:
        print(f"An error occurred: {e}")
        return jsonify({'error': 'An error occurred while fetching events'}), 500
    finally:
        db.close()

@app.route('/getCategoryEvents', methods=['GET'])
def get_category_events():
    category = request.args.get('category')
    connection = get_db_connection()

    try:
        with connection.cursor() as cursor:
            sql = "SELECT title, date, time, location FROM events WHERE category = %s"
            cursor.execute(sql, (category,))
            result = cursor.fetchall()
            return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        connection.close()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)