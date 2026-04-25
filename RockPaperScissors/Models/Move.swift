import Foundation

enum Move: String, CaseIterable {
    case rock     = "Rock"
    case paper    = "Paper"
    case scissors = "Scissors"

    // Emoji for each move
    var emoji: String {
        switch self {
        case .rock:     return "✊"
        case .paper:    return "🖐️"
        case .scissors: return "✌️"
        }
    }

    // What this move beats
    var beats: Move {
        switch self {
        case .rock:     return .scissors
        case .paper:    return .rock
        case .scissors: return .paper
        }
    }

    // Random computer move
    static var random: Move {
        Move.allCases.randomElement()!
    }

    // Check result against opponent
    func result(against opponent: Move) -> RoundResult {
        if self == opponent        { return .draw }
        if self.beats == opponent  { return .win  }
        return .lose
    }
}
