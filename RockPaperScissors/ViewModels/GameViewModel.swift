import SwiftUI
import Combine

@MainActor
class GameViewModel: ObservableObject {

    // ── Published State ──
    @Published var playerScore: Int = 0
    @Published var computerScore: Int = 0
    @Published var currentRound: Int = 1
    @Published var totalRounds: Int = 5
    @Published var playerMove: Move? = nil
    @Published var computerMove: Move? = nil
    @Published var roundResult: RoundResult? = nil
    @Published var isRevealing: Bool = false
    @Published var isGameOver: Bool = false
    @Published var showResult: Bool = false

    // ── Best Score ──
    @AppStorage("rps_best_score") var bestScore: Int = 0

    // ── Computed ──
    var remainingRounds: Int { totalRounds - currentRound + 1 }

    var finalResult: RoundResult {
        if playerScore > computerScore { return .win  }
        if playerScore < computerScore { return .lose }
        return .draw
    }

    var scoreText: String { "\(playerScore) - \(computerScore)" }

    // ─────────────────────────────────────────
    // MARK: - Game Setup
    // ─────────────────────────────────────────

    func startGame(rounds: Int) {
        totalRounds   = rounds
        playerScore   = 0
        computerScore = 0
        currentRound  = 1
        playerMove    = nil
        computerMove  = nil
        roundResult   = nil
        isGameOver    = false
        showResult    = false
        isRevealing   = false
    }

    func restartGame() {
        startGame(rounds: totalRounds)
    }

    // ─────────────────────────────────────────
    // MARK: - Round Logic
    // ─────────────────────────────────────────

    func playerChose(_ move: Move) {
        guard !isRevealing else { return }
        guard !isGameOver  else { return }

        playerMove  = move
        isRevealing = true

        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)

            computerMove = .random

            let result = move.result(against: computerMove!)
            roundResult = result

            switch result {
            case .win:  playerScore   += 1
            case .lose: computerScore += 1
            case .draw: break
            }

            showResult  = true
            isRevealing = false

            try? await Task.sleep(nanoseconds: 1_200_000_000)

            if currentRound >= totalRounds {
                isGameOver = true
                saveBestScore()
            } else {
                currentRound += 1
                resetRound()
            }
        }
    }

    private func resetRound() {
        playerMove   = nil
        computerMove = nil
        roundResult  = nil
        showResult   = false
        isRevealing  = false
    }

    // ─────────────────────────────────────────
    // MARK: - Best Score
    // ─────────────────────────────────────────

    private func saveBestScore() {
        if playerScore > bestScore {
            bestScore = playerScore
        }
    }
}
