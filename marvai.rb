class Marvai < Formula
  desc "CLI packaging tool for managing and executing AI prompts in your projects"
  homepage "https://github.com/marvai-dev/marvai"
  url "https://github.com/marvai-dev/marvai/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "12fb693c67a97dbd7b429457901442866f79ea8880981bdbb51037bfd98fbfce"
  license "MIT"

  depends_on "go" => :build

  def install
    # Set up Go environment
    ENV["CGO_ENABLED"] = "0"
    ENV["GOOS"] = "darwin" if OS.mac?
    ENV["GOOS"] = "linux" if OS.linux?
    ENV["GOARCH"] = Hardware::CPU.arm? ? "arm64" : "amd64"

    # Build the binary
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head}
      -X main.date=#{time.iso8601}
    ]

    # Try common Go project structures
    if File.exist?("cmd/marvai/main.go")
      system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"marvai"), "./cmd/marvai"
    elsif File.exist?("main.go")
      system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"marvai"), "."
    else
      # Fallback to module root
      system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"marvai")
    end
  end

  test do
    # Test that the binary exists and can show help
    assert_match "marvai", shell_output("#{bin}/marvai --help 2>&1", 0)
    
    # Test version command if available
    version_output = shell_output("#{bin}/marvai version 2>&1", 0)
    assert_match version.to_s, version_output
    
    # Test basic functionality
    system "#{bin}/marvai", "list-local"
  end
end