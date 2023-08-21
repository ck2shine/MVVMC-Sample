import UIKit

class TestingRootViewController: UIViewController {
    override func loadView() {
        let label = UILabel()
        label.text = "Running Unit Tests..."
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemYellow

        view = label
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
