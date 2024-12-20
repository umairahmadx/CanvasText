# Canvas Text Editor

This project is a Flutter-based application that provides a simple canvas text editor. Users can add, move, and edit text elements on a canvas, with features such as font styling, size adjustments, and undo/redo functionality.

## Features

- **Add Text:** Add new text elements to the canvas.
- **Move Text:** Drag text elements to reposition them.
- **Edit Text:** Double-tap text elements to edit their content, style, font, and size.
- **Undo/Redo:** Supports undoing and redoing actions such as adding, moving, or editing text.

## Components

### 1. **HomeScreen**
The main screen of the application:
- Displays a canvas where text elements can be added and manipulated.
- Provides buttons for adding text and undo/redo actions.

### 2. **DialogShow**
A modal dialog for editing text properties:
- Allows users to change text content, font size, bold/italic/underline styling, and font family.
- Updates the text element on saving changes.

### 3. **ModalText Class**
A model representing individual text elements:
- Stores properties like text content, size, position, styling, and action type (add/move/property changes).
- Used to manage undo/redo functionality and state updates.

### 4. **Enums**
- **ActionType:** Represents the type of action performed (add, move, property change).
- **FontName:** Enum for available font families (Roboto, Montserrat, Mali).

## How It Works

1. **Adding Text:**
    - Click the "Add Text" button to add a new text element at a default position.

2. **Moving Text:**
    - Drag a text element to reposition it on the canvas.
    - Movement actions are recorded for undo/redo functionality.

3. **Editing Text:**
    - Double-tap a text element to open the editing dialog.
    - Modify text content, style, font size, and font family.

4. **Undo/Redo:**
    - Undo removes or reverts the last action.
    - Redo re-applies a reverted action.

## Project Structure

```
lib/
├── main.dart           # Entry point of the application
├── home_screen.dart    # Defines the main UI and canvas functionality
├── dialog_show.dart    # Implements the text editing dialog
├── modal_text.dart     # Defines the ModalText class and related enums
```

## Getting Started

### Prerequisites
- Flutter SDK installed
- A device or emulator to run the app

### Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd canvas-text-editor
   ```
3. Get the dependencies:
   ```bash
   flutter pub get
   ```

### Running the App
1. Run the application:
   ```bash
   flutter run
   ```
2. Select a target device or emulator.



## Contributing
Contributions are welcome! Feel free to open issues or submit pull requests.


---

Developed with ❤️ by Umair.

