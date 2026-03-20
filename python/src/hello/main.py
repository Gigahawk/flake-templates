import click


def main():
    print("Hello from uv2nix python!")
    print(f"click version: {click.__version__}")
    print(f"1 / 2 = {divide(1, 2)}")


def divide(a, b):
    return a / b


if __name__ == "__main__":
    main()
