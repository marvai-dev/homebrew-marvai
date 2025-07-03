class Marvai < Formula
  desc "CLI packaging tool for managing and executing AI prompts in your projects"
  homepage "https://github.com/marvai-dev/marvai"
  url "https://github.com/marvai-dev/marvai/archive/refs/tags/v0.1.13.tar.gz"
  sha256 "c8af6c515206fadf2aa2dc4bf0652bd0b9a71682062079b1524120890b58f84f"
  version "0.1.11"
  license "MIT"

  depends_on "go" => :build

  def install
    # Basic build with version injection only
    ldflags = %W[
      -s -w
      -X github.com/marvai-dev/marvai.Version=#{version}
    ]

    # Adjust to your actual main path if needed
    if File.exist?("cmd/marvai/main.go")
      system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/marvai"
    else
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    # Ensure help text and version work
    assert_match "marvai", shell_output("#{bin}/marvai --help")
    assert_match version.to_s, shell_output("#{bin}/marvai version")
  end
end
