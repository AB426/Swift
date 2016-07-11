//
//  KeychainController.swift
//  KeyChainTest
//
//  Created by lhh3520 on 2015. 3. 31..
//  Copyright (c) 2015년 lhh3520. All rights reserved.
//

import UIKit
import Security

// 서비스 Identifiers
// 원하시는 값을 적으시면 됩니다.
let serviceIdentifier = "TABBKeychain"

// Keychain 관련 쿼리 키 값들
let kSecClassValue           = NSString(format: kSecClass)
let kSecAttrAccountValue     = NSString(format: kSecAttrAccount)
let kSecValueDataValue       = NSString(format: kSecValueData)
let kSecAttrGenericValue     = NSString(format: kSecAttrGeneric)
let kSecAttrServiceValue     = NSString(format: kSecAttrService)
let kSecAttrAccessValue      = NSString(format: kSecAttrAccessible)
let kSecMatchLimitValue      = NSString(format: kSecMatchLimit)
let kSecReturnDataValue      = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue   = NSString(format: kSecMatchLimitOne)
let kSecAttrAccessGroupValue = NSString(format: kSecAttrAccessGroup)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)


class KeychainController : NSObject
{
    private struct internalVars {
        static var _serviceName: String = ""
    }
    
    internal class var serviceName: String {
        get {
            if internalVars._serviceName.isEmpty {
                internalVars._serviceName = NSBundle.mainBundle().bundleIdentifier ?? serviceIdentifier
        }
        return internalVars._serviceName
        }
        set( newServiceName ) {
            internalVars._serviceName = newServiceName
        }
    }
    
    // MARK: Public Methods
    internal class func hasValueForKey(key: String) -> Bool {
        let keychainData: NSData? = self.dataForKey(key)
        if let data = keychainData {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: Getting Values
    internal class func stringForKey(keyName: String) -> String? {
        let keychainData: NSData? = self.dataForKey(keyName)
        var stringValue: String?
        if let data = keychainData {
            stringValue = NSString(data: data, encoding: NSUTF8StringEncoding) as String?
        }
        return stringValue
    }
    
    internal class func objectForKey(keyName: String) -> NSCoding? {
        let dataValue: NSData? = self.dataForKey(keyName)
        var objectValue: NSCoding?
        
        if let data = dataValue {
            objectValue = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSCoding?
        }
        return objectValue
    }
    
    internal class func dataForKey(keyName: String) -> NSData? {
        let keychainQueryDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        
        // Limit search results to one
        keychainQueryDictionary[kSecMatchLimitValue] = kSecMatchLimitOneValue
        
        // Specify we want NSData/CFData returned
        keychainQueryDictionary[kSecReturnDataValue] = kCFBooleanTrue
        
        /* 원래 이렇게 쓰는건데 제대로 동작을 안해서 일단 주석
        var dataTypeRef : Unmanaged<AnyObject>?
        let status = SecItemCopyMatching(keychainQueryDictionary, &dataTypeRef);
        if status == errSecSuccess {
        if let retrievedData = dataTypeRef?.takeRetainedValue() as? NSData {
            return retrievedData
        }
        return nil
        }
        else {
            return nil
        }
        */
        return KeyChainWrapper.ItemCopyMatching( keychainQueryDictionary as [NSObject : AnyObject] );
    }
    
    // MARK: Setting Values
    internal class func setString(value: String, forKey keyName: String) -> Bool {
        if let data = value.dataUsingEncoding(NSUTF8StringEncoding) {
            return self.setData(data, forKey: keyName)
        }
        else {
            return false
        }
    }
    
    internal class func setObject(value: NSCoding, forKey keyName: String) -> Bool {
        let data = NSKeyedArchiver.archivedDataWithRootObject(value)
        return self.setData(data, forKey: keyName)
    }
    
    internal class func setData(value: NSData, forKey keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        keychainQueryDictionary[kSecValueDataValue] = value
        
        SecItemDelete(keychainQueryDictionary as CFDictionaryRef)
        let status = SecItemAdd(keychainQueryDictionary as CFDictionaryRef, nil)
        if status == errSecSuccess {
            return true
        }
        else if status == errSecDuplicateItem {
            return self.updateData(value, forKey: keyName)
        }
        else {
            return false
        }
    }
    
    // MARK: Removing Values
    internal class func removeObjectForKey(keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        
        // Delete
        let status: OSStatus = SecItemDelete(keychainQueryDictionary)
        if status == errSecSuccess {
            return true
        }
        else {
            return false
        }
    }
    
    internal class func resetAllData() {
        self.deleteAllKeysForSecClass(kSecClassGenericPassword)
        self.deleteAllKeysForSecClass(kSecClassInternetPassword)
        self.deleteAllKeysForSecClass(kSecClassCertificate)
        self.deleteAllKeysForSecClass(kSecClassKey)
        self.deleteAllKeysForSecClass(kSecClassIdentity)
        self.deleteAllKeysForSecClass(kSecValueData)
    }
    
    private class func deleteAllKeysForSecClass(selClass: CFTypeRef) -> Bool {
        let dict = NSMutableDictionary()
        dict.setObject(selClass, forKey: kSecClassValue)
        
        let status : OSStatus = SecItemDelete(dict)
        if status == errSecSuccess {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: Private Methods
    private class func updateData(value: NSData, forKey keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        let updateDictionary = [kSecValueDataValue : value]
        
        // Update
        let status: OSStatus = SecItemUpdate(keychainQueryDictionary, updateDictionary)
        if status == errSecSuccess {
            return true
        }
        else {
            return false
        }
    }
    
    private class func setupKeychainQueryDictionaryForKey(keyName: String) -> NSMutableDictionary {
        let keychainQueryDictionary: NSMutableDictionary = [kSecClassValue : kSecClassGenericPassword]
        
        // Uniquely identify this keychain accessor
        keychainQueryDictionary[kSecAttrServiceValue] = KeychainController.serviceName
        
        // Uniquely identify the account who will be accessing the keychain
        let encodedIdentifier: NSData? = keyName.dataUsingEncoding(NSUTF8StringEncoding)
        
        // account key
        keychainQueryDictionary[kSecAttrAccountValue] = encodedIdentifier
        
        return keychainQueryDictionary
    }
}