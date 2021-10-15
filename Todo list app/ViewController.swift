import UIKit

class List: NSObject {

    var name: String
    var tasks: [String]

    init(name:String, tasks: [String]) {
        self.name = name
        self.tasks = tasks
    }
}

class ViewController: UIViewController {
    @IBOutlet var tableView:UITableView!
    var tasks = [String]()
    var data = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete All", style: .done, target: self, action: #selector(deleteAll))
        self.title="Tasks"
        tableView.delegate = self
        tableView.dataSource = self
       if !UserDefaults().bool(forKey: "setup"){
           UserDefaults().set(true,forKey:"setup")
           UserDefaults().set(0,forKey:"count")
        }
        data.append(List(name:"List 1",tasks: ["Task 1","Task 2"]))
        data.append(List(name:"List 2",tasks: ["Task 1","Task 2"]))
        updateTasks()
    }
    @objc func deleteAll(){
        tasks.removeAll()
        tableView.reloadData()
        UserDefaults().set(0,forKey:"count")
    }
    func updateTasks(){
        tasks.removeAll()
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        for x in 0..<count{
            if let task = UserDefaults().value(forKey:"task_\(x+1)")as? String{
                tasks.append(task)
            }
        }
        tableView.reloadData()
    }


    func updateDelete(){
   
        tasks.removeAll()
        var tempArray = [String]()
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        for x in 0..<count{
            if let task = UserDefaults().value(forKey:"task_\(x+1)")as? String {
                tempArray.append(task)
            }
    }
        print(tempArray)
        tasks = tempArray
        tableView.reloadData()
    }


    @IBAction func didTapdd(){
      
        UserDefaults().set(data, forKey: "dataList")
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        vc.title="New Task"
        vc.update = {
            DispatchQueue.main.async{
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTabDelete(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "task") as! TaskViewController
        vc.title="Task"
    
        navigationController?.pushViewController(vc, animated: true)
    }
}
  



extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "task") as! TaskViewController
        vc.title="Task"
        vc.list = data[indexPath.row]
        vc.updateDelete = {
            DispatchQueue.main.async{
                self.updateDelete()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
  
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].name
        return cell
    }
}
