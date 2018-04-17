import UIKit
import CoreData

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtNombre.delegate = self
    }

    @IBAction func btnGuardar(_ sender: UIButton) {
        let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let imagenEntity = NSEntityDescription.entity(forEntityName: "Imagenes", in: contexto)
        let newImage = NSManagedObject(entity: imagenEntity!, insertInto: contexto)
        newImage.setValue(txtNombre.text, forKey: "nombre")
        
        if let imagen = imagen.image {
            let imagenFinal = UIImagePNGRepresentation(imagen) as NSData?
            newImage.setValue(imagenFinal, forKey: "imagen")
        }
        
        do {
            try contexto.save()
            print("guardado")
        } catch let error as Error {
            print(error)
        }
    }
    
    @IBAction func btnCamara(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnGaleria(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagenTomada = info[UIImagePickerControllerEditedImage] as? UIImage
        imagen.image = imagenTomada
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
     // Tecla return pulsada
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
     // Cuando se toca en la vista
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

