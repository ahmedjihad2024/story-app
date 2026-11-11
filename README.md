# Storey App

A modern Flutter e-commerce mobile application powered by **Supabase**, **Riverpod**, **GoRouter**, and **Clean Architecture**. Users can browse featured and popular products, filter and search the catalog, manage wishlists, update their cart with real-time cross-screen sync, place Cash-on-Delivery (COD) orders via atomic database RPCs, and track order history by status.

---

## Features

- **Authentication & Session Guard:** Email/password Sign In and Sign Up via Supabase Auth, splash initialization, and reactive `GoRouter` route protection listening to `onAuthStateChange` (`_AuthRefreshListenable`).
- **Home Discovery (`get_home_data` RPC):** Loads promotional banners, categories, featured items, and popular products in a single database round-trip, paired with a floating animated pill bottom navigation bar (`Home` & `Profile`).
- **Catalog, Search & Filtering:** Infinite-scroll product grids (`ProductsScreen`) and live search (`SearchScreen`, `FilterScreen`) with `ilike` matching on product name and brand, category chips, price range filtering, and sorting (`newest`, `popular`, `price low-to-high`, `price high-to-low`).
- **Product Details & Wishlist (`Favorites`):** Detailed product view with discount badges, rating display, optimistic wishlist toggling, and add-to-cart actions.
- **Shopping Cart & Atomic Checkout (`checkout_cod_order` RPC):** Full cart management (`add`, `increment`, `decrement`, `remove`, `clear`) and one-tap COD checkout with loading state, automatic cart clearing, and order confirmation feedback.
- **Orders & Status Filtering (`OrdersScreen`):** Paginated order history with pull-to-refresh, item previews, totals, and horizontal status filter chips (`All`, `Pending`, `Paid`, `Shipped`, `Delivered`, `Cancelled`).
- **Profile & Avatar Storage (`ProfileImages`):** View and edit user metadata (`first_name`, `last_name`, `email`) and upload profile avatars to Supabase Storage with automatic cleanup of older avatar files.

---

## Technical Highlights & Architecture

### 1. Typed Supabase Schema (`supabase_typegen`)
Instead of untyped string table/column keys, database queries use generated types in `lib/core/network/supabase_schema.g.dart` (`Cart`, `Category`, `Favorites`, `Offers`, `Orders`, `OrderedProduct`, `Products`). Filters, sorting, and `selectOnly` projections with `PostgrestPartialRow` are checked at compile time.

### 2. Supabase Postgres RPC Functions
Multi-step reads and transactional writes run server-side in Postgres functions (`_sb.rpc(...)`) to minimize round-trips and ensure atomicity:
- **`get_home_data`**: Aggregates banners, categories, featured products, and popular products in one payload.
- **`checkout_cod_order`**: Creates the order and ordered items and clears the cart atomically on the backend.

### 3. Inner Joins & Embedded Relations (No N+1 Queries)
Following Postgres data-access best practices, related tables are fetched in a single PostgREST query rather than issuing per-row follow-up requests:
- **Cart (`CartScreenApiServiceImpl`):** Uses `.requiring(Cart.products)` (inner join) to automatically exclude unavailable products, while nested `.embedded(...)` scopes `Products.favorites` to the signed-in user (`Favorites.userId.eq(userId)`) to resolve `isInFavorites` in the same request.
- **Orders (`OrdersApiServicesImpl`):** Embeds `Orders -> OrderedProduct -> Products` automatically via foreign-key definitions (`ordered_product.order_id` and `ordered_product.product_id`), sorted deterministically (`created_at DESC, id DESC`) with `.range(from, to)` pagination.
- **Products & Search:** Embed user-scoped `Favorites` alongside product columns so wishlist badges render accurately on first paint.

### 4. Clean Architecture, Functional Error Handling & DI
Each feature follows a strict **`data` / `domain` / `presentation`** separation (with cross-feature capabilities such as `favorite`, `profile`, and shared cart mutations under `lib/core/shared/`):
- **DI Container (`lib/core/di/dependency_injection.dart`):** Wires API services, remote data sources, repositories, and use cases with Riverpod `Provider`s inside a single `ProviderContainer`.
- **Unified Error Mapping (`fastHandler`):** Maps `AuthException`, `PostgrestException` (`42501`, `PGRST116`, `23505`), `StorageException`, `SocketException`, and `TimeoutException` into domain `Failure` objects using `dartz` `Either<Failure, T>`.

