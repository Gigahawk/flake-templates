from psycopg2 import __libpq_version__


def main():
    print("Hello from uv2nix python!")
    print(f"libpq version: {__libpq_version__}")
    print(f"1 / 2 = {divide(1, 2)}")


def divide(a, b):
    return a / b


if __name__ == "__main__":
    main()
