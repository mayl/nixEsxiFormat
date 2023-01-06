{
  description = "A very basic flake";

  inputs.nixos-generators.url = "github:mayl/nixos-generators/custom_formats";

  outputs = { self, nixpkgs, nixos-generators, ... }: {

    customFormats = {
      "esxi" = { formatAttr = "esxi"; imports = [ ./esxi_image.nix ]; };
    };

    packages.x86_64-linux.testEsxi = nixos-generators.nixosGenerate {
      format = "esxi";
      system = "x86_64-linux";
      customFormats = self.customFormats;
      modules = [
        ({pkgs, ...}: {
          environment.systemPackages = with pkgs; [ cowsay ];
        })
      ];
    };

    packages.x86_64-linux.testVM = nixos-generators.nixosGenerate {
      format = "vm";
      system = "x86_64-linux";
      modules = [
        ({pkgs, ...}: {
          environment.systemPackages = with pkgs; [ cowsay ];
        })
      ];
    };

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
