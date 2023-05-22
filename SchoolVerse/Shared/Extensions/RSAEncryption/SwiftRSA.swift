

//
//  SwiftRSA.swift
//  SwiftRSA
//
//  Created by Mars on 2019/7/29.
//  Copyright © 2019 Mars. All rights reserved.
//
import Foundation
import Security

/// `SwiftRSA` is just a namespace holding these static methods that are used in other types.
public class SwiftRSA {
  /// Extract base64 encoded key from a PEM formatted string.
  ///
  /// - parameter pemEncoded: PEM formatted string
  /// - returns: Base64 encoded key between `-----BEGIN` and `-----END`
  /// - throws: `SwiftRSAError.emptyPEMKey` if there is nothing between the `BEGIN` and `END` tags.
  static func base64String(pemEncoded pemString: String) throws -> String {
    let lines = pemString.components(separatedBy: "\n").filter { line in
      return !line.hasPrefix("-----BEGIN") && !line.hasPrefix("-----END")
    }
    
    guard lines.count != 0 else {
      throw SwiftRSAError.emptyPEMKey
    }
    
    return lines.joined(separator: "")
  }
  
  /// Create a key from a DER formatted data.
  ///
  /// - parameter derData: DER formatted data
  /// - parameter isPublic: `true` for public key, `false` for private key
  /// - returns: A `SecKey` object representing the key
  /// - throws: `SwiftRSAError.addKeyFailed(error:)` if creation failed.
  static func createKey(_ derData: Data, isPublic: Bool) throws -> SecKey {
    let keyClass = isPublic ? kSecAttrKeyClassPublic : kSecAttrKeyClassPrivate
    let sizeInBits = derData.count * 8
    let queryDict: [CFString: Any] = [
      kSecAttrKeyClass: keyClass,
      kSecAttrKeySizeInBits: sizeInBits,
      kSecAttrKeyType: kSecAttrKeyTypeRSA,
    ]
    
    var error: Unmanaged<CFError>?
    
    guard let key = SecKeyCreateWithData(derData as CFData, queryDict as CFDictionary, &error) else {
      throw SwiftRSAError.addKeyFailed(error: error?.takeRetainedValue())
    }
    
    return key
  }
  
  /// Get data contained within a `SecKey` object.
  ///
  /// - parameter `forKey`: The key to be unwrapped.
  /// - returns: The unwrapped `Data` within a key.
  /// - throws: `SwiftRSAError.externalRepresentationFailed` if failed.
  static func data(forKey reference: SecKey) throws -> Data {
    var error: Unmanaged<CFError>?
    let data = SecKeyCopyExternalRepresentation(reference, &error)
    
    guard let unwrapped = data as Data? else {
      throw SwiftRSAError.externalRepresentationFailed(error: error?.takeRetainedValue())
    }
    
    return unwrapped
  }
  
  /// Convert a DER formatted data to PEM.
  ///
  /// - parameter `derData`: DER formatted data.
  /// - parameter withPemType`: Text in the BEGIN and END tag.
  /// - returns: The PEM formatted key.
  static func format(der data: Data, withPemType pemType: String) -> String {
    func split(_ str: String, chunkOfLength: Int) -> [String] {
      return stride(from: 0, to: str.count, by: chunkOfLength).map { index -> String in
        let startIndex = str.index(str.startIndex, offsetBy: index)
        let endIndex = str.index(
          startIndex, offsetBy: chunkOfLength, limitedBy: str.endIndex) ?? str.endIndex
        
        return String(str[startIndex..<endIndex])
      }
    }
    
    let chunks = split(data.base64EncodedString(), chunkOfLength: 64)
    let pem = [
        "-----BEGIN \(pemType)-----",
        chunks.joined(separator: "\n"),
        "-----END \(pemType)-----"
    ]
    
    return pem.joined(separator: "\n")
  }
}


public class ClearText {
  // Data to be encrypted
  public let data: Data
  public var stringValue: String {
    return String(data: data, encoding: .utf8)!
  }
  
  public required init(data: Data) {
    self.data = data
  }
  
  public required init(string: String) {
    self.data = string.data(using: .utf8)!
  }
  
  /// Encrypt the clear text.
  ///
  /// - parameter `with`: Public key used for encryption.
  /// - parameter `by`: The RSA algorithm
  /// - Returns: The encrypted data.
  /// - Throws:
  ///   - `SwiftRSAError.clearTextTooLong` if the clear text is too long.
  ///   - `SwiftRSAError.encryptionFailed` if the encryption is failed.
  public func encrypted(with key: PublicKey, by algorithm: SecKeyAlgorithm) throws -> EncryptedText {
    /// 1. Is the `algorithm` supported by the platform
    guard SecKeyIsAlgorithmSupported(key.key, .encrypt, algorithm) else {
      throw SwiftRSAError.algorithmIsNotSupported
    }
    
    /// 2. Is the data short enough to be encrypted
    let maxCount = try ClearText.maxClearTextInLength(key.key, algorithm: algorithm)
    guard data.count <= maxCount else {
      throw SwiftRSAError.clearTextTooLong
    }
    
    /// 3. Make the encryption
    var error: Unmanaged<CFError>?
    guard let encrypted = SecKeyCreateEncryptedData(key.key, algorithm, data as CFData, &error) else {
      throw SwiftRSAError.encryptionFailed(error: error?.takeRetainedValue())
    }
    
    return EncryptedText(data: encrypted as Data, by: algorithm)
  }
  
