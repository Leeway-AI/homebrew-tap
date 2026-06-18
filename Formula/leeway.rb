class Leeway < Formula
  desc "Launch your coding agent through the LeewayLLM gateway - same model, less context, receipts for every request."
  homepage "https://leewayai.app"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.2.0/leeway-cli-aarch64-apple-darwin.tar.gz"
      sha256 "87e17b58ed96061814fa7521cebb386fc80d7e88f3e5277a2edc5cf3451e6319"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.2.0/leeway-cli-x86_64-apple-darwin.tar.gz"
      sha256 "611163643ab8ad6d1de91b7e1fa8c51b5858d66cc5163a9680a066e27a59e97f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.2.0/leeway-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eff6c5f7836d0fb7413a835253a9b3c120fd3236bbec10103e7a2f33a1ce4d3a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.2.0/leeway-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6b56f02e18ace82b6e595498d9c5636d1f9140d1b9948674492ca605348626f1"
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
