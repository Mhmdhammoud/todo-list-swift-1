import UIKit

class TaskViewController: UIViewController {
    @IBOutlet var label:UILabel!
    var updateDelete:(() -> Void)?
    var task:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = task
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(showAlert))

    }
    
    @objc func showAlert(){
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {
            action in print("Dismissed")
        }))
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: {
            action in self.deleteTask()
        }))
        present(alert,animated: true)
    }
    func deleteTask(){
        guard let count = UserDefaults().value(forKey:"count")as? Int else{
            return
        }
         let newCount = count - 1;
        print(count)
        print(newCount)
        UserDefaults().setValue(newCount, forKey: "count")
        UserDefaults().setValue(nil, forKey: "task_\(count)")
        updateDelete?()
        navigationController?.popViewController(animated: true)
    }
}
