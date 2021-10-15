import UIKit

class TaskViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{


    

    
    @IBOutlet var tableView:UITableView!

    var updateDelete:(() -> Void)?
    var list:List?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title=list?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(addTask))

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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at:indexPath, animated: true)
    //        let vc = storyboard?.instantiateViewController(withIdentifier: "task") as! TaskViewController
    //        vc.title="Task"
    //        vc.list = data[indexPath.row]
    //        vc.updateDelete = {
    //            DispatchQueue.main.async{
    //                self.updateDelete()
    //            }
    //        }
    //        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.tasks.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         cell.textLabel?.text = list?.tasks[indexPath.row]
        return cell
    }

}

