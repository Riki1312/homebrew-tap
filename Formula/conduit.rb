class Conduit < Formula
  desc "Agent-first developer operations CLI."
  homepage "https://github.com/Riki1312/conduit-cli"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Riki1312/conduit-cli/releases/download/v0.1.2/conduit-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1d006fb816994b3b6bd8039755f395f83e05a56478887383321b60da8d25ffd7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Riki1312/conduit-cli/releases/download/v0.1.2/conduit-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9c43ea395d2d74ad17812f8e8d263800b5b2fe2ebd47d51193a3a423b55302c7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Riki1312/conduit-cli/releases/download/v0.1.2/conduit-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8f85e1f9c2f3a146a59cbd04b1805184eda7fa4fb44155b44596f9d0c4ad88c4"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
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
    bin.install "conduit" if OS.mac? && Hardware::CPU.arm?
    bin.install "conduit" if OS.mac? && Hardware::CPU.intel?
    bin.install "conduit" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
