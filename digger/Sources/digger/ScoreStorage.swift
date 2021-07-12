import Foundation

class ScoreStorage {
    static func createInStorage(_ mem: Scores) {
        do {
            try ScoreStorage.writeToStorage(mem)
        } catch {
            print("Could not create storage!")
        }
    }

    static func writeToStorage(_ mem: Scores) -> Bool {
        let outFilename: String = "digger.sco"
        let fileManager = FileManager.default
        fileManager.createFile(atPath: outFilename, contents: Data(" ".utf8), attributes: nil)
        let scoreinit = mem.scoreinit
        let scorehigh = mem.scorehigh
        if let bw = FileHandle(forWritingAtPath: outFilename) {
            for i in 0 ..< 10 {
                bw.write(scoreinit[i + 1].data(using: .utf8)!)
                bw.write("\n".data(using: .utf8)!)
                bw.write(String(scorehigh[i + 2]).data(using: .utf8)!)
                bw.write("\n".data(using: .utf8)!)
            }
            bw.closeFile()
            return true
        } else {
            return false
        }
    }

    private static func getScoreFile() -> String? {
        let fileName = "digger.sco"
        let bundle = Bundle.main.path(forResource: fileName, ofType: "txt")
        return bundle
    }

    static func readFromStorage(_ mem: Scores) -> Bool {
        if let path = ScoreStorage.getScoreFile() {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                var sc = [ScoreTuple](repeating: ScoreTuple("...", 0), count: 10)
                var i = 0
                while i < 20 {
                    let name = lines[i]
                    i += 1
                    let score = Int(lines[i])
                    i += 1
                    let scoreUnp = score!
                    sc[i] = ScoreTuple(name, scoreUnp)
                }
                mem.scores = sc
                return true
            } catch {
                print(error)
                return false
            }
        }
        return false
    }
}
