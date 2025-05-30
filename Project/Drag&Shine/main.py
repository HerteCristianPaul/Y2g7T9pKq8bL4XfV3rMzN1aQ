from helper import *
import numpy as np
import cv2

IMAGE_FILENAME = "parrot.jpg"
# IMAGE_FILENAME = "parrot_640.jpg"
# IMAGE_FILENAME = "parrot_800.jpg"
original_img = None
modified_img = None
start_x, start_y = None, None
delta_x, delta_y = 0, 0


def adjust_pixels(img: np.ndarray, brightness: float, contrast: float) -> np.ndarray:
    """
    Adjust the brightness and contrast of an image pixel-by-pixel.

    Args:
        img (np.ndarray): Input image as a NumPy array (height x width x channels).
        brightness (float): Value to add to each pixel's brightness.
        contrast (float): Contrast scaling factor (1.0 means no change).

    Returns:
        np.ndarray: The brightness and contrast adjusted image as a NumPy array
                    with the same shape and dtype uint8.

    Raises:
        SystemExit: If an error occurs during pixel processing.
    """
    try:
        h, w, c = img.shape
        matrix = np.zeros_like(img)

        for i in range(h):
            for j in range(w):
                pixel = img[i, j].astype(np.float32)
                pixel += brightness
                pixel = (pixel - 128) * contrast + 128
                pixel = np.clip(pixel, 0, 255)
                matrix[i, j] = pixel.astype(np.uint8)

        return matrix
    except Exception as e:
        throw(f"Error processing pixels: {e}")


def on_mouse(event: int, x: int, y: int, flags: int, param: any) -> None:
    """
    Mouse callback to adjust image brightness and contrast by dragging.

    Left mouse button drag right/left adjusts brightness.
    Drag up/down adjusts contrast.

    Args:
        event: The mouse event type.
        x: The current x coordinate of the mouse.
        y: The current y coordinate of the mouse.
        flags: Flags indicating which mouse buttons are pressed.
        param: Additional parameters.
    """
    global start_x, start_y, modified_img, delta_x, delta_y

    if event == cv2.EVENT_LBUTTONDOWN:
        start_x, start_y = x, y
        return

    if event == cv2.EVENT_MOUSEMOVE and flags & cv2.EVENT_FLAG_LBUTTON:
        delta_x = x - start_x
        delta_y = y - start_y

        bright_val = max(min(delta_x * 0.5, 255), -255)
        contrast_factor = max(min(1 + delta_y * 0.005, 3.0), 0.1)

        modified_img = adjust_pixels(original_img, bright_val, contrast_factor)
        cv2.imshow("Modified", modified_img)


def img_read(path: str) -> np.ndarray:
    """
    Loads an image from the specified file path.

    This function attempts to load an image using OpenCV. If the image cannot be loaded,
    it raises a custom exception through the 'throw' function.

    Args:
        path (str): The file path of the image to load.

    Returns:
        np.ndarray: The loaded image as a NumPy array.

    Raises:
        SystemExit: If the image cannot be loaded, the program exits.
    """
    try:
        img = cv2.imread(path)
        if img is None:
            throw(f"The image at '{path}' could not be loaded.")

        return img
    except Exception as e:
        throw(f"Unexpected Error reading the image: {e}")


def img_save(img_name: str) -> None:
    """
    Saves the modified image to a file.

    If there is a modified image, this function saves it under the specified filename.
    If no modified image exists, it notifies the user.
    If an error occurs during saving, it exits the program with an error message.

    Args:
        img_name (str): The filename to save the modified image as.

    Returns:
        None
    """
    try:
        if modified_img is not None:
            success = cv2.imwrite(img_name, modified_img)
            if not success:
                throw(f"Failed to save the image as {img_name}.")
            pprint(f"Image saved as {img_name}.")
        else:
            throw("There is no modified image to save.")
    except Exception as e:
        throw(f"Unexpected Error saving the image: {e}")


if __name__ == "__main__":
    original_img = img_read(IMAGE_FILENAME)
    modified_img = original_img.copy()

    cv2.namedWindow('Modified')
    cv2.setMouseCallback("Modified", on_mouse)
    cv2.imshow("Modified", original_img)

    while True:
        try:
            key = cv2.waitKey(1) & 0xFF
            if key == ord('s'):
                img_save('modified_' + IMAGE_FILENAME)
            elif key == 27:
                break
        except Exception as ex:
            throw(f"Error in the main loop: {ex}")

    cv2.destroyAllWindows()

