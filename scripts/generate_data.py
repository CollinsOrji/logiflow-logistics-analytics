"""
LogiFlow Logistics Analytics Platform
Synthetic Operational Data Generator

Generates reproducible synthetic logistics data for:
- Development
- Testing
- Data-quality analysis
- PostgreSQL loading
- dbt transformations
- Power BI reporting
"""

import random
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd


# ============================================================
# CONFIGURATION
# ============================================================

RANDOM_SEED = 42

NUM_CUSTOMERS = 100
NUM_PRODUCTS = 50
NUM_VEHICLES = 30
NUM_DRIVERS = 40
NUM_WAREHOUSES = 5
NUM_DESTINATIONS = 20
NUM_LOADING_OFFICERS = 25
NUM_LOADS = 10_000

OUTPUT_DIR = Path("data/raw")

random.seed(RANDOM_SEED)


# ============================================================
# REFERENCE DATA
# ============================================================

CUSTOMER_TYPES = [
    "Retail",
    "Wholesale",
    "Distributor",
]

PRODUCT_CATEGORIES = [
    "Beverages",
    "Food",
    "Personal Care",
    "Home Care",
]

UNITS_OF_MEASURE = [
    "Cases",
    "Cartons",
    "Pallets",
]

VEHICLE_TYPES = [
    "Truck",
    "Van",
    "Trailer",
]

STATUSES = [
    "Active",
    "Inactive",
]

LOAD_STATUSES = [
    "Pending",
    "In Transit",
    "Delivered",
    "Cancelled",
]

DELIVERY_STATUSES = [
    "Delivered",
    "Failed",
    "Partially Delivered",
]

REGIONS = [
    "South West",
    "South East",
    "South South",
    "North Central",
    "North West",
]

CANCELLATION_REASONS = [
    (
        "Vehicle Breakdown",
        "Vehicle became unavailable before dispatch.",
    ),
    (
        "Customer Request",
        "Customer requested cancellation.",
    ),
    (
        "Stock Unavailable",
        "Required product was unavailable.",
    ),
    (
        "Documentation Issue",
        "Required documentation was incomplete.",
    ),
    (
        "Operational Delay",
        "Operational issue prevented dispatch.",
    ),
]


# ============================================================
# HELPER FUNCTIONS
# ============================================================

def random_datetime(start_date, end_date):
    """Generate a random datetime between two dates."""

    time_difference = end_date - start_date

    random_seconds = random.randint(
        0,
        int(time_difference.total_seconds()),
    )

    return start_date + timedelta(seconds=random_seconds)


def random_phone():
    """Generate a synthetic Nigerian-style phone number."""

    return f"080{random.randint(10000000, 99999999)}"


# ============================================================
# DESTINATIONS
# ============================================================

def generate_destinations():
    """Generate destination master data."""

    cities = [
        "Lagos",
        "Ibadan",
        "Benin City",
        "Abuja",
        "Port Harcourt",
        "Enugu",
        "Aba",
        "Onitsha",
        "Kano",
        "Ilorin",
        "Jos",
        "Owerri",
        "Warri",
        "Akure",
        "Uyo",
        "Calabar",
        "Kaduna",
        "Abeokuta",
        "Asaba",
        "Makurdi",
    ]

    records = []

    for destination_id, city in enumerate(cities, start=1):
        records.append(
            {
                "destination_id": destination_id,
                "destination_name": f"{city} Distribution Hub",
                "location": city,
                "region": random.choice(REGIONS),
                "created_at": datetime.now(),
            }
        )

    return pd.DataFrame(records)


# ============================================================
# CUSTOMERS
# ============================================================

def generate_customers():
    """Generate customer master data."""

    records = []

    for customer_id in range(1, NUM_CUSTOMERS + 1):
        records.append(
            {
                "customer_id": customer_id,
                "customer_name": f"Customer {customer_id:03d}",
                "customer_type": random.choice(CUSTOMER_TYPES),
                "created_at": datetime.now(),
            }
        )

    return pd.DataFrame(records)


# ============================================================
# PRODUCTS
# ============================================================

def generate_products():
    """Generate product master data."""

    records = []

    for product_id in range(1, NUM_PRODUCTS + 1):
        category = random.choice(PRODUCT_CATEGORIES)

        records.append(
            {
                "product_id": product_id,
                "product_name": f"{category} Product {product_id:03d}",
                "product_category": category,
                "unit_of_measure": random.choice(
                    UNITS_OF_MEASURE
                ),
                "created_at": datetime.now(),
            }
        )

    return pd.DataFrame(records)


# ============================================================
# VEHICLES
# ============================================================

