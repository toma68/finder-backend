# Finder

## Description
Finder is a mobile application built using SwiftUI and designed to provide users with a dynamic and interactive way to find and learn about nearby bars and view real-time occupancy. The app integrates MapKit for mapping functionalities and Core Location for user location tracking.

## Features

- **Map Integration**: Display nearby bars as custom annotations on a map.
- **User Location**: Track and display the user's current location on the map.
- **Bar Details**: View detailed information about each bar, including name, type, capacity, and real-time occupancy.
- **Distance Calculation**: Calculate the distance from the user's current location to a selected bar.
- **Dynamic UI**: Interactive UI with animations, including a rotating button for location updates.

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/toma68/finder-backend.git
   ```
2. Open the project in Xcode.
3. Configure the necessary API keys (e.g., for MongoDB Atlas).
3.1. MongoDB Atlas: Need log credentials (contact contributors). Then create a .env file in the root directory of the project and add the following line:
   ```
   MONGODB_URI=mongodb+srv://[username]:finder@[password].ae5z9az.mongodb.net/?retryWrites=true&w=majority
   ```
4. Build and run the application on a simulator or real device.

## App Views Overview

Finder consists of several key views, each designed to offer specific functionalities and enhance user experience:

### Profile View
- **Description**: This view allows users to manage their personal profile.
- **Features**:
    - Users can log in, log out, and sign up for an account.
    - Displays user information, such as name, bio, and profile picture.
    - Users can view and edit their personal information.
- **Login, Signup, and Profile Screenshots**:

<img src="https://raw.githubusercontent.com/toma68/finder-backend/main/Pictures/Login.png" alt="Login" height="500"/>
<img src="https://raw.githubusercontent.com/toma68/finder-backend/main/Pictures/Signup.png" alt="Signup" height="500"/>
<img src="https://raw.githubusercontent.com/toma68/finder-backend/main/Pictures/Profile.png" alt="Profile" height="500"/>

### Bars View

- **Description**: Dedicated to showcasing all different bars.
- **Features**:
    - Lists bars with details such as name, type, location, and real-time occupancy.
    - Users can select a bar to view more detailed information and real-time occupancy.
    - Real-time opening hours updates.
    - Features filters and search functionality to refine the list of bars.
    - See users who are currently in selected bar.
- **Bars and Bar Screenshots**:

<img src="https://raw.githubusercontent.com/toma68/finder-backend/main/Pictures/Bars.png" alt="Bars" height="500"/>
<img src="https://raw.githubusercontent.com/toma68/finder-backend/main/Pictures/Bar.png" alt="Bar" height="500"/>

### Map View

- **Description**: Integrates MapKit to display a map with bar locations and user's current location.
- **Features**:
    - Interactive map showing the user's current location and nearby bars as markers.
    - Tapping a marker reveals a brief overview of the bar.
    - Real-time updates to user location and bar markers.
    - Real-time opening hours updates.
    - Real-time occupancy updates.
    - Real-time distance calculation between user and selected bar.
- **Map Screenshots**:

<img src="https://raw.githubusercontent.com/toma68/finder-backend/main/Pictures/MarkersMapCentered.png" alt="Map centered on markers" height="500"/>
<img src="https://raw.githubusercontent.com/toma68/finder-backend/main/Pictures/UserLocationMapCentered.png" alt="Map centered on user's current location" height="500"/>
<img src="https://raw.githubusercontent.com/toma68/finder-backend/main/Pictures/MapBarOpenUserNotLogged.png" alt="Selected opened bar without user logged in" height="500"/>
<img src="https://raw.githubusercontent.com/toma68/finder-backend/main/Pictures/MapBarOpen.png" alt="Selected opened bar with a user logged in" height="500"/>
<img src="https://raw.githubusercontent.com/toma68/finder-backend/main/Pictures/MapBarClose.png" alt="Selected closed bar with a user logged in" height="500"/>


### Users View

- **Description**: Focuses on the social aspect of the app, allowing users to see each other's profiles.
- **Features**:
    - View profiles of other users with their personal information.
    - Search for other users by name, surname, or gender.
    - For each user, see bar they are currently in with real-time occupancy.
- **Users and User Screenshots**:

<img src="https://raw.githubusercontent.com/toma68/finder-backend/main/Pictures/Users.png" alt="Users" height="500"/>
<img src="https://raw.githubusercontent.com/toma68/finder-backend/main/Pictures/User.png" alt="User" height="500"/>

## API Documentation

The Finder API provides various endpoints for managing users and bars, as well as retrieving and updating information related to users and bars. Below is the Swagger 2.0 specification for the API.

### Base URL
- **Host**: `localhost:5000`
- **Base Path**: `/`
- **Schemes**: `http`
- **Swagger**: `http://localhost:5000/swagger`

