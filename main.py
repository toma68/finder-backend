from bson import json_util
from dotenv import load_dotenv
from flask import Flask, jsonify, request, send_from_directory
from flask_swagger_ui import get_swaggerui_blueprint
import json
import os
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

# Load .env file
load_dotenv()

# Accessing variables
mongodb_uri = os.getenv('MONGODB_URI')
print("MONGODB_URI: ", mongodb_uri)

app = Flask(__name__)

# Create a new client and connect to the server
client = MongoClient(mongodb_uri, server_api=ServerApi('1'))


# ---------- Swagger ---------- #
SWAGGER_URL = '/swagger'
API_URL = '/swagger.yaml'

swaggerui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,
    API_URL,
    config={  # Swagger UI config overrides
        'app_name': "Finder API"
    }
)

app.register_blueprint(swaggerui_blueprint, url_prefix=SWAGGER_URL)

@app.route('/swagger.yaml')
def swagger_yaml():
    return send_from_directory('.', 'swagger.yaml')

print("Swagger UI: http://<server>:<port>/swagger")


# ---------- Ping ---------- #
@app.route('/ping', methods=['GET'])
def get_data():
    try:
        client.admin.command('ping')
        return jsonify({'message': 'Connected to MongoDB!'}), 200
    except Exception as e:
        return jsonify({'error': e}), 500
    
    
# ---------- Users ---------- #
# Get all users
@app.route('/users', methods=['GET'])
def get_users():
    try:
        return json.dumps(list(client['finder']['users'].find()), default=json_util.default), 200
    except Exception as e:
        return jsonify({'error': e}), 500

# Check if a user exists and return it (login)
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
    
# Create a new user
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
    
# Get all users with their corresponding bars
@app.route('/users/bars', methods=['GET'])
def get_users_bars():
    try:
        if request.args is None or 'name' not in request.args:
            pipeline = [
                { "$lookup": {                     
                    "from": "bars",
                    "localField": "bar_id",
                    "foreignField": "_id",
                    "as": "bar"
                }}
            ]
            users = client['finder']['users'].aggregate(pipeline)
            return json.dumps(list(users), default=json_util.default), 200
        pipeline = [
            { "$match": {"name": request.args['name']} },  
            { "$lookup": {                      
                "from": "bars",
                "localField": "bar_id",
                "foreignField": "_id",
                "as": "bar"
            }}
        ]
        user = client['finder']['users'].aggregate(pipeline)
        if user is None:
            pipeline = [
                { "$lookup": {                      
                    "from": "bars",
                    "localField": "bar_id",
                    "foreignField": "_id",
                    "as": "bar"
                }}
            ]
            users = client['finder']['users'].aggregate(pipeline)
            return json.dumps(list(users), default=json_util.default), 200
        return json.dumps(list(user), default=json_util.default), 200
    except Exception as e:
        return jsonify({'error': e}), 500
    
    
# ---------- Bars ---------- #
# Get all bars
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
    
# Get all bars with their corresponding users
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
