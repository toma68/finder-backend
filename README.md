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

### Bars View

- **Description**: Dedicated to showcasing all different bars.
- **Features**:
    - Lists bars with details such as name, type, location, and real-time occupancy.
    - Users can select a bar to view more detailed information and real-time occupancy.
    - Real-time opening hours updates.
    - Features filters and search functionality to refine the list of bars.
    - See users who are currently in selected bar.

### Map View

- **Description**: Integrates MapKit to display a map with bar locations and user's current location.
- **Features**:
    - Interactive map showing the user's current location and nearby bars as markers.
    - Tapping a marker reveals a brief overview of the bar.
    - Real-time updates to user location and bar markers.
    - Real-time opening hours updates.
    - Real-time occupancy updates.
    - Real-time distance calculation between user and selected bar.

### Users View

- **Description**: Focuses on the social aspect of the app, allowing users to see each other's profiles.
- **Features**:
    - View profiles of other users with their personal information.
    - Search for other users by name, surname, or gender.
    - For each user, see bar they are currently in with real-time occupancy.

## Contributors

- [@mcrayssac](API and SwiftUI)
- [@toma68](SwiftUI and API)