### Endpoints

#### `/ping` - Check MongoDB connection
- **Method**: GET
- **Summary**: Pings the MongoDB server to check connectivity.
- **Responses**:
  - `200`: Successfully connected to MongoDB.
  - `500`: Error occurred.

#### `/users` - Get all users
- **Method**: GET
- **Summary**: Retrieves a list of all users or a specific user by providing a user ID.
- **Parameters**:
  - `user_id`: (optional) The user's ID.
- **Responses**:
  - `200`: A list of users or a specific user if user_id is provided.
  - `400`: Invalid user_id format.
  - `404`: User not found.
  - `500`: Error occurred.

#### `/users/login` - User login
- **Method**: POST
- **Summary**: Checks if a user exists based on name and surname.
- **Parameters**:
  - `user`: User object with name and surname.
- **Responses**:
  - `200`: User found and returned.
  - `401`: User not found.
  - `500`: Error occurred.

#### `/users/signup` - User signup
- **Method**: POST
- **Summary**: Creates a new user.
- **Parameters**:
  - `user`: User object with required details.
- **Responses**:
  - `200`: User created successfully.
  - `400`: Invalid request body.
  - `409`: User already exists.
  - `500`: Error occurred.

#### `/users/update` - Update a user
- **Method**: PUT
- **Summary**: Updates an existing user's details.
- **Parameters**:
  - `user`: User update object.
- **Responses**:
  - `200`: User updated successfully.
  - `400`: Invalid request body.
  - `404`: User not found.
  - `409`: Another user with the same name and surname exists.
  - `500`: Error occurred.

#### `/users/update-bar` - Update a user's bar
- **Method**: POST
- **Summary**: Updates a user's associated bar.
- **Parameters**:
  - `userBar`: User bar update object.
- **Responses**:
  - `200`: User bar updated successfully.
  - `400`: Invalid request body or user ID.
  - `404`: User not found.
  - `500`: Error occurred.

#### `/bars` - Get all bars
- **Method**: GET
- **Summary**: Retrieves a list of all bars or a specific bar by providing a bar ID.
- **Parameters**:
  - `_id`: (optional) The bar's ID.
- **Responses**:
  - `200`: A list of bars or a specific bar if _id is provided.
  - `400`: Invalid _id format.
  - `500`: Error occurred.

#### `/bars/users` - Get all bars with their corresponding users
- **Method**: GET
- **Summary**: Retrieves all bars and the users in them, if any.
- **Parameters**:
  - `_id`: (optional) The bar's ID to filter.
- **Responses**:
  - `200`: A list of bars with their corresponding users.
  - `404`: Bar not found.
  - `500`: Error occurred.

### Data Models

#### `User`
- **Type**: object
- **Properties**:
  - `name`: string
  - `surname`: string
  - `company`: string
  - `bio`: string
  - `photo`: string
  - `gender`: string
  - `bar_id`: string

#### `UserLogin`
- **Type**: object
- **Properties**:
  - `name`: string
  - `surname`: string

#### `UserUpdate`
- **Type**: object
- **Properties**:
  - `user_id`: string
  - `name`: string
  - `surname`: string
  - `company`: string
  - `bio`: string
  - `photo`: string
  - `gender`: string
  - `bar_id`: string

#### `UserBarUpdate`
- **Type**: object
- **Properties**:
  - `user_id`: string
  - `new_bar_id`: string

#### `Bar`
- **Type**: object
- **Properties**:
  - `name`: string
  - `longitude`: string
  - `latitude`: string
  - `capacity`: string
  - `type`: string
  - `description`: string

## Contributors

- [@mcrayssac](API and SwiftUI)
- [@toma68](SwiftUI and API)