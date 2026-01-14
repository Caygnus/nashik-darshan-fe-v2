# Clean Architecture Folder Structure

This document describes the folder structure and naming conventions used in the Nashik Darshan app, following Clean Architecture principles.

## Root Structure

```
lib/
├── main.dart                    # App entry point
├── android_app.dart             # Android-specific app configuration
├── ios_app.dart                 # iOS-specific app configuration
├── core/                        # Shared/core functionality
│   ├── auth/                    # Authentication services
│   ├── deep_link/               # Deep linking services
│   ├── di/                      # Dependency injection (GetIt)
│   ├── dio/                     # HTTP client configuration
│   ├── domain/                  # Core domain abstractions
│   │   ├── repositories/        # Base repository interfaces
│   │   └── use_cases/           # Base use case classes
│   ├── env/                     # Environment configuration
│   ├── error/                   # Error handling
│   │   ├── exceptions/         # Exception classes
│   │   └── failures/           # Failure classes
│   ├── presentation/            # Shared presentation components
│   │   ├── pages/              # Shared pages (e.g., bottom bar)
│   │   └── widgets/            # Shared/reusable widgets
│   ├── router/                  # Navigation/routing
│   ├── supabase/                # Supabase configuration
│   ├── theme/                   # App theming
│   └── utils/                   # Utility functions
└── features/                    # Feature modules
    └── {feature_name}/          # Individual feature
        ├── data/                # Data layer
        │   ├── datasources/    # Data sources (remote/local)
        │   ├── models/         # Data models (JSON serializable)
        │   └── repositories/   # Repository implementations
        ├── domain/              # Domain layer
        │   ├── dtos/           # Data Transfer Objects
        │   ├── entities/       # Business entities
        │   ├── repositories/   # Repository interfaces
        │   └── use_cases/      # Use cases (business logic)
        └── presentation/        # Presentation layer
            ├── cubit/          # State management (Cubit/Bloc)
            ├── pages/          # UI screens
            └── widgets/        # Feature-specific widgets
```

## Naming Conventions

### Files

- **Entities**: `user.dart`, `product.dart` (lowercase, singular)
- **Models**: `user_model.dart`, `product_model.dart` (lowercase, `_model` suffix)
- **DTOs**: `create_user_request.dart`, `update_user_request.dart` (lowercase, `_request`/`_response` suffix)
- **Repositories**: 
  - Interface: `user_repository.dart`
  - Implementation: `user_repository_impl.dart`
- **Data Sources**:
  - Interface: `user_remote_datasource.dart`
  - Implementation: `user_remote_datasource_impl.dart`
- **Use Cases**: `get_user.dart`, `create_user.dart` (lowercase, verb + noun)
- **Cubits**: `user_cubit.dart`, `auth_cubit.dart` (lowercase, `_cubit` suffix)
- **States**: `user_state.dart`, `auth_state.dart` (lowercase, `_state` suffix)
- **Pages**: `user_page.dart`, `users_page.dart` (lowercase, `_page` or `_screen` suffix)
- **Widgets**: `user_card.dart` or `user_card_widget.dart` (lowercase, descriptive name)

### Classes

- **Entities**: `User`, `Product` (PascalCase, singular, use Freezed)
- **Models**: `UserModel`, `ProductModel` (PascalCase, `Model` suffix, use Freezed)
- **DTOs**: `CreateUserRequest`, `UpdateUserRequest` (PascalCase, descriptive, use Freezed)
- **Repositories**: 
  - Interface: `UserRepository`
  - Implementation: `UserRepositoryImpl`
- **Data Sources**:
  - Interface: `UserRemoteDataSource`
  - Implementation: `UserRemoteDataSourceImpl`
- **Use Cases**: `GetUser`, `CreateUser` (PascalCase, verb + noun)
- **Cubits**: `UserCubit`, `AuthCubit` (PascalCase, `Cubit` suffix)
- **States**: `UserState`, `AuthState` (PascalCase, `State` suffix, use Freezed)
- **Pages**: `UserPage`, `UsersPage` (PascalCase, `Page` or `Screen` suffix)
- **Widgets**: `UserCard`, `UserCardWidget` (PascalCase, descriptive)

### Folders

