import UIKit
import Foundation

enum EncryptionMethod {
    case ENCODE
    case DECODE
}

var codificationInput: EncryptionMethod

var numberInput = 0

var rotor0 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var rotor0Array = Array(rotor0)
var rotorI = "BDFHJLCPRTXVZNYEIWGAKMUSQO"
var rotorII = "AJDKSIRUXBLHWTMCQGZNPYFVOE"
var rotorIII = "EKMFLGDQVZNTOWYHXUSPAIBRCJ"


var encodingRotors = [rotorI, rotorII, rotorIII]
var decodingRotors = [rotorIII, rotorII, rotorI]


@MainActor private func getFirstMessage(message: String, number: Int) -> String {
    var codeNumber = number
    var characters: [Character] = []
    
    for character in message {
        characters.append(character)
    }
            
    var firstLetterIndex: Int = 0
    var convertedMessage = ""
    var letter: Character
    var rotorIndex = message.startIndex
    
    // Get the index of the first letter of the message
    for index in rotor0Array {
        firstLetterIndex = characters.firstIndex(of: index) ?? 0
    }
    
    for character in message {
        if codeNumber >= 25 {
            codeNumber -= 25
            rotorIndex = rotor0.index(rotor0.startIndex, offsetBy: codeNumber)
        } else {
            rotorIndex = rotor0.index(rotor0.startIndex, offsetBy: (firstLetterIndex + codeNumber))
        }
        letter = rotor0[rotorIndex]
        convertedMessage.append(letter)
        codeNumber += 1
    }

//    print("convertedMessage: \(convertedMessage)")
    return convertedMessage
}

@MainActor private func getEncodedMessage(message: String, fromRotor rotor: String) -> String {
    var convertedMessage = ""
    var character: Character = "?"
    
    for letter in message {
        if let characterIndex = rotor0Array.firstIndex(of: letter) {
            let array = Array(rotor)
            character = array[characterIndex]
        }
        convertedMessage.append(character)
    }
        return convertedMessage
}

@MainActor private func getDecodedMessage(message: String, fromRotor rotor: String) -> String {
    var convertedMessage = ""
    var character: Character = "?"
    let rotorArray = Array(rotor)
    
    for letter in message {
        if let characterIndex = rotorArray.firstIndex(of: letter) {
            let array = Array(rotor)
            character = array[characterIndex]
        }
        convertedMessage.append(character)
    }
        return convertedMessage
}


@MainActor
private func encryption(message: String, method: EncryptionMethod, number: Int) -> String {
    var decodingMessage = getFirstMessage(message: message, number: number)
    if method == .ENCODE {
        for rotor in 0...encodingRotors.count - 1 {
            decodingMessage = getEncodedMessage(message: decodingMessage, fromRotor: encodingRotors[rotor])
        }
    } else {
        for rotor in 0...decodingRotors.count - 1 {
            decodingMessage = getDecodedMessage(message: decodingMessage, fromRotor: decodingRotors[rotor])
        }
    }
    
    return decodingMessage
}


//print(encryption(message: "AAA", method: .ENCODE, number: 4))
//print(encryption(message: "AAA", method: .ENCODE, number: 3))
//print(encryption(message: "AAA", method: .ENCODE, number: 23))
print(encryption(message: "AAA", method: .DECODE, number: 21))
print(encryption(message: "BHJ", method: .ENCODE, number: 21))
//print(encryption(message: "AAA", method: .ENCODE, number: 21))
//print(encryption(message: "AAA", method: .ENCODE, number: 42))
//print(encryption(message: "AAA", method: .ENCODE, number: 49))

//print(encryption(message: "ABC", method: .ENCODE, number: 4))


//print(getMessage(message: "EFG", fromRotor: rotorI))
//print(getMessage(message: "JLC", fromRotor: rotorII))
//print(getMessage(message: "BHD", fromRotor: rotorIII))

//print(encryption(message: "AAA", method: .ENCODE, number: 4))
