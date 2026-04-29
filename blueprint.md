
# Project Blueprint

## Overview

This project is a minimal, functional Flutter application that demonstrates a clean architecture approach using the MVVM (Model-View-ViewModel) pattern. It is designed to be a reusable template for any new Minimum Viable Product (MVP), providing a solid foundation with a clear separation of concerns.

## Architecture and Design

The application follows the principles of Clean Architecture, which separates the code into distinct layers:

- **Domain Layer**: Contains the core business logic of the application. It is independent of any other layer.
  - `lib/domain/entities`: Defines the business objects (e.g., `RandomNumber`).
  - `lib/domain/repositories`: Defines the abstract contracts for data sources.
  - `lib/domain/usecases`: Contains the application-specific business rules.

- **Data Layer**: Implements the repositories defined in the domain layer and is responsible for fetching data from various sources (e.g., network, local database).
  - `lib/data/datasources`: Provides the actual implementation for fetching data.
  - `lib/data/repositories_impl`: Implements the repository contracts from the domain layer.

- **Presentation Layer**: Responsible for the UI and user interaction. It uses the MVVM pattern to separate the UI from its logic.
  - `lib/presentation/view`: Contains the Flutter widgets that make up the UI (the "View").
  - `lib/presentation/viewmodel`: Contains the ViewModels, which hold the UI state and business logic to be consumed by the Views.

### State Management

The project uses the `provider` package for state management, which allows for a clean separation between the UI and the business logic.

## Current Implementation

The current version of the application has the following features:

- A single screen that displays a random number.
- A button to fetch a new random number.
- A loading indicator that is shown while the number is being fetched.
- A clear folder structure based on Clean Architecture and MVVM.

## Plan for Current Request

**Request:** Create a minimal, functional Flutter example following MVVM + Clean Architecture + SOLID.

**Completed Steps:**

1.  **Set up Directory Structure**: Created the necessary folders for the domain, data, and presentation layers.
2.  **Domain Layer**:
    - Defined the `RandomNumber` entity.
    - Created the `RandomNumberRepository` abstract class.
    - Implemented the `GetRandomNumberUseCase`.
3.  **Data Layer**:
    - Created a `RandomNumberRemoteDataSource` to simulate a network request.
    - Implemented the `RandomNumberRepositoryImpl`.
4.  **Presentation Layer**:
    - Created a `RandomNumberViewModel` to manage the state of the UI.
    - Built the `RandomNumberScreen` and `RandomNumberView` to display the UI.
5.  **Dependency Management**: Added the `provider` package to `pubspec.yaml`.
6.  **Application Entry Point**: Updated `lib/main.dart` to run the example application.
7.  **Documentation**: Created this `blueprint.md` file to document the project.
