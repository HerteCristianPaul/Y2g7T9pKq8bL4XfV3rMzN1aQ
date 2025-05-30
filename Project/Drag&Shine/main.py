from helper import *
import numpy as np
import cv2

IMAGE_FILENAME = "parrot.jpg"
# IMAGE_FILENAME = "parrot_640.jpg"
# IMAGE_FILENAME = "parrot_800.jpg"

BUTTON_WIDTH = 150
BUTTON_HEIGHT = 50
PADDING_TOP = 60

original_img = None
modified_img = None
canvas_img = None
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


def draw_canvas(image: np.ndarray) -> np.ndarray:
    """
    Create a canvas with extra padding on top, draw a centered Save button,
    and place the given image below the padding.

    Args:
        image (np.ndarray): Input image as a NumPy array (height x width x channels).

    Returns:
        np.ndarray: The resulting canvas image including the padding and Save button.
    """
    h, w, c = image.shape
    canvas = np.ones((h + PADDING_TOP, w, c), dtype=np.uint8) * 255

    canvas[PADDING_TOP:, :, :] = image

    x_center = w // 2
    button_x1 = x_center - BUTTON_WIDTH // 2
    button_y1 = 5
    button_x2 = button_x1 + BUTTON_WIDTH
    button_y2 = button_y1 + BUTTON_HEIGHT

    cv2.rectangle(canvas, (button_x1, button_y1), (button_x2, button_y2), (50, 200, 50), -1)

    text = "Save"
    font = cv2.FONT_HERSHEY_SIMPLEX
    font_scale = 1
    thickness = 2

    text_size, _ = cv2.getTextSize(text, font, font_scale, thickness)
    text_width, text_height = text_size

    text_x = button_x1 + (BUTTON_WIDTH - text_width) // 2
    text_y = button_y1 + (BUTTON_HEIGHT + text_height) // 2

    cv2.putText(canvas, text, (text_x, text_y), font, font_scale, (255, 255, 255), thickness)

    return canvas


def on_mouse(event: int, x: int, y: int, flags: int, param: any) -> None:
    """
    Mouse callback function to handle user interactions.

    - On left button down:
        * If click is inside the Save button, save the current modified image.
        * Otherwise, start tracking mouse drag for brightness/contrast adjustment.
    - On mouse move with left button pressed:
        * Adjust brightness and contrast of the original image based on drag distance.
        * Update the displayed image canvas accordingly.

    Args:
        event (int): The mouse event type (e.g., left button down, mouse move).
        x (int): Current x-coordinate of the mouse.
        y (int): Current y-coordinate of the mouse.
        flags (int): Flags indicating mouse button states.
        param (any): Additional parameters (unused).
    """
    global start_x, start_y, modified_img, delta_x, delta_y, canvas_img

    if event == cv2.EVENT_LBUTTONDOWN:
        if is_inside_button(x, y, canvas_img.shape):
            img_save("modified_" + IMAGE_FILENAME)
            return
        start_x, start_y = x, y
        return

    if event == cv2.EVENT_MOUSEMOVE and flags & cv2.EVENT_FLAG_LBUTTON:
        delta_x = x - start_x
        delta_y = y - start_y

        bright_val = max(min(delta_x * 0.5, 255), -255)
        contrast_factor = max(min(1 + delta_y * 0.005, 3.0), 0.1)

        modified_img = adjust_pixels(original_img, bright_val, contrast_factor)
        canvas_img = draw_canvas(modified_img)
        cv2.imshow("Modified", canvas_img)


def is_inside_button(x, y, canvas_shape):
    """
    Check if the given (x, y) coordinate lies within the Save button area on the canvas.

    Args:
        x (int): X-coordinate of the point to check.
        y (int): Y-coordinate of the point to check.
        canvas_shape (tuple): Shape of the canvas image (height, width, channels).

    Returns:
        bool: True if the point is inside the Save button area, False otherwise.
    """
    h, w, _ = canvas_shape
    x_center = w // 2
    button_x1 = x_center - BUTTON_WIDTH // 2
    button_y1 = 5
    button_x2 = button_x1 + BUTTON_WIDTH
    button_y2 = button_y1 + BUTTON_HEIGHT
    return button_x1 <= x <= button_x2 and button_y1 <= y <= button_y2


def img_read(path: str) -> np.ndarray:
    """
    Load an image from the specified file path using OpenCV.

    Args:
        path (str): Path to the image file.

    Returns:
        np.ndarray: Loaded image as a NumPy array.

    Raises:
        SystemExit: If the image cannot be loaded or an unexpected error occurs.
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
    Save the current modified image to a file.

    Args:
        img_name (str): Filename for saving the image.

    Raises:
        SystemExit: If no modified image exists or saving fails.
    """
    try:
        if modified_img is not None:
            success = cv2.imwrite(img_name, modified_img)
            if not success:
                throw(f"Failed to save the image as {img_name}.")
            pprint(f"Image saved as {img_name}.")
        else:
            throw("There is no canvas image to save.")
    except Exception as e:
        throw(f"Unexpected Error saving the image: {e}")


if __name__ == "__main__":
    original_img = img_read(IMAGE_FILENAME)
    modified_img = original_img.copy()

    canvas_img = draw_canvas(modified_img)
    cv2.namedWindow('Modified')
    cv2.setMouseCallback("Modified", on_mouse)
    cv2.imshow("Modified", canvas_img)

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

