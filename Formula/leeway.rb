class Leeway < Formula
  desc "Launch your coding agent through the LeewayLLM gateway - same model, less context, receipts for every request."
  homepage "https://leewayai.app"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.1.0/leeway-cli-aarch64-apple-darwin.tar.gz"
      sha256 "5ae272ad59892c888863413b2b6ef6ea74b189df399f82262270d84a00c3e075"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.1.0/leeway-cli-x86_64-apple-darwin.tar.gz"
      sha256 "08febe814d9bbf32f150d3cf2e356359493938b4a155fc3cb105674e83aa4895"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.1.0/leeway-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "035efd26d41bb946d0b53ec2c65c5b53b71828e169642022ddc482c089506785"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Leeway-AI/leeway-cli/releases/download/v1.1.0/leeway-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e2b0528a80f2fc5a4b2b53b00995a7e6554aba90fbf09ab6b4e7830a87846332"
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