  /// Get the overhead of each RSA algorithm in bytes in decimal.
  ///
  /// - parameter `of`: RSA algorithm
  /// - returns: The overhead in bytes in decimal
  /// - Throws: `SwiftRSAError.algorithmIsNotSupported` if the algorithm is not supported.
  /// - ToDo: Add PKCS v1.5 and no padding support
  static func _overhead(of algorithm: SecKeyAlgorithm) throws -> Int {
    func fomulaOfOaep(_ lengthInBits: Int) -> Int {
      return 2 * (lengthInBits / 8) + 2
    }
    
    switch algorithm {
    case .rsaEncryptionOAEPSHA1:
      return fomulaOfOaep(160)
    case .rsaEncryptionOAEPSHA224:
      return fomulaOfOaep(224)
    case .rsaEncryptionOAEPSHA256:
      return fomulaOfOaep(256)
    case .rsaEncryptionOAEPSHA384:
      return fomulaOfOaep(384)
    case .rsaEncryptionOAEPSHA512:
      return fomulaOfOaep(512)
    default:
      throw SwiftRSAError.algorithmIsNotSupported
    }
  }
  
  public static func maxClearTextInLength(_ key: SecKey, algorithm: SecKeyAlgorithm) throws -> Int {
    let keyLength = SecKeyGetBlockSize(key)
    let overhead = try ClearText._overhead(of: algorithm)
    
    return keyLength - overhead
  }
}

public class EncryptedText {
  // Data to be encrypted
  public let data: Data
  private let algo: SecKeyAlgorithm
  
  public required init(data: Data, by algo: SecKeyAlgorithm) {
    self.data = data
    self.algo = algo
  }
  
  public func decrypted(with key: PrivateKey) throws -> ClearText {
    var error: Unmanaged<CFError>?
    guard let decrypted = SecKeyCreateDecryptedData(key.key, algo, data as CFData, &error) else {
      throw SwiftRSAError.decryptionFailed(error: error?.takeRetainedValue())
    }
    
    return ClearText(data: decrypted as Data)
  }
}

public protocol Key: AnyObject {
  var key: SecKey { get }
  
  init(key: SecKey)
  init?(der data: Data)
  init?(pemEncoded pemString: String)
  init?(base64Encoded base64String: String)
  
  func data() throws -> Data
  func pemString() throws -> String
  func base64String() throws -> String
}

public extension Key {
  /// Create a key from base64 encoded key.
  ///
  /// - parameter base64Encoded
  /// - throws: `SwiftRSAError.invalidBase64String` if the `base64Encoded` cannot be base64 decoded.
  init?(base64Encoded base64String: String) {
    guard let decoded = Data(base64Encoded: base64String, options: [.ignoreUnknownCharacters]) else {
      return nil
    }
    
    self.init(der: decoded)
  }
  
  /// Create a key from a PEM formatted string.
  ///
  /// - parameter pemEncoded a PEM formatted string.
  /// - throws:
  ///   - `SwiftRSAError.invalidBase64String` if the `base64Encoded` cannot be base64 decoded.
  ///   - `SwiftRSAError.emptyPEMKey` if there is nothing between the `BEGIN` and `END` tags.
  init?(pemEncoded pemString: String) {
    do {
      let base64Decoded = try SwiftRSA.base64String(pemEncoded: pemString)
      self.init(base64Encoded: base64Decoded)
    }
    catch {
      return nil
    }
  }
  
  func data() throws -> Data {
    return try SwiftRSA.data(forKey: key)
  }
  
  func base64String() throws -> String {
    return try data().base64EncodedString()
  }
}

public class PrivateKey: Key {
  public let key: SecKey
  
  required public init(key: SecKey) {
    self.key = key
  }
  
  /// Initializer of `PrivateKey`
  ///
  /// - parameter data: DER formatted key data.
  /// - throws: `SwiftRSAError.addKeyFailed(error:)` if creation failed.
  /// - ToDo: We should get rid of the X.509 header if the key is a certificate.
  required public init?(der: Data) {
    do {
      self.key = try SwiftRSA.createKey(der, isPublic: false)
    }
    catch {
      return nil
    }
  }
  
  public func pemString() throws -> String {
    let data = try self.data()
    return SwiftRSA.format(der: data, withPemType: "RSA PRIVATE KEY")
  }
}

public class PublicKey: Key {
  public let key: SecKey
  
  required public init(key: SecKey) {
    self.key = key
  }
  
  /// Initializer of `PublicKey`
  ///
  /// - parameter derData: DER formatted key data.
  /// - throws: `SwiftRSAError.addKeyFailed(error:)` if creation failed.
  /// - ToDo: We should get rid of the X.509 header if the key is a certificate.
  required public init?(der data: Data) {
    do {
      self.key = try SwiftRSA.createKey(data, isPublic: true)
    }
    catch {
      return nil
    }
  }
  
  public func pemString() throws -> String {
    let data = try self.data()
    return SwiftRSA.format(der: data, withPemType: "RSA PUBLIC KEY")
  }
}

public enum SwiftRSAError: Error {
  case emptyPEMKey
  case invalidBase64String
  case algorithmIsNotSupported
  case clearTextTooLong
  case addKeyFailed(error: CFError?)
  case encryptionFailed(error: CFError?)
  case decryptionFailed(error: CFError?)
  case externalRepresentationFailed(error: CFError?)
}
