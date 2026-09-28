-- ============================================================
-- LogiFlow Logistics Analytics Platform
-- PostgreSQL Operational Database Schema
-- ============================================================


-- ============================================================
-- 1. DESTINATIONS
-- ============================================================

CREATE TABLE destinations (
    destination_id SERIAL PRIMARY KEY,
    destination_name VARCHAR(150) NOT NULL,
    location VARCHAR(150),
    region VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 2. CUSTOMERS
-- ============================================================

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(150) NOT NULL,
    customer_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 3. PRODUCTS
-- ============================================================

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    product_category VARCHAR(100),
    unit_of_measure VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 4. VEHICLES
-- ============================================================

CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    vehicle_registration VARCHAR(30) NOT NULL UNIQUE,
    vehicle_type VARCHAR(50),
    capacity NUMERIC(12,2),
    status VARCHAR(30) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 5. DRIVERS
-- ============================================================

CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,
    driver_name VARCHAR(150) NOT NULL,
    phone_number VARCHAR(30),
    status VARCHAR(30) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 6. WAREHOUSES
-- ============================================================

CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    warehouse_name VARCHAR(150) NOT NULL,
    location VARCHAR(150),
    status VARCHAR(30) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 7. LOADING OFFICERS
-- ============================================================

CREATE TABLE loading_officers (
    officer_id SERIAL PRIMARY KEY,
    officer_name VARCHAR(150) NOT NULL,
    warehouse_id INTEGER NOT NULL,
    status VARCHAR(30) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_officer_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id)
);


-- ============================================================
-- 8. CANCELLATION REASONS
-- ============================================================

CREATE TABLE cancellation_reasons (
    cancellation_reason_id SERIAL PRIMARY KEY,
    reason VARCHAR(150) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 9. LOADS
-- ============================================================

CREATE TABLE loads (
    load_id SERIAL PRIMARY KEY,

    customer_id INTEGER NOT NULL,
    vehicle_id INTEGER NOT NULL,
    driver_id INTEGER NOT NULL,
    warehouse_id INTEGER NOT NULL,
    destination_id INTEGER NOT NULL,
    officer_id INTEGER NOT NULL,

    loading_start_datetime TIMESTAMP,
    loading_end_datetime TIMESTAMP,
    expected_delivery_datetime TIMESTAMP,

    status VARCHAR(30) NOT NULL DEFAULT 'Pending',

    cancellation_reason_id INTEGER,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,


    -- --------------------------------------------------------
    -- Foreign Key Relationships
    -- --------------------------------------------------------

    CONSTRAINT fk_load_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_load_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES vehicles(vehicle_id),

    CONSTRAINT fk_load_driver
        FOREIGN KEY (driver_id)
        REFERENCES drivers(driver_id),

    CONSTRAINT fk_load_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id),

    CONSTRAINT fk_load_destination
        FOREIGN KEY (destination_id)
        REFERENCES destinations(destination_id),

    CONSTRAINT fk_load_officer
        FOREIGN KEY (officer_id)
        REFERENCES loading_officers(officer_id),

    CONSTRAINT fk_load_cancellation_reason
        FOREIGN KEY (cancellation_reason_id)
        REFERENCES cancellation_reasons(cancellation_reason_id),


    -- --------------------------------------------------------
    -- Data Integrity Rules
    -- --------------------------------------------------------

    CONSTRAINT chk_loading_time
        CHECK (
            loading_end_datetime IS NULL
            OR loading_start_datetime IS NULL
            OR loading_end_datetime >= loading_start_datetime
        ),

    CONSTRAINT chk_cancellation_reason
        CHECK (
            status <> 'Cancelled'
            OR cancellation_reason_id IS NOT NULL
        )
);


-- ============================================================
-- 10. LOAD ITEMS
-- ============================================================

CREATE TABLE load_items (
    load_item_id SERIAL PRIMARY KEY,

    load_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,

    quantity NUMERIC(12,2) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,


    -- --------------------------------------------------------
    -- Foreign Key Relationships
    -- --------------------------------------------------------

    CONSTRAINT fk_load_item_load
        FOREIGN KEY (load_id)
        REFERENCES loads(load_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_load_item_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),


    -- --------------------------------------------------------
    -- Data Integrity Rules
    -- --------------------------------------------------------

    CONSTRAINT chk_positive_quantity
        CHECK (quantity > 0)
);


-- ============================================================
-- 11. DELIVERIES
-- ============================================================

CREATE TABLE deliveries (
    delivery_id SERIAL PRIMARY KEY,

    load_id INTEGER NOT NULL,

    actual_delivery_datetime TIMESTAMP,
    delivery_status VARCHAR(30),
    delivery_notes TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,


    -- --------------------------------------------------------
    -- Foreign Key Relationship
    -- --------------------------------------------------------

    CONSTRAINT fk_delivery_load
        FOREIGN KEY (load_id)
        REFERENCES loads(load_id)
        ON DELETE CASCADE
);


-- ============================================================
-- END OF LOGIFLOW OPERATIONAL DATABASE SCHEMA
-- ============================================================
