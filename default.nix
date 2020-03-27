self: super:

let
  rev = "d92a15c1637860a669970142abe37d1daf5f2c73";
  sha256 = "1l078yz2gb2k3961kik4cnlwigpdnalhl6pzwrjdad0hf5nd9mxs";
  cargoSha256 = "1812794dma96g0pf1nfbq16z71h2l7dxk0xr0xrn14r7igs2hcv2";

  extName = "rust-analyzer";
  extVersion = "0.1.0";
  extPublisher = "matklad";

  version = "git-${rev}";

  src = self.fetchFromGitHub {
    owner = "rust-analyzer";
    repo = "rust-analyzer";
    inherit rev sha256;
  };

in {
  rust-analyzer = self.callPackage ./server.nix {
    inherit version src cargoSha256;
  };

  vscode-extensions = self.lib.recursiveUpdate super.vscode-extensions {
    "${extPublisher}".${extName} = self.callPackage ./extension.nix {
      inherit version extName extVersion extPublisher;
      inherit (self.pkgs) rust-analyzer;
      src = "${self.pkgs.rust-analyzer.src}/editors/code";
    };
  };
}
