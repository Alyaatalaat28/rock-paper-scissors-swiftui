
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var selectedRounds: Int = 5
    @State private var navigateToGame = false

    let roundOptions = [3, 5, 10]

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.red.opacity(0.8), Color.orange.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 48) {

                    Spacer()

                    // ── Title ──
                    VStack(spacing: 8) {
                        Text("✊🖐️✌️")
                            .font(.system(size: 60))
                        Text("Rock Paper\nScissors")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text("Best you can do?")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }

                    // ── Best Score ──
                    if viewModel.bestScore > 0 {
                        HStack(spacing: 8) {
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.yellow)
                            Text("Best Score: \(viewModel.bestScore)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Capsule())
                    }

                    // ── Rounds Selector ──
                    VStack(spacing: 16) {
                        Text("NUMBER OF ROUNDS")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.6))
                            .kerning(2)

                        HStack(spacing: 16) {
                            ForEach(roundOptions, id: \.self) { rounds in
                                Button {
                                    withAnimation(.spring()) {
                                        selectedRounds = rounds
                                    }
                                } label: {
                                    VStack(spacing: 4) {
                                        Text("\(rounds)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        Text("rounds")
                                            .font(.caption)
                                    }
                                    .foregroundColor(
                                        selectedRounds == rounds ? .red : .white
                                    )
                                    .frame(width: 80, height: 70)
                                    .background(
                                        selectedRounds == rounds
                                        ? Color.white
                                        : Color.white.opacity(0.15)
                                    )
                                    .cornerRadius(16)
                                }
                            }
                        }
                    }

                    // ── Start Button ──
                    Button {
                        viewModel.startGame(rounds: selectedRounds)
                        navigateToGame = true
                    } label: {
                        Text("Start Game 🎮")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
                    }
                    .padding(.horizontal, 32)

                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigateToGame) {
                GameView(viewModel: viewModel)
            }
        }
    }
}
