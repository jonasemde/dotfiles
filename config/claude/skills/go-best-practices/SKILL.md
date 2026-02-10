---
name: go-best-practices
description: Industry standards for writing modern, scalable, clean, type-safe, and thread-safe Go applications. Covers project structure, concurrency patterns, error handling, testing, and production-ready code.
license: MIT
metadata:
   author: Jonas Emde
   tags: go, golang, best practices, concurrency, clean code, type safety, thread safety
---

## Core Go Principles

**Embrace Go idioms.** Write simple, readable code that follows Go conventions. Clarity over cleverness. Errors are values. Concurrency is not parallelism.

## Project Structure

### Standard Layout
Follow the [golang-standards/project-layout](https://github.com/golang-standards/project-layout):

```
/cmd           - Main applications (cmd/myapp/main.go)
/internal      - Private application code (not importable)
/pkg           - Public library code (importable by external projects)
/api           - API definitions (OpenAPI/Swagger, protobuf)
/web           - Web assets (templates, static files)
/configs       - Configuration files
/scripts       - Build, install, analysis scripts
/test          - Additional test data and fixtures
/docs          - Design and user documents
/tools         - Supporting tools for this project
/vendor        - Application dependencies (via go mod vendor)
```

### Package Organization
- **One package per directory** - all files in a directory must have the same package name
- **Package names**: short, lowercase, no underscores or mixedCaps (e.g., `httputil`, not `http_util`)
- **Avoid generic names**: `util`, `common`, `base` - use descriptive names
- **Internal packages**: use `/internal` for code that shouldn't be imported by other projects

```go
// Good structure
myapp/
  cmd/myapp/main.go           // package main
  internal/user/              // package user
    repository.go
    service.go
  internal/order/             // package order
    repository.go
    service.go
  pkg/validator/              // package validator (public)
    email.go
```

## Type Safety

### Use Strong Types
Avoid primitive obsession. Create domain-specific types:

```go
// Bad - primitive obsession
func ProcessOrder(userID int64, amount float64, currency string) error

// Good - strong types
type UserID int64
type Money struct {
    Amount   decimal.Decimal
    Currency Currency
}

func ProcessOrder(userID UserID, amount Money) error
```

### Leverage the Type System
```go
// Use type aliases for clarity
type OrderID string
type ProductID string

// Use structs to prevent invalid states
type Order struct {
    ID        OrderID
    Status    OrderStatus  // Use enums via const + custom type
    CreatedAt time.Time
}

// Use iota for enums
type OrderStatus int

const (
    OrderStatusPending OrderStatus = iota
    OrderStatusProcessing
    OrderStatusCompleted
    OrderStatusCancelled
)

func (s OrderStatus) String() string {
    return [...]string{"pending", "processing", "completed", "cancelled"}[s]
}
```

### Generics (Go 1.18+)
Use generics for type-safe data structures and algorithms:

```go
// Generic stack
type Stack[T any] struct {
    items []T
}

func (s *Stack[T]) Push(item T) {
    s.items = append(s.items, item)
}

func (s *Stack[T]) Pop() (T, bool) {
    if len(s.items) == 0 {
        var zero T
        return zero, false
    }
    item := s.items[len(s.items)-1]
    s.items = s.items[:len(s.items)-1]
    return item, true
}

// Generic constraints
type Number interface {
    ~int | ~int64 | ~float64
}

func Sum[T Number](nums []T) T {
    var total T
    for _, n := range nums {
        total += n
    }
    return total
}
```

## Thread Safety & Concurrency

### Goroutines & Channels
**Prefer channels over shared memory**. Use goroutines liberally but responsibly.

```go
// Good - channel-based communication
func ProcessItems(items []Item) []Result {
    results := make(chan Result, len(items))
    var wg sync.WaitGroup

    for _, item := range items {
        wg.Add(1)
        go func(i Item) {
            defer wg.Done()
            results <- ProcessItem(i)
        }(item)
    }

    go func() {
        wg.Wait()
        close(results)
    }()

    var output []Result
    for result := range results {
        output = append(output, result)
    }
    return output
}
```

### Synchronization Primitives

#### Mutexes
Use `sync.Mutex` for protecting shared state:

```go
type SafeCounter struct {
    mu    sync.RWMutex
    count map[string]int
}

func (c *SafeCounter) Inc(key string) {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.count[key]++
}

func (c *SafeCounter) Value(key string) int {
    c.mu.RLock()  // Read lock allows concurrent reads
    defer c.mu.RUnlock()
    return c.count[key]
}
```

#### Atomic Operations
Use `sync/atomic` for simple counters and flags:

```go
type Server struct {
    requestCount atomic.Int64
    isShutdown   atomic.Bool
}

func (s *Server) HandleRequest() {
    if s.isShutdown.Load() {
        return
    }
    s.requestCount.Add(1)
    // ... handle request
}

func (s *Server) Shutdown() {
    s.isShutdown.Store(true)
}
```

#### sync.Once
Ensure one-time initialization:

```go
var (
    instance *Database
    once     sync.Once
)

func GetDatabase() *Database {
    once.Do(func() {
        instance = &Database{
            // expensive initialization
        }
    })
    return instance
}
```

### Context for Cancellation
**Always pass context.Context as the first parameter**:

```go
// Good - context-aware
func FetchUser(ctx context.Context, id UserID) (*User, error) {
    select {
    case <-ctx.Done():
        return nil, ctx.Err()
    default:
        // fetch user
    }
}

// Use context timeouts
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

user, err := FetchUser(ctx, userID)
```

### Common Concurrency Patterns

#### Worker Pool
```go
type Job struct {
    ID   int
    Data interface{}
}

type WorkerPool struct {
    workerCount int
    jobs        chan Job
    results     chan Result
    wg          sync.WaitGroup
}

func NewWorkerPool(workerCount int) *WorkerPool {
    return &WorkerPool{
        workerCount: workerCount,
        jobs:        make(chan Job, 100),
        results:     make(chan Result, 100),
    }
}

func (wp *WorkerPool) Start(ctx context.Context) {
    for i := 0; i < wp.workerCount; i++ {
        wp.wg.Add(1)
        go wp.worker(ctx)
    }
}

func (wp *WorkerPool) worker(ctx context.Context) {
    defer wp.wg.Done()
    for {
        select {
        case <-ctx.Done():
            return
        case job, ok := <-wp.jobs:
            if !ok {
                return
            }
            result := processJob(job)
            wp.results <- result
        }
    }
}
```

#### Fan-Out, Fan-In
```go
func FanOut(input <-chan int, workers int) []<-chan int {
    channels := make([]<-chan int, workers)
    for i := 0; i < workers; i++ {
        channels[i] = worker(input)
    }
    return channels
}

func FanIn(channels ...<-chan int) <-chan int {
    out := make(chan int)
    var wg sync.WaitGroup

    for _, c := range channels {
        wg.Add(1)
        go func(ch <-chan int) {
            defer wg.Done()
            for n := range ch {
                out <- n
            }
        }(c)
    }

    go func() {
        wg.Wait()
        close(out)
    }()

    return out
}
```

## Error Handling

### Idiomatic Error Handling
```go
// Good - explicit error checks
result, err := DoSomething()
if err != nil {
    return fmt.Errorf("failed to do something: %w", err)  // Use %w for error wrapping
}

// Bad - ignoring errors
result, _ := DoSomething()  // Never ignore errors
```

### Custom Errors
```go
// Sentinel errors
var (
    ErrNotFound     = errors.New("not found")
    ErrUnauthorized = errors.New("unauthorized")
    ErrInvalidInput = errors.New("invalid input")
)

// Error types with context
type ValidationError struct {
    Field string
    Value interface{}
    Err   error
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation failed for field %s: %v", e.Field, e.Err)
}

func (e *ValidationError) Unwrap() error {
    return e.Err
}

// Usage
if err != nil {
    if errors.Is(err, ErrNotFound) {
        // handle not found
    }

    var validationErr *ValidationError
    if errors.As(err, &validationErr) {
        // handle validation error
    }
}
```

### Error Wrapping
```go
// Wrap errors for context
func GetUser(id UserID) (*User, error) {
    user, err := repo.Find(id)
    if err != nil {
        return nil, fmt.Errorf("get user %v: %w", id, err)
    }
    return user, nil
}

// Unwrap to check original error
err := GetUser(123)
if errors.Is(err, sql.ErrNoRows) {
    // handle not found
}
```

## Clean Code Principles

### Naming Conventions
```go
// Exported (public) - starts with capital
type User struct{}
func NewUser() *User

// Unexported (private) - starts with lowercase
type userRepository struct{}
func newUserRepository() *userRepository

// Acronyms - all caps or all lowercase
type HTTPClient struct{}  // not HttpClient
var urlString string      // not urlString when unexported

// Interface names
type Reader interface{}      // -er suffix for single method
type UserRepository interface{}  // descriptive for multiple methods
```

### Function Design
```go
// Keep functions small and focused
// Good - single responsibility
func ValidateEmail(email string) error {
    if !emailRegex.MatchString(email) {
        return ErrInvalidEmail
    }
    return nil
}

// Bad - doing too much
func ProcessUser(email string, password string) error {
    // validate email
    // validate password
    // hash password
    // save to database
    // send email
    // log everything
}

// Prefer returning errors over panics
func Divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}
```

### Interfaces
**Accept interfaces, return structs**:

```go
// Good
type UserService struct {
    repo UserRepository  // Accept interface
}

func (s *UserService) GetUser(id UserID) (*User, error) {
    return s.repo.Find(id)  // Return struct
}

// Define interfaces where they're used, not where implemented
type UserRepository interface {
    Find(id UserID) (*User, error)
    Save(user *User) error
}

// Small interfaces are better
type Reader interface {
    Read(p []byte) (n int, err error)
}
```

## Testing

### Table-Driven Tests
```go
func TestSum(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive numbers", 2, 3, 5},
        {"negative numbers", -2, -3, -5},
        {"mixed", -2, 5, 3},
        {"zeros", 0, 0, 0},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Sum(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Sum(%d, %d) = %d; want %d",
                    tt.a, tt.b, result, tt.expected)
            }
        })
    }
}
```

### Test Helpers
```go
func TestFetchUser(t *testing.T) {
    t.Helper()  // Mark as helper for better error messages

    // Use testify/assert for cleaner assertions
    user, err := FetchUser(context.Background(), 123)
    assert.NoError(t, err)
    assert.NotNil(t, user)
    assert.Equal(t, "John", user.Name)
}
```

### Mocking with Interfaces
```go
type MockUserRepository struct {
    mock.Mock
}

func (m *MockUserRepository) Find(id UserID) (*User, error) {
    args := m.Called(id)
    if args.Get(0) == nil {
        return nil, args.Error(1)
    }
    return args.Get(0).(*User), args.Error(1)
}

func TestUserService(t *testing.T) {
    mockRepo := new(MockUserRepository)
    mockRepo.On("Find", UserID(123)).Return(&User{Name: "John"}, nil)

    service := &UserService{repo: mockRepo}
    user, err := service.GetUser(123)

    assert.NoError(t, err)
    assert.Equal(t, "John", user.Name)
    mockRepo.AssertExpectations(t)
}
```

### Benchmarks
```go
func BenchmarkSum(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Sum(100, 200)
    }
}

// Run: go test -bench=. -benchmem
```

## Dependency Management

### Go Modules
```bash
# Initialize module
go mod init github.com/username/project

# Add dependency
go get github.com/stretchr/testify

# Update dependencies
go get -u ./...

# Tidy up
go mod tidy

# Vendor dependencies
go mod vendor
```

### Version Pinning
```go
// go.mod
module github.com/username/project

go 1.22

require (
    github.com/gin-gonic/gin v1.10.0
    github.com/stretchr/testify v1.9.0
)

// Pin specific version
// go get github.com/gin-gonic/gin@v1.10.0
```

## Performance & Optimization

### Profiling
```go
import _ "net/http/pprof"

func main() {
    go func() {
        http.ListenAndServe("localhost:6060", nil)
    }()
    // your app code
}

// Access profiles:
// http://localhost:6060/debug/pprof/
// go tool pprof http://localhost:6060/debug/pprof/heap
```

### Memory Optimization
```go
// Pre-allocate slices when size is known
items := make([]Item, 0, expectedSize)

// Reuse buffers
var buf bytes.Buffer
buf.Reset()  // Reuse instead of creating new

// Use string builders for concatenation
var sb strings.Builder
sb.WriteString("hello")
sb.WriteString(" world")
result := sb.String()

// Avoid unnecessary allocations
// Bad
s := fmt.Sprintf("%d", num)

// Good
s := strconv.Itoa(num)
```

## Production Readiness

### Structured Logging
```go
import "log/slog"

func main() {
    logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))

    logger.Info("server started",
        slog.String("address", ":8080"),
        slog.Int("workers", 10),
    )

    logger.Error("failed to process request",
        slog.String("user_id", "123"),
        slog.String("error", err.Error()),
    )
}
```

### Graceful Shutdown
```go
func main() {
    srv := &http.Server{Addr: ":8080"}

    go func() {
        if err := srv.ListenAndServe(); err != http.ErrServerClosed {
            log.Fatalf("server error: %v", err)
        }
    }()

    // Wait for interrupt signal
    quit := make(chan os.Signal, 1)
    signal.Notify(quit, os.Interrupt, syscall.SIGTERM)
    <-quit

    // Graceful shutdown with timeout
    ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()

    if err := srv.Shutdown(ctx); err != nil {
        log.Fatalf("server forced to shutdown: %v", err)
    }

    log.Println("server exited gracefully")
}
```

### Configuration
```go
// Use environment variables with defaults
type Config struct {
    Port        string        `env:"PORT" envDefault:"8080"`
    DatabaseURL string        `env:"DATABASE_URL,required"`
    Timeout     time.Duration `env:"TIMEOUT" envDefault:"30s"`
}

// Use viper or envconfig for loading
```

### Health Checks
```go
func healthHandler(w http.ResponseWriter, r *http.Request) {
    health := map[string]string{
        "status":    "ok",
        "version":   version,
        "timestamp": time.Now().Format(time.RFC3339),
    }

    // Check dependencies
    if err := db.Ping(); err != nil {
        health["status"] = "unhealthy"
        health["database"] = "down"
        w.WriteHeader(http.StatusServiceUnavailable)
    }

    json.NewEncoder(w).Encode(health)
}
```

## Common Pitfalls to Avoid

1. **Goroutine leaks** - always ensure goroutines can exit
2. **Not closing channels** - causes goroutines to hang
3. **Data races** - run tests with `-race` flag
4. **Ignoring errors** - never use `_` for errors
5. **Premature optimization** - profile first
6. **Not using context** - always pass context for cancellation
7. **Mutex copying** - mutexes must not be copied after first use
8. **Range loop variable capture** - use function parameter or shadow variable
9. **Nil pointer dereferences** - always check for nil
10. **Not handling panics** - use recover() in production code

## Industry Standards

### Code Quality Tools
```bash
# Format code
go fmt ./...

# Lint code
golangci-lint run

# Vet code
go vet ./...

# Check for vulnerabilities
govulncheck ./...

# Run tests with race detector
go test -race ./...
```

### CI/CD Pipeline
```yaml
# .github/workflows/go.yml
name: Go
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-go@v4
        with:
          go-version: '1.22'
      - run: go mod download
      - run: go vet ./...
      - run: go test -race -coverprofile=coverage.out ./...
      - run: go build -v ./...
```

## References

- [Effective Go](https://go.dev/doc/effective_go)
- [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments)
- [Uber Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md)
- [Standard Go Project Layout](https://github.com/golang-standards/project-layout)
- [Go Proverbs](https://go-proverbs.github.io/)