### 5. Reactive Cross-Screen Sync (`AppEventBus`)
An application-wide broadcast event bus (`AppEventBus` + `EventBusMixin`) emits lightweight domain events (`ProductFavoriteChanged`, `ProductCartChanged`, `CartCleared`, `ProfileUpdated`) so Home, Search, Products, Product Details, Favorites, Cart, and Profile stay synchronized immediately without stale UI or redundant network calls.

### 6. UI/UX, Accessibility & Developer Tooling
- **Modular Widget Trees:** Screens compose focused `StatelessWidget` / `StatefulWidget` sub-widgets with `const` constructors, `Skeletonizer` shimmer loaders, `CustomizedSmartRefresh` pull-to-refresh/pagination, high-contrast color tokens (`ColorM`), semantic labels, `>= 44px` touch targets, and `MediaQuery.disableAnimationsOf` support.
- **Debug HTTP Logger (`SupabaseLogger`):** Wraps `http.BaseClient` in `kDebugMode` only, automatically redacting `authorization` and `apikey` headers while formatting request/response JSON and timings.

---

## Project Structure

```text
lib/
├── main.dart                         # Env loading, Supabase init, DI & ProviderScope setup
├── core/
│   ├── animations/                   # Reusable appear animations
│   ├── app/                          # MaterialApp.router root configuration
│   ├── config/env.dart               # .env loader (SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY)
│   ├── di/dependency_injection.dart  # Riverpod DI providers & extensions
│   ├── enums/                        # ReqState, OrderStatus
│   ├── events/                       # AppEventBus & EventBusMixin
│   ├── extensions/                   # Supabase requireUserId, navigation, formatting helpers
│   ├── network/                      # error_handler, failure_message, SupabaseLogger, supabase_schema.g.dart
│   ├── routing/                      # GoRouter routes & reactive auth redirect
│   ├── shared/                       # Shared favorite, profile, and cart mutation layers + controllers
│   ├── theme/                        # ColorM, FontsM, SizeM, ThemeManager
│   └── widgets/                      # PrimaryButton, AppCachedImage, StateRender, CustomizedSmartRefresh
└── features/
    ├── auth/                         # Sign In & Sign Up
    ├── cart/                         # Cart screen, clear cart, COD checkout
    ├── favorites/                    # Saved items grid
    ├── home/                         # Home tab, banners, categories, featured & popular sections
    ├── main_layout/                  # PageView shell + floating bottom navigation pill
    ├── orders/                       # Orders list, status filter chips, order cards
    ├── product_details/              # Product detail page
    ├── products/                     # Paginated products list (featured, popular, category)
    ├── profile/                      # Profile tab & navigation hub
    ├── search/                       # Search & multi-criteria filter sheet/screen
    ├── splash/                       # Initial auth/session routing
    └── update_profile/               # Profile editing & avatar upload
```

---

## Tech Stack

- **Framework:** Flutter (Dart SDK `^3.12.0`)
- **Backend & Codegen:** `supabase_flutter` (`^3.0.0-dev.16`), `supabase_typegen` (`^0.8.2`)
- **State Management & DI:** `flutter_riverpod` (`^3.5.0`)
- **Navigation:** `go_router` (`^18.1.3`)
- **Functional Types:** `dartz` (`^0.10.1`)
- **UI & Utilities:** `cached_network_image`, `carousel_slider`, `flutter_animate`, `flutter_svg`, `image_picker`, `pull_to_refresh`, `skeletonizer`, `flutter_dotenv`

---

## Getting Started

1. **Create a `.env` file** at the project root with your Supabase credentials:
   ```env
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_PUBLISHABLE_KEY=your_supabase_publishable_key
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

4. **Regenerate Supabase Dart schema types (after DB schema changes):**
   ```bash
   npx supabase gen types --lang dart --project-id <your-project-ref> --schema public > lib/core/network/supabase_schema.g.dart
   ```
