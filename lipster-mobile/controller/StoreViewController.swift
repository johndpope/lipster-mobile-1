import UIKit

class StoreViewController: UIViewController {
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeHours: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storePhoneNumber: UILabel!
    
    @IBOutlet weak var storeBranch: UILabel!
    
    @IBOutlet weak var titleNavigation: UINavigationItem!
    @IBOutlet weak var blackView: UIView!
    
    @IBOutlet weak var lipstickContainer: UIView!
    @IBOutlet weak var lipstickImage: UIImageView!
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    @IBOutlet weak var lipstickPrice: UILabel!
    
    var lipstick: Lipstick?
    var store: Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        if let lipstick = self.lipstick {
            lipstickBrand.text = lipstick.lipstickBrand
            lipstickName.text = lipstick.lipstickName
            lipstickImage.sd_setImage(with: URL(string: (lipstick.lipstickImage.first ?? "")), placeholderImage: UIImage(named: "nopic")!)
        } else {
            lipstickBrand.removeFromSuperview()
            lipstickName.removeFromSuperview()
            lipstickImage.removeFromSuperview()
            lipstickName.removeFromSuperview()
            lipstickContainer.removeFromSuperview()
        }
        
        lipstickPrice.text = "\(store!.price)"

        storeName.text = store!.name
        storeImageView.sd_setImage(with: URL(string: (store?.image)!), placeholderImage: UIImage(named: "nopic")!)
        storeHours.text = store!.hours
        storeAddress.text = store!.address
        storePhoneNumber.text = store?.phoneNumber
        storeBranch.text  = store?.branch
        
        storeAddress.sizeToFit()
        storeName.sizeToFit()
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        hero.dismissViewController()
    }
  
    
}
