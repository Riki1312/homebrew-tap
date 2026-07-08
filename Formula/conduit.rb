class Conduit < Formula
  desc "Agent-first developer operations CLI."
  homepage "https://github.com/Riki1312/conduit-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Riki1312/conduit-cli/releases/download/v0.1.0/conduit-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1dc9315649c0790126426dd6a5b9a4bc54b41ddb04c0191f1bdc8fef9c4e54ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Riki1312/conduit-cli/releases/download/v0.1.0/conduit-cli-x86_64-apple-darwin.tar.xz"
      sha256 "71e52ab0be17578dca0eacc082042f1497f0de57f0d5cb4760973fc62d5e8a0e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Riki1312/conduit-cli/releases/download/v0.1.0/conduit-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "aedd96baafd23022b45fd680d8813f3e08aba359d7f36f7eecd0ce4d0cc618eb"
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
