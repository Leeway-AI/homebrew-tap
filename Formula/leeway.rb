class Leeway < Formula
  desc "Launch your coding agent through the LeewayLLM gateway - same model, less context, receipts for every request."
  homepage "https://leewayai.app"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.0.0/leeway-cli-aarch64-apple-darwin.tar.gz"
      sha256 "c90a0b91f024807837a675cdbe9629a310387a942d9277315c8ac999f3f36cf2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.0.0/leeway-cli-x86_64-apple-darwin.tar.gz"
      sha256 "3c5718f58efb2daee48a803b54c0d59b65b3a7925d220f31bfda6711b95f3d6a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.0.0/leeway-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bb44eb841fa3aad7cbfd67b825b779b2fb6a5da2960f476ee9d00605f63e2c46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.0.0/leeway-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bbcee2eb1d85a55f48608888de879eca3da10b46b2cc13c51e83111378abfa98"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "leeway" if OS.mac? && Hardware::CPU.arm?
    bin.install "leeway" if OS.mac? && Hardware::CPU.intel?
    bin.install "leeway" if OS.linux? && Hardware::CPU.arm?
    bin.install "leeway" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
