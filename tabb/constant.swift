//
//  constant.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 10. 21..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import Foundation
import UIKit

//var serverURL : String = "http://192.168.1.203:8380/app/api/";
var serverURL : String = "http://ekayworks.synology.me:8380/app/api/";
//var serverURL : String = "http://192.168.1.215:8080/app/api/";
var imageURL : String = "";

var pref = NSUserDefaults.standardUserDefaults()
var screen: CGRect = UIScreen.mainScreen().bounds
let windowView = UIApplication.sharedApplication().keyWindow!

var starOff = UIImage(named: "icon_star_off")
var starOn = UIImage(named: "icon_star_on")
var starHalf = UIImage(named: "icon_star_half")

func gradeVisible(starList : Array<UIImageView>, grade : Double) {
    if(grade == 5) {
        for(var x=0; x<starList.count; x++) {
            starList[x].image = starOn
        }
    } else {
        
        var index = 0
        for(var x=0; x<(Int.init(grade * 10) / 10); x++) {
            starList[x].image = starOn
            ++index
        }
        
        let restValue = Int.init(grade * 10) % 10
        print("restValue : \(restValue)")
        if(restValue >= 5) {
            starList[index].image = starHalf
        }
    }
}

var userId : Double!
var userProfileImage = UIImage()

var customPop : CustomPopUp = CustomPopUp(nibName: "PopupView", bundle: nil)
var serviceCall : ServiceCallViewController = ServiceCallViewController(nibName: "PopupView", bundle: nil)

//서비스콜 목록 리스트
var serviceCallList : NSDictionary = NSDictionary()

//Join Tabb
var birthDay : String = String() // server 전송할 생일
var birthDoubleValue : Double = 0
var tempBitrhDay : String = String()

//scan restaurant Check
var scanChk : Bool = false

//인스타인지 레스토랑인지 구분해야된다.
var orderMethodCheck = false

//레스토랑 1번만 서치해야된다.
var viewCount = 0

var restaurantImageBool : NSMutableArray = NSMutableArray() //이미 한번 이미지 로딩이 끝났으면 하지 않는다.
var restaurantTable : UITableView!
//var restaurantList: NSArray! = NSArray()
var restaurantList: NSMutableArray = NSMutableArray()
var checkInRestaurantList: NSMutableArray = NSMutableArray()
var isShowResMenu : Bool!
var isShowInstaMenu : Bool!
var resView : SearchListView!
var instaView : SearchInstaView!
var restaurantType : String!
var searchCheck : Bool = false //레스토랑 검색시, 검색화면에서 검색버튼을 누르면 활성화.
var searchName : String! //레스토랑 검색시, 검색어 이름.
var searchType : String!
var restaurantLocation : String!
var foodType : String!

var dishViewBackFlag : Bool = false

//체크인시 필요한 항목들.
var checkinId : Double = 0// 체크인 ID
var checkinChk : Bool = false
var toCheckIdIds : NSMutableArray = NSMutableArray()
var shareRequestId : Double! // 공유 요청 Id


var likeChk : Bool = false
var restaurantView : NSDictionary! // 레스토랑 상세뷰
var restaurantId : Double! //레스토랑 Id
var categories : NSArray!
var categoryId : Double! //카테고리 Id
var menuList : NSArray = NSArray() //레스토랑 메뉴 리스트
var menuListGoCart = false
var foodId : Double! //음식 Id
var foodViewData : NSDictionary! // 음식 상세뷰
var foodViewGoCart = false
var options : NSMutableDictionary = NSMutableDictionary()
var toppingsList : NSMutableArray = NSMutableArray()
var optionsList : NSMutableArray = NSMutableArray()
var excludesList : NSMutableArray = NSMutableArray()
//리뷰 리스트
var reviewList : NSArray = NSArray()

//Cart
var cartId : Double!
var members : NSArray = NSArray()
var cartItems : NSArray = NSArray()
var checkItemId : Double! // MyCart의 개별 아이템 Id

var imageList : NSMutableArray = NSMutableArray()   //프로필 이미지
var grayImageList : NSMutableArray = NSMutableArray()   //프로필 그레이 이미지
var imageVersion : NSMutableArray = NSMutableArray()    //프로필 이미지 버전
var cartImageList : NSMutableArray = NSMutableArray()   //카트 이미지 리스트
var paymentImageList : NSMutableArray = NSMutableArray()    //결제 목록 아이템 이미지 리스트
var shareImageList : NSMutableArray = NSMutableArray()   //결제 목록 아이템 중에 스플릿된 아이템 이미지

//체크인이 되어있지 않을 시에 처리를 해주어야 한다.
var notCheck = false

//Payment
var checkId : Double!
var paymentItems : NSArray = NSArray()
var shareRequestItems : NSArray = NSArray()
var tagNum : Int!   //개별 스플릿 아이템 정보 가져올때 사용
var splitItems : NSArray = NSArray()
var splitUserName : String!
var splitChk : Bool = false
var paymentCheckData : NSDictionary = NSDictionary()
var paymentChk : Bool = false

