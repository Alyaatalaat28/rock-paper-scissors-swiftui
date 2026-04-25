import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.red.opacity(0.8), Color.orange.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {

                Spacer()

                // ── Result ──
                VStack(spacing: 16) {
                    Text(viewModel.finalResult.emoji)
                        .font(.system(size: 80))

                    Text(viewModel.finalResult.message)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)

                    Text("Game Over")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))
                }

                // ── Score Card ──
                VStack(spacing: 0) {
                    ResultRow(
                        icon: "person.fill",
                        label: "Your Score",
                        value: "\(viewModel.playerScore)"
                    )
                    Divider().overlay(Color.gray.opacity(0.2))

                    ResultRow(
                        icon: "desktopcomputer",
                        label: "CPU Score",
                        value: "\(viewModel.computerScore)"
                    )
                    Divider().overlay(Color.gray.opacity(0.2))

                    ResultRow(
                        icon: "flag.checkered",
                        label: "Rounds Played",
                        value: "\(viewModel.totalRounds)"
                    )
                    Divider().overlay(Color.gray.opacity(0.2))

                    ResultRow(
                        icon: "trophy.fill",
                        label: "Best Score",
                        value: "\(viewModel.bestScore)",
                        highlight: true
                    )
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 10)
                .padding(.horizontal, 32)

                // ── Buttons ──
                VStack(spacing: 12) {
                    Button {
                        viewModel.restartGame()
                        dismiss()
                        dismiss()
                    } label: {
                        Text("Play Again 🎮")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
                    }

                    Button {
                        dismiss()
                        dismiss()
                    } label: {
                        Text("Change Rounds")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 32)

                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

// ── Result Row Component ──
struct ResultRow: View {
    let icon: String
    let label: String
    let value: String
    var highlight: Bool = false

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(highlight ? .yellow : .red)
                .frame(width: 24)
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundColor(highlight ? .red : .primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}
