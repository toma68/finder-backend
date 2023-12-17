from flask import Flask, jsonify, request
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from bson import json_util
import json
from dotenv import load_dotenv
import os

# Load .env file
load_dotenv()

# Accessing variables
mongodb_uri = os.getenv('MONGODB_URI')
print(mongodb_uri)

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
    
# Databases
@app.route('/databases', methods=['GET'])
def get_dbs():
    try:
        return jsonify(client.list_database_names()), 200
    except Exception as e:
        return jsonify({'error': e}), 500
    
# Collections
@app.route('/collections/<db_name>', methods=['GET'])
def get_collections_by_db(db_name):
    try:
        return jsonify(client[db_name].list_collection_names()), 200
    except Exception as e:
        return jsonify({'error': e}), 500

# Documents
@app.route('/documents/<db_name>/<collection_name>', methods=['GET'])
def get_documents_by_collection(db_name, collection_name):
    try:
        return json.dumps(list(client[db_name][collection_name].find()), default=json_util.default), 200
    except Exception as e:
        return jsonify({'error': e}), 500

@app.route('/documents/<db_name>/<collection_name>', methods=['POST'])
def add_document(db_name, collection_name):
    try:
        if len(request.json) == 0 or type(request.json) != list:
            return jsonify({'message': 'Invalid request body!', 'example': [{'name': 'Kayla', 'surname': 'Ramos', 'company': 'Irwin-Long', 'bio': 'Almost goal speak his institution late magazine.', 'photo': 'https://placekitten.com/33/616', 'gender': 'm'}]}), 400
        client[db_name][collection_name].insert_many(request.json)
        return jsonify({'message': 'Document added successfully!'}), 200
    except Exception as e:
        return jsonify({'error': e}), 500

if __name__ == '__main__':
    app.run(debug=True)