def generate_vehicles():
    """Generate vehicle master data with unique registrations."""

    records = []
    registrations = set()

    for vehicle_id in range(1, NUM_VEHICLES + 1):

        while True:
            registration = (
                f"LG-{random.randint(1000, 9999)}-"
                f"{random.choice(['AB', 'BC', 'CD', 'EF', 'GH'])}"
            )

            if registration not in registrations:
                registrations.add(registration)
                break

        records.append(
            {
                "vehicle_id": vehicle_id,
                "vehicle_registration": registration,
                "vehicle_type": random.choice(VEHICLE_TYPES),
                "capacity": random.choice(
                    [
                        3000,
                        5000,
                        8000,
                        10000,
                        15000,
                    ]
                ),
                "status": random.choice(STATUSES),
                "created_at": datetime.now(),
            }
        )

    return pd.DataFrame(records)


# ============================================================
# DRIVERS
# ============================================================

def generate_drivers():
    """Generate driver master data."""

    records = []

    for driver_id in range(1, NUM_DRIVERS + 1):
        records.append(
            {
                "driver_id": driver_id,
                "driver_name": f"Driver {driver_id:03d}",
                "phone_number": random_phone(),
                "status": random.choice(STATUSES),
                "created_at": datetime.now(),
            }
        )

    return pd.DataFrame(records)


# ============================================================
# WAREHOUSES
# ============================================================

def generate_warehouses():
    """Generate warehouse master data."""

    warehouse_locations = [
        ("Lagos Central Warehouse", "Lagos"),
        ("Ibadan Regional Warehouse", "Ibadan"),
        ("Port Harcourt Warehouse", "Port Harcourt"),
        ("Abuja Distribution Centre", "Abuja"),
        ("Onitsha Distribution Centre", "Onitsha"),
    ]

    records = []

    for warehouse_id, (name, location) in enumerate(
        warehouse_locations,
        start=1,
    ):
        records.append(
            {
                "warehouse_id": warehouse_id,
                "warehouse_name": name,
                "location": location,
                "status": "Active",
                "created_at": datetime.now(),
            }
        )

    return pd.DataFrame(records)


# ============================================================
# LOADING OFFICERS
# ============================================================

def generate_loading_officers():
    """Generate loading officers assigned to warehouses."""

    records = []

    for officer_id in range(1, NUM_LOADING_OFFICERS + 1):
        records.append(
            {
                "officer_id": officer_id,
                "officer_name": (
                    f"Loading Officer {officer_id:03d}"
                ),
                "warehouse_id": random.randint(
                    1,
                    NUM_WAREHOUSES,
                ),
                "status": "Active",
                "created_at": datetime.now(),
            }
        )

    return pd.DataFrame(records)


# ============================================================
# CANCELLATION REASONS
# ============================================================

def generate_cancellation_reasons():
    """Generate standardized cancellation reasons."""

    records = []

    for reason_id, (reason, description) in enumerate(
        CANCELLATION_REASONS,
        start=1,
    ):
        records.append(
            {
                "cancellation_reason_id": reason_id,
                "reason": reason,
                "description": description,
                "created_at": datetime.now(),
            }
        )

    return pd.DataFrame(records)


# ============================================================
# LOADS
# ============================================================

def generate_loads(loading_officers):
    """Generate logistics load transactions."""

    start_date = datetime(2025, 1, 1)
    end_date = datetime(2025, 12, 31)

    records = []

    # Group officers by warehouse so the generated
    # officer assignment remains consistent.
    officers_by_warehouse = (
        loading_officers.groupby("warehouse_id")["officer_id"]
        .apply(list)
        .to_dict()
    )

    for load_id in range(1, NUM_LOADS + 1):

        warehouse_id = random.randint(
            1,
            NUM_WAREHOUSES,
        )

        available_officers = officers_by_warehouse.get(
            warehouse_id,
            [],
        )

        # Every warehouse should have at least one officer.
        # The fallback protects the generator if the number
        # of officers is changed in the future.
        if not available_officers:
            officer_id = random.randint(
                1,
                NUM_LOADING_OFFICERS,
            )
        else:
            officer_id = random.choice(
                available_officers
            )

        loading_start = random_datetime(
            start_date,
            end_date,
        )

        loading_duration = timedelta(
            minutes=random.randint(30, 240)
        )

        loading_end = (
            loading_start
            + loading_duration
        )

        expected_delivery = (
            loading_end
            + timedelta(
                hours=random.randint(12, 72)
            )
        )

        status = random.choices(
            LOAD_STATUSES,
            weights=[10, 15, 65, 10],
            k=1,
        )[0]

        cancellation_reason_id = None

        if status == "Cancelled":
            cancellation_reason_id = random.randint(
                1,
                len(CANCELLATION_REASONS),
            )

        records.append(
            {
                "load_id": load_id,
                "customer_id": random.randint(
                    1,
                    NUM_CUSTOMERS,
                ),
                "vehicle_id": random.randint(
                    1,
                    NUM_VEHICLES,
                ),
                "driver_id": random.randint(
                    1,
                    NUM_DRIVERS,
                ),
                "warehouse_id": warehouse_id,
                "destination_id": random.randint(
                    1,
                    NUM_DESTINATIONS,
                ),
                "officer_id": officer_id,
                "loading_start_datetime": loading_start,
                "loading_end_datetime": loading_end,
                "expected_delivery_datetime": (
                    expected_delivery
                ),
                "status": status,
                "cancellation_reason_id": (
                    cancellation_reason_id
                ),
                "created_at": loading_start,
            }
        )

    return pd.DataFrame(records)


