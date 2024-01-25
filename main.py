from bson import json_util, ObjectId
from dotenv import load_dotenv
from flask import Flask, jsonify, request, send_from_directory
from flask_swagger_ui import get_swaggerui_blueprint
import json
import os
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from urllib.parse import urlparse

# Load .env file
load_dotenv()

# Accessing variables
mongodb_uri = os.getenv('MONGODB_URI')
print("MONGODB_URI: ", mongodb_uri)
if mongodb_uri is None:
    raise Exception("MONGODB_URI environment variable not found!")

app = Flask(__name__)

# Create a new client and connect to the server
# !!! IMPORTANT !!!
# tls and tlsAllowInvalidCertificates are used due to certificate issues on macOS
client = MongoClient(mongodb_uri, server_api=ServerApi('1'), tls=True, tlsAllowInvalidCertificates=True)


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
        return jsonify({'error': str(e)}), 500
    
    
# ---------- Users ---------- #
# Get all users
@app.route('/users', methods=['GET'])
def get_users():
    try:
        user_id = request.args.get('user_id')
        if not user_id:
            return json.dumps(list(client['finder']['users'].find()), default=json_util.default), 200
        try:
            oid = ObjectId(user_id)
        except:
            return jsonify({'error': 'Invalid user_id format'}), 400
        users_collection = client['finder']['users']
        user = users_collection.find_one({'_id': oid})
        if not user:
            return jsonify({'message': 'User not found'}), 404
        return json.dumps(user, default=json_util.default), 200
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
            return jsonify({'message': 'User not found!'}), 401
        return json.dumps(user, default=json_util.default), 200
    except Exception as e:
        return jsonify({'error': e}), 500
    
# Create a new user
@app.route('/users/signup', methods=['POST'])
def signup():
    try:
        required_fields = ['name', 'surname', 'company', 'bio', 'photo', 'gender']
        if not request.json or any(field not in request.json or not request.json[field].strip() for field in required_fields):
            print("All fields are required and cannot be empty!")
            return jsonify({'message': 'All fields are required and cannot be empty!'}), 400
        if request.json['gender'] not in ['m', 'w', 'n']:
            return jsonify({'message': 'Gender must be "m", "w", or "n"'}), 400
        try:
            result = urlparse(request.json['photo'])
            if not all([result.scheme, result.netloc]):
                raise ValueError
        except:
            return jsonify({'message': 'Invalid photo URL'}), 400
        user = client['finder']['users'].find_one({'name': request.json['name'], 'surname': request.json['surname']})
        if user is not None:
            return jsonify({'message': 'User already exists!'}), 409
        client['finder']['users'].insert_one(request.json)
        user = client['finder']['users'].find_one({'name': request.json['name'], 'surname': request.json['surname']})
        return json.dumps(user, default=json_util.default), 200
    except Exception as e:
        print("Error: ", e)
        return jsonify({'error': str(e)}), 500
    
# Update a user
@app.route('/users/update', methods=['PUT'])
def update_user():
    try:
        user_data = request.json
        print("user_data: ", user_data)
        if not user_data or 'user_id' not in user_data or 'name' not in user_data or 'surname' not in user_data:
            print("User ID, name, and surname are required")
            return jsonify({'message': 'User ID, name, and surname are required'}), 400

        user_id = user_data.pop('user_id')

        # Convert user_id to ObjectId
        try:
            oid = ObjectId(user_id)
        except:
            print("Invalid user_id format: ", user_id)
            return jsonify({'error': 'Invalid user_id format'}), 400

        users_collection = client['finder']['users']

        # Check if another user with the same name and surname exists
        existing_user = users_collection.find_one({'name': user_data['name'],'surname': user_data['surname']})
        if existing_user:
            return jsonify({'message': 'Another user with the same name and surname already exists'}), 409

        update_result = users_collection.update_one({'_id': oid}, {'$set': user_data})

        if update_result.matched_count == 0:
            return jsonify({'message': 'User not found'}), 404
        if update_result.modified_count == 0:
            return jsonify({'message': 'No update made'}), 200

        updated_user = users_collection.find_one({'_id': oid})
        if updated_user:
            # updated_user['_id'] = str(updated_user['_id'])  # Convert ObjectId to string for JSON serialization
            return json.dumps(updated_user, default=json_util.default), 200

        return jsonify({'message': 'User updated, but unable to fetch updated data'}), 500

    except Exception as e:
        print("Error: ", e)
        return jsonify({'error': str(e)}), 500
    
# Update a user's bar
@app.route('/users/update-bar', methods=['POST'])
def update_user_bar():
    try:
        data = request.json
        if not data or 'user_id' not in data:
            return jsonify({'error': 'User ID is required'}), 400
        try:
            user_id = ObjectId(data['user_id'])
        except:
            return jsonify({'error': 'Invalid user_id format'}), 400
        new_bar_id = data.get('new_bar_id')
        if new_bar_id is not None:
            try:
                new_bar_id = ObjectId(new_bar_id)
            except:
                return jsonify({'error': 'Invalid new_bar_id format'}), 400
        else:
            new_bar_id = None
        users_collection = client['finder']['users']
        print("new_bar_id: ", new_bar_id)
        update_result = users_collection.update_one({'_id': user_id}, {'$set': {'bar_id': new_bar_id}})
        if update_result.matched_count == 0:
            return jsonify({'error': 'User not found'}), 404
        return jsonify({'message': 'User bar updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
    
# ---------- Bars ---------- #
# Get all bars
@app.route('/bars', methods=['GET'])
def get_bars():
    try:
        if request.args is None or '_id' not in request.args:
            return json.dumps(list(client['finder']['bars'].find()), default=json_util.default), 200
        bar_id = request.args['_id']
        try:
            oid = ObjectId(bar_id)
        except:
            return jsonify({'error': 'Invalid _id format'}), 400
        bar = client['finder']['bars'].find_one({'_id': oid})
        if bar is None:
            return json.dumps(list(client['finder']['bars'].find()), default=json_util.default), 200
        return json.dumps(bar, default=json_util.default), 200
    except Exception as e:
        return jsonify({'error': e}), 500
    
# Get all bars with their corresponding users
@app.route('/bars/users', methods=['GET'])
def get_bars_users():
    try:
        pipeline = [
            {
                "$lookup": {                     
                    "from": "users",
                    "localField": "_id",
                    "foreignField": "bar_id",
                    "as": "users_in_bar"
                }
            }
        ]
        if request.args.get('_id'):
            try:
                bar_id = ObjectId(request.args['_id'])
                pipeline.insert(0, {"$match": {"_id": bar_id}})
            except:
                return jsonify({'error': 'Invalid _id format'}), 400
        result = client['finder']['bars'].aggregate(pipeline)
        result_list = list(result)
        if request.args.get('_id'):
            if len(result_list) > 0:
                return json.dumps(result_list[0], default=json_util.default), 200
            else:
                return jsonify({'message': 'Bar not found'}), 404
        return json.dumps(result_list, default=json_util.default), 200
    except Exception as e:
        print("Error: ", e)
        return jsonify({'error': str(e)}), 500
    

if __name__ == '__main__':
    app.run(debug=True)
