# LogiFlow — Data Model

## 1. Purpose

The LogiFlow data model defines how logistics operational data will be structured, stored, and related within the analytics platform.

The model is designed to support:

- Logistics load tracking
- Product movement
- Warehouse operations
- Vehicle and driver activity
- Delivery performance
- Cancellation analysis
- Data quality monitoring
- Business intelligence reporting

The operational database will use a relational structure to maintain data integrity and reduce unnecessary duplication.

A separate analytics model can later be created through the transformation layer for Power BI reporting.

---

## 2. Data Modelling Approach

The project uses two logical modelling layers:

### Operational Data Model

The operational database will use a normalized relational structure.

This layer is responsible for:

- Capturing operational transactions
- Maintaining relationships between entities
- Enforcing data integrity
- Supporting reliable data ingestion
- Storing source operational records

### Analytics Data Model

The transformation layer will prepare the operational data for analytics and reporting.

This layer will:

- Transform operational records
- Create business-friendly metrics
- Prepare fact and dimension structures
- Support Power BI reporting
- Improve analytical performance

This separation allows the operational database and reporting model to serve different purposes.

---

# 3. Core Entities

## 3.1 Customers

Stores information about customers receiving products.

| Field | Description |
|---|---|
| customer_id | Unique customer identifier |
| customer_name | Customer name |
| customer_type | Customer classification |
| destination_id | Default destination reference |
| created_at | Record creation timestamp |

Primary Key: `customer_id`

---

## 3.2 Products

Stores products being distributed.

| Field | Description |
|---|---|
| product_id | Unique product identifier |
| product_name | Product name |
| product_category | Product category |
| unit_of_measure | Unit used for quantity |
| created_at | Record creation timestamp |

Primary Key: `product_id`

---

## 3.3 Vehicles

Stores vehicles used for transportation.

| Field | Description |
|---|---|
| vehicle_id | Unique vehicle identifier |
| vehicle_registration | Vehicle registration number |
| vehicle_type | Vehicle classification |
| capacity | Vehicle capacity |
| status | Current vehicle status |
| created_at | Record creation timestamp |

Primary Key: `vehicle_id`

---

## 3.4 Drivers

Stores information about drivers assigned to logistics operations.

| Field | Description |
|---|---|
| driver_id | Unique driver identifier |
| driver_name | Driver name |
| phone_number | Driver contact |
| status | Driver status |
| created_at | Record creation timestamp |

Primary Key: `driver_id`

---

## 3.5 Warehouses

Stores warehouses from which products are loaded.

| Field | Description |
|---|---|
| warehouse_id | Unique warehouse identifier |
| warehouse_name | Warehouse name |
| location | Warehouse location |
| status | Warehouse status |
| created_at | Record creation timestamp |

Primary Key: `warehouse_id`

---

## 3.6 Destinations

Stores delivery destinations.

| Field | Description |
|---|---|
| destination_id | Unique destination identifier |
| destination_name | Destination name |
| location | Destination location |
| region | Geographic region |
| created_at | Record creation timestamp |

Primary Key: `destination_id`

---

## 3.7 Loading Officers

Stores users responsible for recording loading activities.

| Field | Description |
|---|---|
| officer_id | Unique loading officer identifier |
| officer_name | Officer name |
| warehouse_id | Assigned warehouse |
| status | Officer status |
| created_at | Record creation timestamp |

Primary Key: `officer_id`

Foreign Key: `warehouse_id`

---

## 3.8 Cancellation Reasons

Stores standardized reasons for cancelled loads.

| Field | Description |
|---|---|
| cancellation_reason_id | Unique cancellation reason identifier |
| reason | Cancellation reason |
| description | Additional explanation |
| created_at | Record creation timestamp |

Primary Key: `cancellation_reason_id`

---

# 4. Transactional Entities

## 4.1 Loads

The `loads` table represents the main logistics transaction.

One row represents one logistics load or dispatch event.

| Field | Description |
|---|---|
| load_id | Unique load identifier |
| customer_id | Customer receiving the load |
| vehicle_id | Vehicle assigned to the load |
| driver_id | Driver assigned to the load |
| warehouse_id | Origin warehouse |
| destination_id | Delivery destination |
| officer_id | Loading officer |
| loading_start_datetime | Loading start time |
| loading_end_datetime | Loading completion time |
| expected_delivery_datetime | Expected delivery time |
| status | Current load status |
| cancellation_reason_id | Cancellation reason where applicable |
| created_at | Record creation timestamp |

Primary Key: `load_id`

Foreign Keys:

- `customer_id`
- `vehicle_id`
- `driver_id`
- `warehouse_id`
- `destination_id`
- `officer_id`
- `cancellation_reason_id`

---

## 4.2 Load Items

A load can contain multiple products.

The `load_items` table stores the individual products included in each load.

| Field | Description |
|---|---|
| load_item_id | Unique load-item identifier |
| load_id | Parent load |
| product_id | Product included in the load |
| quantity | Quantity loaded |
| created_at | Record creation timestamp |

Primary Key: `load_item_id`

Foreign Keys:

- `load_id`
- `product_id`

### Grain

One row represents one product line within a logistics load.

For example:

A single load may contain:

- Product A — 100 units
- Product B — 50 units
- Product C — 75 units

This would result in three records in `load_items` linked to the same `load_id`.

---

## 4.3 Deliveries

The `deliveries` table records delivery outcomes associated with logistics loads.

| Field | Description |
|---|---|
| delivery_id | Unique delivery identifier |
| load_id | Associated load |
| actual_delivery_datetime | Actual delivery time |
| delivery_status | Delivery outcome |
| delivery_notes | Additional delivery information |
| created_at | Record creation timestamp |

Primary Key: `delivery_id`

Foreign Key: `load_id`

The `on_time_delivery` metric will be derived by comparing:

`actual_delivery_datetime`

against

`expected_delivery_datetime`

rather than storing the metric directly in the source transaction.

---

# 5. Entity Relationships

The primary relationships are:

```text
Customers
    |
    | 1:M
    v
  Loads
    |
    | 1:M
    v
Load Items
    |
    | M:1
    v
 Products


Warehouses
    |
    | 1:M
    v
  Loads

Vehicles
    |
    | 1:M
    v
  Loads

Drivers
    |
    | 1:M
    v
  Loads

Loading Officers
    |
    | 1:M
    v
  Loads

Destinations
    |
    | 1:M
    v
  Loads

Loads
    |
    | 1:M
    v
Deliveries

Cancellation Reasons
    |
    | 1:M
    v
  Loads
