# Price Tracker

A real-time Flutter application that tracks and displays the current price of Bitcoin (BTC).

## Getting Started

This project demonstrates a simple Flutter app that connects to a WebSocket to fetch Bitcoin price updates from Binance. It features a retry mechanism in case of connection errors.

### Features

- Real-time Bitcoin price tracking
- Retry connection if the WebSocket fails
- User-friendly interface with clear error messages

### Getting Started

To get started with this project:

**Clone the repository:**

   git clone https://github.com/manthmn/trip_planner.git

   Navigate to the project directory:
   cd price_tracker
    
   Install dependencies:
   flutter pub get
    
   Run the app:
   flutter run

Resources
  For more information on Flutter and WebSocket integration, you can refer to:
  
  Flutter Documentation
  Binance WebSocket API Documentation
  Troubleshooting
  Connection Errors: If the app encounters issues connecting to the WebSocket, tap the "Retry" button to re-establish the connection.
  Data Parsing Errors: Ensure that the WebSocket URL is correct and that the data format received from Binance matches the expected format.