//payment billId
var billId : Double!

//다른사람의 전체 빌을 보게 될 경우, 다른 사람 checkinId가 필요하다
var otherIndex : Int!
var otherCheckinId : Double!

//스플릿을 한번이라도 한 경우에는 상대방이 거절이나 승인을 하기 전까지는 다른 액션이 불가능하다.
var splitAttemptChk : Bool = false
//상대방의 전체 빌을 가져올 경우,
var splitTakeBillChk = false
//내 빌을 상대방에게 줄 경우
var splitSendBillChk = false
//전체 빌을 보낼때 스플릿 하는 음식 갯수
var splitSendBillFoodCount = 0

//checkItem Post
var foodReviewData : NSDictionary = NSDictionary()
//evaluate food & service
var evaluateFoodsItems : NSArray = NSArray()
var evaluateRestaurantItems : NSArray = NSArray()

//Account
var profile : NSDictionary = NSDictionary()
var profileImage : UIImage = UIImage()
var profileChangeCheck = false
var modifyAddress1 = ""
var modifyAddress2 = ""
var modifyAddress3 = ""
var modifyAddress4 = ""
var modifyAddress5 = ""
var modifyAddress6 = ""

//Account - History
var historyGoChk = false
var historyData : NSDictionary = NSDictionary()
var searchYear : Int!
var searchMonth : Int!
var historyDetailData : NSDictionary = NSDictionary()

//Account - Quick Pay
var guickPayData : NSDictionary = NSDictionary()

//Account - sign out
var signOutFlag = false

/*
Define Fonts
*/
var lato : String = "Lato-Regular"
var latoBold : String = "Lato-Bold"
var latoThin : String = "Lato-Thin"
var roboto : String = "Roboto-Regular"
var robotoBold : String = "Roboto-Bold"


func viewBox(view: UIView!, value: UInt, border: CGFloat, radius: CGFloat) {
    view.layer.borderWidth = border // check that textview stays within view
    view.layer.borderColor = UIColorFromRGB(value).CGColor
    //view.layer.backgroundColor = UIColorFromRGB(value).CGColor
    view.layer.cornerRadius = radius
}

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

/*
Define UIColor from hex value

@param rgbValue - hex color value
@param alpha - transparency level
*/
func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

var container: UIView = UIView()
var loadingView: UIView = UIView()
var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

/*
Show customized activity indicator,
actually add activity indicator to passing view

@param uiView - add activity indicator to this view
*/
func showActivityIndicator(uiView: UIView) {
    container.frame = uiView.frame
    container.center = uiView.center
    container.backgroundColor = UIColorFromHex(0x000000, alpha: 0.5)
    
    loadingView.frame = CGRectMake(0, 0, (screen.size.width * 80) / 414, (screen.size.height * 80) / 736)
    loadingView.center = uiView.center
    loadingView.backgroundColor = UIColorFromHex(0x444444, alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame = CGRectMake(0, 0, (screen.size.width * 40) / 414, (screen.size.height * 40) / 736)
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
    activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
    
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    uiView.addSubview(container)
    activityIndicator.startAnimating()
}

/*
Hide activity indicator
Actually remove activity indicator from its super view

@param uiView - remove activity indicator from this view
*/
func hideActivityIndicator(uiView: UIView) {
    activityIndicator.stopAnimating()
    container.removeFromSuperview()
    
}

func isValidEmail(email:String) -> Bool {
    // println("validate calendar: \(testStr)")
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(email)
}

// MARK: KeyChain
func saveKeyChainWithString(string: NSString, key: NSString) -> Bool {
    return KeychainController.setString(string as String, forKey: key as String)
}
func loadKeyChainString(key: NSString) -> NSString? {
    return KeychainController.stringForKey(key as String)
}
func saveKeyChainWithObject(object: NSCoding, key: NSString) -> Bool {
    return KeychainController.setObject(object, forKey: key as String)
}
func loadKeyChainObject(key: NSString) -> NSCoding? {
    return KeychainController.objectForKey(key as String)
}
func resetKeyChainData() {
    KeychainController.resetAllData()
}

func imageResize (image:UIImage, sizeChange:CGSize)-> UIImage{
    
    let hasAlpha = true
    let scale: CGFloat = 0.0 // Use scale factor of main screen
    
    UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
    image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    return scaledImage
}

//뷰 이동을 위한 flag
var makeOrderFlag = false

//컨트롤러 세팅
var browse : BrowseController!
var payment: PaymentController!
var myCart : MyCartController!
var menuListController : MenuListController!
var dishView : DishViewController!
var paymentDetail : PaymentDetailController!
var profileModify : ProfileModifyController!


//이미 다운로드 된 이미지가 변경이 되면 다시 다운로드를 받아야된다.
var profileCounts : NSMutableArray = NSMutableArray()


extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

let someDoubleFormat = ".3" // 가격표시를 위해서, 쿠웨이트 가격 표시는 소수점 아래 3자리까지 표시되어야 한다.
