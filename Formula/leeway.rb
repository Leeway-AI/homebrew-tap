class Leeway < Formula
  desc "Launch your coding agent through the LeewayLLM gateway - same model, less context, receipts for every request."
  homepage "https://leewayai.app"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.0.2/leeway-cli-aarch64-apple-darwin.tar.gz"
      sha256 "0fec8907e5cd2ebf3712ff9f32cd6032e24ba37ba610af1c00253546c6f4d179"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.0.2/leeway-cli-x86_64-apple-darwin.tar.gz"
      sha256 "5a02648b2534bb8b74538e47bd105a2d7048a27fbddfa0b573b34fef09891def"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.0.2/leeway-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "018ffecddbddda7b7951a465351984df397cb518882d68f8a6344076db1e65c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.0.2/leeway-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5ff285fe7208328bd48d972cf2830cd4b00ff2b11cd7ccd91120dc2730397ac4"
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
