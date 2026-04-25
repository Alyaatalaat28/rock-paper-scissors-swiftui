import Foundation

enum RoundResult {
    case win
    case lose
    case draw

    var emoji: String {
        switch self {
        case .win:  return "🎉"
        case .lose: return "😔"
        case .draw: return "🤝"
        }
    }

    var message: String {
        switch self {
        case .win:  return "You Win!"
        case .lose: return "You Lose!"
        case .draw: return "It's a Draw!"
        }
    }

    var color: String {
        switch self {
        case .win:  return "green"
        case .lose: return "red"
        case .draw: return "orange"
        }
    }
}
