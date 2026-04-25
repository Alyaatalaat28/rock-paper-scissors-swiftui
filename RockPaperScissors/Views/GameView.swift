
import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.red.opacity(0.8), Color.orange.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {

                // ── Round & Score ──
                VStack(spacing: 8) {
                    Text("Round \(viewModel.currentRound) of \(viewModel.totalRounds)")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))

                    Text(viewModel.scoreText)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)

                    HStack(spacing: 24) {
                        Text("You")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                        Text("vs")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.4))
                        Text("CPU")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.top, 16)

                // ── Battle Area ──
                HStack(spacing: 0) {

                    // Player side
                    VStack(spacing: 12) {
                        Text("You")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))

                        Text(viewModel.playerMove?.emoji ?? "❓")
                            .font(.system(size: 64))
                            .scaleEffect(viewModel.playerMove != nil ? 1.0 : 0.8)
                            .animation(.spring(), value: viewModel.playerMove?.emoji)
                    }
                    .frame(maxWidth: .infinity)

                    // VS
                    VStack {
                        if viewModel.showResult, let result = viewModel.roundResult {
                            VStack(spacing: 4) {
                                Text(result.emoji)
                                    .font(.system(size: 32))
                                Text(result.message)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                            .transition(.scale.combined(with: .opacity))
                        } else {
                            Text("VS")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    .frame(width: 80)
                    .animation(.spring(), value: viewModel.showResult)

                    // CPU side
                    VStack(spacing: 12) {
                        Text("CPU")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))

                        if viewModel.isRevealing {
                            // Spinning while thinking
                            Text("🤔")
                                .font(.system(size: 64))
                                .rotationEffect(.degrees(viewModel.isRevealing ? 360 : 0))
                                .animation(
                                    .linear(duration: 0.5).repeatForever(autoreverses: false),
                                    value: viewModel.isRevealing
                                )
                        } else {
                            Text(viewModel.computerMove?.emoji ?? "❓")
                                .font(.system(size: 64))
                                .scaleEffect(viewModel.computerMove != nil ? 1.0 : 0.8)
                                .animation(.spring(), value: viewModel.computerMove?.emoji)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 24)
                .background(Color.white.opacity(0.15))
                .cornerRadius(24)
                .padding(.horizontal, 24)

                // ── Choice Buttons ──
                VStack(spacing: 16) {
                    Text(viewModel.isRevealing ? "CPU is thinking..." : "Make your move!")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))

                    HStack(spacing: 16) {
                        ForEach(Move.allCases, id: \.self) { move in
                            Button {
                                withAnimation {
                                    viewModel.playerChose(move)
                                }
                            } label: {
                                VStack(spacing: 8) {
                                    Text(move.emoji)
                                        .font(.system(size: 40))
                                    Text(move.rawValue)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    viewModel.playerMove == move
                                    ? Color.white.opacity(0.4)
                                    : Color.white.opacity(0.15)
                                )
                                .cornerRadius(16)
                                .scaleEffect(viewModel.playerMove == move ? 1.05 : 1.0)
                                .animation(.spring(), value: viewModel.playerMove)
                            }
                            .disabled(viewModel.isRevealing)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()

                // ── Restart Button ──
                Button {
                    viewModel.restartGame()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                        Text("Restart")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(14)
                }
                .padding(.bottom, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Home")
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.isGameOver) {
            ResultView(viewModel: viewModel)
        }
    }
}
