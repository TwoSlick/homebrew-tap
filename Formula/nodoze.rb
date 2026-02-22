class Nodoze < Formula
  desc "Keep your speakers awake by playing an inaudible tone periodically"
  homepage "https://github.com/TwoSlick/nodoze"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.1/nodoze-aarch64-apple-darwin.tar.xz"
      sha256 "28e8480170b5ba3843bfd0cd7277cca9690091586adb4571d85e076c9bc27c91"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.1/nodoze-x86_64-apple-darwin.tar.xz"
      sha256 "fb7f51c7e59e5bbd52990a7166bb24531a298e4191ce47b7163ba2a25acf1b1e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.1/nodoze-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b1d7d30b2f93e21cfa6db973fcc9b7bcddbb33bc53bd519a80df2a64a39deba6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TwoSlick/nodoze/releases/download/v1.0.1/nodoze-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "eb2827672415cf697ce635669c86536e140d211fa13455f2552b1bf802614bab"
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