# ============================================================
# LOAD ITEMS
# ============================================================

def generate_load_items(loads):
    """Generate product lines associated with each load."""

    records = []

    load_item_id = 1

    for load_id in loads["load_id"]:

        number_of_products = random.randint(1, 5)

        selected_products = random.sample(
            range(1, NUM_PRODUCTS + 1),
            number_of_products,
        )

        for product_id in selected_products:

            records.append(
                {
                    "load_item_id": load_item_id,
                    "load_id": load_id,
                    "product_id": product_id,
                    "quantity": random.randint(
                        10,
                        1000,
                    ),
                    "created_at": datetime.now(),
                }
            )

            load_item_id += 1

    return pd.DataFrame(records)


# ============================================================
# DELIVERIES
# ============================================================

def generate_deliveries(loads):
    """
    Generate delivery records only for completed loads.

    In Transit, Pending, and Cancelled loads do not receive
    an actual delivery record because delivery has not yet
    been completed.
    """

    records = []

    delivery_id = 1

    delivered_loads = loads[
        loads["status"] == "Delivered"
    ]

    for _, load in delivered_loads.iterrows():

        expected_delivery = (
            load["expected_delivery_datetime"]
        )

        delay_hours = random.randint(
            -12,
            48,
        )

        actual_delivery = (
            expected_delivery
            + timedelta(hours=delay_hours)
        )

        delivery_status = random.choices(
            DELIVERY_STATUSES,
            weights=[90, 5, 5],
            k=1,
        )[0]

        delivery_notes = None

        if delivery_status == "Failed":
            delivery_notes = (
                "Delivery could not be completed."
            )

        elif delivery_status == "Partially Delivered":
            delivery_notes = (
                "Only part of the shipment was delivered."
            )

        records.append(
            {
                "delivery_id": delivery_id,
                "load_id": load["load_id"],
                "actual_delivery_datetime": (
                    actual_delivery
                ),
                "delivery_status": delivery_status,
                "delivery_notes": delivery_notes,
                "created_at": actual_delivery,
            }
        )

        delivery_id += 1

    return pd.DataFrame(records)


# ============================================================
# MAIN GENERATION PROCESS
# ============================================================

def main():

    OUTPUT_DIR.mkdir(
        parents=True,
        exist_ok=True,
    )

    print("Generating LogiFlow synthetic data...")
    print(f"Random seed: {RANDOM_SEED}")
    print()

    destinations = generate_destinations()

    customers = generate_customers()

    products = generate_products()

    vehicles = generate_vehicles()

    drivers = generate_drivers()

    warehouses = generate_warehouses()

    loading_officers = generate_loading_officers()

    cancellation_reasons = (
        generate_cancellation_reasons()
    )

    loads = generate_loads(
        loading_officers
    )

    load_items = generate_load_items(
        loads
    )

    deliveries = generate_deliveries(
        loads
    )

    datasets = {
        "destinations": destinations,
        "customers": customers,
        "products": products,
        "vehicles": vehicles,
        "drivers": drivers,
        "warehouses": warehouses,
        "loading_officers": loading_officers,
        "cancellation_reasons": cancellation_reasons,
        "loads": loads,
        "load_items": load_items,
        "deliveries": deliveries,
    }

    print("Writing datasets...")
    print()

    # Write every dataset to CSV.
    for name, dataframe in datasets.items():

        # Keep nullable foreign-key IDs as integers
        # instead of writing values such as 5.0.
        if name == "loads":
            dataframe["cancellation_reason_id"] = (
                dataframe["cancellation_reason_id"]
                .astype("Int64")
            )

        output_file = OUTPUT_DIR / f"{name}.csv"

        dataframe.to_csv(
            output_file,
            index=False,
            na_rep="",
        )

        print(
            f"Created {output_file} "
            f"({len(dataframe):,} records)"
        )

    print()
    print(
        "Data generation completed successfully."
    )


# ============================================================
# SCRIPT ENTRY POINT
# ============================================================

if __name__ == "__main__":
    main()