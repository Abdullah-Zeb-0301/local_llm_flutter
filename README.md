# Gemma LLM Integration with Flutter

This project demonstrates the seamless integration of a local Language Model (LLM) into a Flutter application using the `gemma_flutter` library. The LLM is hosted entirely on the device, without relying on external servers or APIs. This approach allows for fast, secure, and offline AI-powered features.

## Features

- **Local LLM Integration:** Uses the Gemma LLM locally on the device.
- **Cross-Platform:** Works on Android, iOS, and Web (with GPU support).
- **Lightweight Model:** Utilizes the `Gemma 2b-it-gpu-int4` model for efficient performance.
- **Responsive UI:** Designed with Flutter's powerful UI framework for a seamless user experience.


## Installation

### Prerequisites

- Flutter SDK installed on your machine.
- An Android or iOS device with GPU support (for optimal performance).

### Setup

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/Abdullah-Zeb-0301/local_llm_flutter.git
    cd local_llm_flutter
    ```

2. **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3. **Run the App:**
   - For Android:
     ```bash
     flutter run
     ```
   - For iOS:
     ```bash
     flutter run --target-platform=ios
     ```
   - For Web (First include the "model.bin" file in your "web" directory):
     ```bash
     flutter run -d chrome
     ```

## Usage

This project uses the `Gemma 2b-it-gpu-int4` model from the Gemma LLM collection. The model is loaded and executed locally, providing fast AI responses directly within the app. To change the LLM model or configuration, update the model path in the `gemma_flutter` configuration file.

## Performance Considerations

- **GPU Requirement:** For best performance, especially in the web build, ensure the device has a GPU. The `gemma_flutter` library leverages Mediapipe, which significantly benefits from GPU acceleration.
- **Mobile vs. Desktop:** The response generation is noticeably faster on mobile devices equipped with a GPU compared to a non-GPU desktop environment.

## Future Enhancements

- **Model Upgrades:** Experimenting with more powerful Gemma LLMs for enhanced capabilities.
- **UI Improvements:** Refining the UI to make it even more interactive and user-friendly.
- **Offline Mode:** Further optimization to ensure fully offline operation across all platforms.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to enhance this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **Gemma LLM:** Special thanks to the Gemma LLM team for providing such an incredible library.
- **Flutter Community:** Thanks to the Flutter community for their ongoing support and contributions.

---

Happy Coding! 🚀
