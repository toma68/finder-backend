from flask import Flask, jsonify, request
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from bson import json_util
import json
from dotenv import load_dotenv
import os
import random

# Load .env file
load_dotenv()

# Accessing variables
mongodb_uri = os.getenv('MONGODB_URI')
print("MONGODB_URI: ", mongodb_uri)

app = Flask(__name__)

# Create a new client and connect to the server
client = MongoClient(mongodb_uri, server_api=ServerApi('1'))

# Ping
@app.route('/ping', methods=['GET'])
def get_data():
    try:
        client.admin.command('ping')
        return jsonify({'message': 'Connected to MongoDB!'}), 200
    except Exception as e:
        return jsonify({'error': e}), 500
    
# Users routes
@app.route('/users', methods=['GET'])
def get_users():
    try:
        return json.dumps(list(client['finder']['users'].find()), default=json_util.default), 200
    except Exception as e:
        return jsonify({'error': e}), 500
    
@app.route('/users/login', methods=['POST'])
def login():
    try:
        if request.json is None or 'name' not in request.json or 'surname' not in request.json:
            return jsonify({'message': 'Invalid request body!'}), 400
        user = client['finder']['users'].find_one({'name': request.json['name'], 'surname': request.json['surname']})
        if user is None:
            return jsonify({'message': 'User not found!'}), 404
        return json.dumps(user, default=json_util.default), 200
    except Exception as e:
        return jsonify({'error': e}), 500
    
@app.route('/users/signup', methods=['POST'])
def signup():
    try:
        if request.json is None or 'name' not in request.json or 'surname' not in request.json or 'company' not in request.json or 'bio' not in request.json or 'photo' not in request.json or 'gender' not in request.json:
            return jsonify({'message': 'Invalid request body!'}), 400
        user = client['finder']['users'].find_one({'name': request.json['name'], 'surname': request.json['surname']})
        if user is not None:
            return jsonify({'message': 'User already exists!'}), 409
        client['finder']['users'].insert_one(request.json)
        user = client['finder']['users'].find_one({'name': request.json['name'], 'surname': request.json['surname']})
        return json.dumps(user, default=json_util.default), 200
    except Exception as e:
        return jsonify({'error': e}), 500
    
# Bars routes
@app.route('/bars', methods=['GET'])
def get_bars():
    try:
        if request.args is None or 'name' not in request.args:
            return json.dumps(list(client['finder']['bars'].find()), default=json_util.default), 200
        bar = client['finder']['bars'].find_one({'name': request.args['name']})
        if bar is None:
            return json.dumps(list(client['finder']['bars'].find()), default=json_util.default), 200
        return json.dumps(bar, default=json_util.default), 200
    except Exception as e:
        return jsonify({'error': e}), 500
    
@app.route('/bars/users', methods=['GET'])
def get_bars_users():
    try:
        if request.args is None or 'name' not in request.args:
            pipeline = [
                { "$lookup": {                     
                    "from": "users",
                    "localField": "_id",
                    "foreignField": "bar_id",
                    "as": "users_in_bar"
                }}
            ]
            bars = client['finder']['bars'].aggregate(pipeline)
            return json.dumps(list(bars), default=json_util.default), 200

        pipeline = [
            { "$match": {"name": request.args['name']} },  
            { "$lookup": {                      
                "from": "users",
                "localField": "_id",
                "foreignField": "bar_id",
                "as": "users_in_bar"
            }}
        ]
        bar = client['finder']['bars'].aggregate(pipeline)

        if bar is None:

            pipeline = [
                { "$lookup": {                      
                    "from": "users",
                    "localField": "_id",
                    "foreignField": "bar_id",
                    "as": "users_in_bar"
                }}
            ]
            bars = client['finder']['bars'].aggregate(pipeline)
            return json.dumps(list(bars), default=json_util.default), 200
        
        return json.dumps(list(bar), default=json_util.default), 200
    except Exception as e:
        return jsonify({'error': e}), 500

if __name__ == '__main__':
    app.run(debug=True)
