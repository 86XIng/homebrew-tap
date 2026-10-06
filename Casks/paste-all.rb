cask "paste-all" do
  version "0.1.1"
  sha256 "0304c72ac9081a43a5f55052f3e50d2bbbb810c3c17b9e8ceeb74bc520a2ad32"

  url "https://github.com/86XIng/PasteAll/releases/download/v#{version}/PasteAll-#{version}.zip"
  name "PasteAll"
  desc "Paste clipboard content into Finder as files"
  homepage "https://github.com/86XIng/PasteAll"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "PasteAll.app"

  # Releases are ad-hoc signed and not notarized yet, so Gatekeeper would
  # refuse to open the quarantined app. Remove this once releases are notarized.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/PasteAll.app"],
        writable_paths: ["PasteAll.app"],
        writable_base:  :appdir
  end

  uninstall quit: "io.github.86xing.PasteAll"

  zap trash: [
    "~/Library/Caches/io.github.86xing.PasteAll",
    "~/Library/Preferences/io.github.86xing.PasteAll.plist",
  ]

  caveats <<~EOS
    PasteAll needs Accessibility permission to handle ⌘V in Finder.
    After each upgrade, macOS asks for it again: open PasteAll and click
    "Re-authorize" when prompted.
  EOS
end
