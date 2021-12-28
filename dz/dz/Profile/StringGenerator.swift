import Foundation

class StringGenerator {
    var charArray = [
        // low
        "a", "b", "c", "d", "e", "f",
        "g", "h", "j", "k", "m", "n",
        "o", "p", "q", "r", "s", "t",
        "u", "v", "w", "x", "y", "z"
        // high
        //        "A", "B", "C", "D", "E", "F",
        //        "G", "H", "J", "K", "M", "N",
        //        "O", "P", "Q", "R", "S", "T",
        //        "U", "V", "W", "X", "Y", "Z"
        // numbers
        //        "0", "1", "2", "3", "4", "5",
        //        "6", "7", "8", "9",
        // symbols
        //        ".", ",", ">", "<", ":", ";",
        //        "(", ")", "{", "}", "#", "$",
        //        "%", "^", "*", "-", "_", "+",
        //        "-", "@", "±", "§", "`", "~",
        //        "=", "'", "/", "!", "?", "/",
        //        "№"
    ]
    
    func generateRandomString(_ length: Int) -> String {
        var string: String = ""
        for _ in 0...length {
            let randomChar = Int.random(in: 0...charArray.count - 1)
            string += charArray[randomChar]
        }
        return string
    }
}
