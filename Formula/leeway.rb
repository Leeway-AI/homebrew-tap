class Leeway < Formula
  desc "Launch your coding agent through the LeewayLLM gateway - same model, less context, receipts for every request."
  homepage "https://leewayai.app"
  version "1.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.0.3/leeway-cli-aarch64-apple-darwin.tar.gz"
      sha256 "24f5211508a6f95ef48bbd1ffa2b10d44316c675950bc1ef03872d8d3a443723"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.0.3/leeway-cli-x86_64-apple-darwin.tar.gz"
      sha256 "97e96a32b8587a1e68754254fd228050cc596bb5586f4d62a15d8f5fee68f95a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.0.3/leeway-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "68f599cc67f1d5703f9c79ab8b130bda37d372140e5f40f4d0dd06d779e5a849"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.0.3/leeway-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "003a43c026adefbb8736e2dc70e56cee9edccdce3b47191c5e8c5e811934b80e"
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
