class Nodoze < Formula
  desc "Keep your speakers awake by playing an inaudible tone periodically"
  homepage "https://github.com/TwoSlick/nodoze"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.0/nodoze-aarch64-apple-darwin.tar.xz"
      sha256 "663094748e27d323c784975a5d1064211285a939e778a173c418f65a91352043"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.0/nodoze-x86_64-apple-darwin.tar.xz"
      sha256 "0f565cb50e25ad844f39c0e68a8d4a1d4ffbdff4ed8575e43e140e37659beb6f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.0/nodoze-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "75143a0545be0825fb7a66f42eb626644b2d883412da2ad12e656d8856831ab5"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "nodoze" if OS.mac? && Hardware::CPU.arm?
    bin.install "nodoze" if OS.mac? && Hardware::CPU.intel?
    bin.install "nodoze" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
