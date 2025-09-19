from psycopg2 import __libpq_version__


def main():
    print("Hello from uv2nix python!")
    print(f"libpq version: {__libpq_version__}")


if __name__ == "__main__":
    main()