- Use **lowercase** with **underscores**: `use_cases`, `data_sources`
- Feature names: `auth`, `home`, `profile` (lowercase, singular)
- Layer names: `domain`, `data`, `presentation` (lowercase)

## Layer Responsibilities

### Domain Layer (`domain/`)

- **Entities**: Pure business objects (no dependencies on data/presentation)
- **DTOs**: Request/Response objects for use cases
- **Repositories**: Abstract interfaces (contracts)
- **Use Cases**: Business logic operations

**Rules:**
- ✅ No dependencies on `data/` or `presentation/`
- ✅ Use Freezed for entities and DTOs
- ✅ All use cases implement `UseCase<Type, Params>` or `UseCaseNoParams<Type>`
- ✅ Return `Result<T>` (Either<Failure, T>)

### Data Layer (`data/`)

- **Models**: JSON serializable data representations
- **Data Sources**: API calls, local storage
- **Repositories**: Implementations of domain repository interfaces

**Rules:**
- ✅ Models extend/implement entities
- ✅ Data sources throw exceptions (not failures)
- ✅ Repository implementations convert exceptions to failures
- ✅ Use `executeWithErrorHandling` in repositories

### Presentation Layer (`presentation/`)

- **Cubits**: State management (only for shared state)
- **Pages**: UI screens
- **Widgets**: Feature-specific UI components

**Rules:**
- ✅ Use Cubit only for globally shared state
- ✅ Use local state (StatefulWidget) for simple, page-specific state
- ✅ Use Freezed for Cubit states
- ✅ Handle `Result<T>` using `fold`

## Shared Components

### Core Widgets (`core/presentation/widgets/`)

Shared/reusable widgets used across multiple features:
- `app_text.dart` - Text widget with consistent styling
- `category_selection_widget.dart` - Category selection UI
- `filter_buttons_widget.dart` - Filter buttons
- `hotel_card_widget.dart` - Hotel card display
- `listing_card_widget.dart` - Generic listing card
- `search_bar_widget.dart` - Search bar component
- etc.

### Core Pages (`core/presentation/pages/`)

Shared pages used across the app:
- `bottom_bar_page.dart` - Bottom navigation bar
- `deep_link_test_page.dart` - Deep link testing page

## Feature Structure Example

```
features/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   └── auth_supabase_datasource.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── signup_request_model.dart
│   │   └── signup_response_model.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── dtos/
│   │   ├── signup_request.dart
│   │   └── signup_response.dart
│   ├── entities/
│   │   └── user.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── use_cases/
│       ├── get_current_user.dart
│       ├── signin_with_email.dart
│       └── signup_with_email.dart
└── presentation/
    ├── cubit/
    │   ├── auth_cubit.dart
    │   └── auth_state.dart
    ├── pages/
    │   ├── login_page.dart
    │   ├── signup_page.dart
    │   └── splash_screen.dart
    └── widgets/
        └── (feature-specific widgets)
```

## Import Paths

### Core Imports

```dart
// Core domain
import 'package:nashik/core/domain/repositories/base_repository.dart';
import 'package:nashik/core/domain/use_cases/base_usecase.dart';

// Core utilities
import 'package:nashik/core/utils/result.dart';

// Core presentation
import 'package:nashik/core/presentation/widgets/app_text.dart';
import 'package:nashik/core/presentation/pages/bottom_bar_page.dart';
```

### Feature Imports

```dart
// Domain layer
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';
import 'package:nashik/features/auth/domain/use_cases/get_current_user.dart';

// Data layer
import 'package:nashik/features/auth/data/models/user_model.dart';
import 'package:nashik/features/auth/data/repositories/auth_repository_impl.dart';

// Presentation layer
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nashik/features/auth/presentation/pages/login_page.dart';
```

## Best Practices

1. **Feature Independence**: Each feature should be independent and self-contained
2. **Shared Code**: Put shared code in `core/`, feature-specific code in `features/`
3. **Naming Consistency**: Follow the naming conventions strictly
4. **Layer Separation**: Never import from outer layers to inner layers
5. **Dependency Direction**: Domain ← Data ← Presentation

## Migration Notes

- ✅ `widgets/` → `core/presentation/widgets/`
- ✅ `core/pages/` → `core/presentation/pages/`
- ✅ `domain/usecases/` → `domain/use_cases/`
- ✅ All imports updated to reflect new structure
