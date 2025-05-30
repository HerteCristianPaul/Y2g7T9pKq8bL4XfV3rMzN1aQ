from colorama import Fore, Style, init

init(autoreset=True)


def pprint(text, color_name="white") -> None:
    """
    Prints colored text to the console.

    This function prints the given text in the specified color using the colorama library.
    If the color name is invalid or not recognized, it defaults to the standard console color.

    Args:
        text (str): The text to be printed.
        color_name (str): The name of the color to apply to the text. Accepted values include:
            'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white', 'reset'.

    Returns:
        None
    """
    colors = {
        "black": Fore.BLACK,
        "red": Fore.RED,
        "green": Fore.GREEN,
        "yellow": Fore.YELLOW,
        "blue": Fore.BLUE,
        "magenta": Fore.MAGENTA,
        "cyan": Fore.CYAN,
        "white": Fore.WHITE,
        "reset": Fore.RESET,
    }

    color = colors.get(color_name.lower(), Fore.RESET)
    print(color + text + Style.RESET_ALL)


def throw(message="Exiting.") -> None:
    """
    Exits the program with an optional message.

    This function prints the provided message and then raises a SystemExit exception,
    effectively terminating the program.

    Args:
        message (str): The message to display before exiting. Defaults to "Exiting.".

    Raises:
        SystemExit: Terminates the program execution.
    """
    pprint(message, 'red')
    raise SystemExit()
