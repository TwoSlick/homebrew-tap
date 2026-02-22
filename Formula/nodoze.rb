class Nodoze < Formula
  desc "Keep your speakers awake by playing an inaudible tone periodically"
  homepage "https://github.com/TwoSlick/nodoze"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.2/nodoze-aarch64-apple-darwin.tar.xz"
      sha256 "1dd75b6e06202251a117fe5f5dffcf7f17c1c6c845b3a855d3beddd03761914b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.2/nodoze-x86_64-apple-darwin.tar.xz"
      sha256 "a0d9506a906a809fc3572f6638dd94abb5475f733faf4e5be5563b6955c4f03c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.2/nodoze-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ee3c2db44a21aecb85398b9476347718e5691a2d1c706cb6964f1d921354692"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.2/nodoze-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "61327ff9fded326ceafbf0a2562e49720a8e98f2fca7877c04448cccdd803187"
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
