# Mobile RF Application

The Mobile RF Application is a multi-platform solution designed to fetch, analyze, and store network-related data from mobile devices. The application leverages modern frameworks and technologies to provide seamless data collection and analysis, including FastAPI (Python), Java, Dart (Flutter), and MongoDB.

# Features

Fetches network data such as signal strength, network speed, and band information from mobile devices.
Persists RF test data in a MongoDB database for further analysis.
Provides a RESTful API using FastAPI for backend communication.
Mobile frontend developed in Flutter (Dart) for an intuitive user experience.
Uses Java for direct interaction with device hardware to extract detailed network information.

# Tech Stack
## Backend:
FastAPI (Python): Provides a fast and robust RESTful API.
Java: Reads and processes device information at the system level.

## Frontend:
Flutter (Dart): A cross-platform framework for building the mobile user interface.

## Database:
MongoDB: A NoSQL database for storing RF test data and metadata.

## Other Tools:
Docker for containerized deployment.
Git for version control.

# Getting Started

## Prerequisites
Node.js (for Flutter tools and dependencies)
Python 3.10+ (for FastAPI backend)
Java JDK 17+ (for device-level operations)
MongoDB 6.0+
Flutter SDK
Docker (optional, for containerized deployment)

## Installation

Clone the Repository:
git clone https://github.com/nazario94/mobile_rf.git
cd mobile-rf-application

## Set Up the Backend:

Navigate to the backend directory.
Create a virtual environment and install dependencies:
python -m venv venv
source venv/bin/activate   # On Windows: venv\Scripts\activate
pip install -r requirements.txt

## Run the FastAPI server:
uvicorn main:app --reload
Set Up the Java Module:
Navigate to the java-module directory.

## Build the Java application:
./gradlew build
Run the Java service:
java -jar build/libs/device-reader.jar

## Set Up the Frontend:
Navigate to the frontend directory.

## Install Flutter dependencies:
flutter pub get

## Run the application on a connected device:
flutter run

## Database Setup:
Ensure MongoDB is running locally or on a remote server.
Update the connection string in the backend configuration file:
mongodb_uri: "mongodb://localhost:27017/mobile_rf"

## API Endpoints

Base URL: http://localhost:8000
## GET /network-data:
Fetches the network data from the device.
## POST /network-data:
Stores fetched network data into MongoDB.
## GET /signal-strength:
Retrieves signal strength data.

