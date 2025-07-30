import UIKit

class TaskComposeViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    var taskToEdit: Task?
    var onComposeTask: ((Task) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if let task = taskToEdit {
            titleField.text = task.title
            noteField.text = task.note
            datePicker.date = task.dueDate
            self.title = "Edit Task"
        }
    }

    @IBAction func didTapDoneButton(_ sender: Any) {
        guard let title = titleField.text, !title.isEmpty else {
            presentAlert(title: "Oops...", message: "Make sure to add a title!")
            return
        }

        var task: Task
        if var editTask = taskToEdit {
            editTask.title = title
            editTask.note = noteField.text
            editTask.dueDate = datePicker.date
            editTask.save() // ✅ Save updated task
            task = editTask
        } else {
            task = Task(title: title, note: noteField.text, dueDate: datePicker.date)
            task.save() // ✅ Save new task
        }

        onComposeTask?(task)
        dismiss(animated: true)
    }

    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }

    private func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
