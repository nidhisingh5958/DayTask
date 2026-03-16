# Testing

## Current Test Coverage

- `test/task_model_test.dart`
  - Verifies `TaskModel` serialization/deserialization (`toMap` <-> `fromMap`)
- `test/widget_test.dart`
  - Baseline harness test

## Run Tests

```bash
flutter test
```

## Static Analysis

```bash
flutter analyze
```

## Recommended Next Tests

- Auth service unit tests with mocked Supabase client
- Task controller tests for loading/error states
- Widget tests for login validation and dashboard interactions
