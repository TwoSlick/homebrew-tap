class Nodoze < Formula
  desc "Keep your speakers awake by playing an inaudible tone periodically"
  homepage "https://github.com/TwoSlick/nodoze"
  version "1.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.3/nodoze-aarch64-apple-darwin.tar.xz"
      sha256 "ec03a51feb9ae366db3a1f9ce8746ac5bacbdbf3c30ced9f2a20cbdc9eaee949"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.3/nodoze-x86_64-apple-darwin.tar.xz"
      sha256 "8bd03a31e93be1f40b054e7e43f69c9ed88434c608ce4816b151e76b98a970cc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.3/nodoze-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8cde87bd879d2523e243e8f25ad43485d6ac53d6fd251dacebad4357eb0d2465"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.3/nodoze-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d5abae14ea0cc93ba7ca7ec4cb4d33813bf6ee5e6c443b51af9f8131a6578e4b"
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
    bin.install "nodoze" if OS.mac? && Hardware::CPU.arm?
    bin.install "nodoze" if OS.mac? && Hardware::CPU.intel?
    bin.install "nodoze" if OS.linux? && Hardware::CPU.arm?
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
