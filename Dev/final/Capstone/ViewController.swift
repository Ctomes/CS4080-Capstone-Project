
import UIKit


class ViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var slider: UISlider!

  @IBOutlet weak var gammaLabel: UILabel!
  @IBOutlet weak var gammaSlider: UISlider!
  
  @IBOutlet weak var hueLabel: UILabel!
  @IBOutlet weak var hueSlider: UISlider!
  
  @IBOutlet weak var vibranceLabel: UILabel!
  
  @IBOutlet weak var vibranceSlider: UISlider!
  @IBOutlet weak var sharpnessLabel: UILabel!
  
  @IBOutlet weak var sharpnessSlider: UISlider!
  
  @IBOutlet weak var saveButton: UIButton!
  
  let context = CIContext(options: nil)
  let filter = CIFilter(name: "CISepiaTone") ?? CIFilter()
  var orientation = UIImage.Orientation.up

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let uiImage = UIImage(named: "image") else { return }
    let ciImage = CIImage(image: uiImage)
    filter.setValue(ciImage, forKey: kCIInputImageKey)
    filter.setValue(0, forKey: kCIInputIntensityKey)
  }

  @IBAction func sliderValueChanged(_ slider: UISlider) {
  }
  @IBAction func gammaValueChanged(_ sender: Any) {
    gammaLabel.text = String(format: "Gamma:  %.2f", gammaSlider.value)
    applyFilters()
  }
  @IBAction func hueValueChanged(_ sender: Any) {
    hueLabel.text = String(format: "Hue:  %.2f", hueSlider.value)
    applyFilters()
  }
  @IBAction func vibranceValueChanged(_ sender: Any) {
    vibranceLabel.text = String(format: "Vibrance:  %.2f", vibranceSlider.value)
    applyFilters()
  }
  @IBAction func sharpnessValueChanged(_ sender: Any) {
    sharpnessLabel.text = String(format: "Sharpness:  %.1f", sharpnessSlider.value)
    applyFilters()
  }
  @IBAction func saveButtonPressed(_ sender: Any) {
    print("Button Pressed")
    
    UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
    saveButton.tintColor = UIColor.systemBackground
    saveButton.setTitle("Saved", for: .normal)
    
  }
  
  @IBAction func loadPhoto() {
    let picker = UIImagePickerController()
    picker.delegate = self
    present(picker, animated: true)
  }
}

extension ViewController {
  func applySepiaFilter(intensity: Float) {
    
  }
  func applyFilters()
  {
    //gamma filter
    let gamma = CIFilter(name: "CIGammaAdjust")
    gamma?.setValue(filter.outputImage, forKey: kCIInputImageKey)
    gamma?.setValue(1-gammaSlider.value, forKey: "inputPower")
    
    //sharpness filter
    let sharp = CIFilter(name: "CISharpenLuminance")
    sharp?.setValue(gamma!.outputImage, forKey: kCIInputImageKey)
    sharp?.setValue(sharpnessSlider.value, forKey: kCIInputSharpnessKey)
    
    //vibrance filter
    let vibr = CIFilter(name: "CIVibrance")
    vibr?.setValue(sharp!.outputImage, forKey: kCIInputImageKey)
    vibr?.setValue(vibranceSlider.value, forKey: "inputAmount")
    
    //hue filter
    let hue = CIFilter(name: "CIVibrance")
    hue?.setValue(vibr!.outputImage, forKey: kCIInputImageKey)
    hue?.setValue(hueSlider.value, forKey: "inputAmount")
    
    
    guard let outputImage = hue?.outputImage else { return }
    guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
    imageView.image = UIImage(cgImage: cgImage, scale: 1, orientation: orientation)
    return
    
  }

  func applyOldPhotoFilter(intensity: Float) {
    
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func resetValues() {
    gammaSlider.value = 0.0
    gammaLabel.text = "Gamma"
    vibranceSlider.value = 0.0
    vibranceLabel.text = "Vibrance"
    hueSlider.value = 0.0
    hueLabel.text = "Hue"
    sharpnessSlider.value = 0.0
    sharpnessLabel.text = "Sharpness"
    
  }
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      
      guard let selectedImage = info[.originalImage] as? UIImage else { return }
      
      let ciImage = CIImage(image: selectedImage)
      resetValues()
      filter.setValue(ciImage, forKey: kCIInputImageKey)
      orientation = selectedImage.imageOrientation
      applyFilters()
      
      dismiss(animated: true)
      saveButton.tintColor = UIColor.systemBlue
      saveButton.setTitle("Save", for: .normal)

  }
}
