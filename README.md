# Biometrics Dashboard

A Flutter web application that visualizes biometric data from wearable devices and journaling to provide actionable insights into physical and mental well-being.

## Features

- **Interactive Charts**: Three synchronized time-series charts for HRV, RHR, and Steps
- **Shared Tooltips**: Hover or tap on one chart to highlight the same date across all charts
- **Range Controls**: Switch between 7d, 30d, and 90d views
- **Journal Annotations**: Vertical markers for journal entries with mood and notes
- **Performance Optimization**: Data decimation for smooth rendering with large datasets
- **Responsive Design**: Works on mobile and desktop with dark mode support
- **Error Handling**: Graceful loading, error, and empty states

## Setup

1. **Prerequisites**

   - Flutter SDK (3.9.2 or higher)
   - Dart SDK
   - Web browser for testing

2. **Installation**

   ```bash
   git clone <repository-url>
   cd biometrics_dashboard
   flutter pub get
   ```

3. **Run the application**

   ```bash
   # For web development
   flutter run -d web-server --web-port 8080

   # For mobile development
   flutter run
   ```

4. **Build for production**
   ```bash
   flutter build web --release
   ```

## Architecture

### Project Structure

```
lib/
├── config/          # Configuration files and constants
├── controller/      # State management and business logic
├── model/          # Data models and entities
├── services/       # API calls and external services
├── utils/          # Helper functions and utilities
└── views/          # UI screens and widgets
    └── widgets/    # Reusable UI components
```

### Key Components

- **DashboardController**: Manages app state using Provider pattern
- **DataService**: Handles data loading with simulated latency and failures
- **DecimationUtils**: Implements LTTB and bucket mean decimation algorithms
- **BaseChart**: Reusable chart widget with fl_chart
- **RangeSelector**: Date range switching controls

## Library Choices

- **fl_chart**: High-performance charting library with smooth animations
- **Provider**: Lightweight state management solution
- **json_annotation**: Code generation for JSON serialization
- **intl**: Internationalization and date formatting

## Performance Optimization

### Decimation Strategy

The app uses **Largest Triangle Three Buckets (LTTB)** algorithm for data decimation:

- **7d view**: ~50 points (7 points per day)
- **30d view**: ~100 points (3 points per day)
- **90d view**: ~200 points (2 points per day)

### Performance Metrics

- **Target**: <16ms per frame for smooth 60fps
- **Method**: LTTB decimation preserves min/max values and overall shape
- **Optimizations**:
  - Data decimation for large datasets
  - Efficient chart rendering with fl_chart
  - Lazy loading of chart data
  - Memory-efficient data structures

### Large Dataset Testing

Toggle the "Large Dataset" switch to test performance with 10,000+ data points. The app automatically applies decimation to maintain smooth performance.

## Data Format

### Biometrics Data

```json
{
  "date": "2025-07-24",
  "hrv": 58.2,
  "rhr": 61,
  "steps": 7421,
  "sleepScore": 78
}
```

### Journal Entries

```json
{
  "date": "2025-08-02",
  "mood": 2,
  "note": "Bad sleep"
}
```

## Testing

Run the test suite:

```bash
flutter test
```

### Test Coverage

- **Unit Tests**: Decimation algorithms, data processing
- **Widget Tests**: UI components, state management
- **Integration Tests**: End-to-end user flows

## Deployment

### Web Deployment

The app is configured for web deployment on:

- GitHub Pages
- Netlify
- Vercel
- Firebase Hosting

Build command:

```bash
flutter build web --release
```

### Environment Variables

Create a `.env` file in the root directory for configuration:

```
API_BASE_URL=https://api.example.com
DEBUG_MODE=false
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
