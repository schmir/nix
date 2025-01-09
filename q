───────┬────────────────────────────────────────────────────────────────────────
       │ File: [1mflake.nix[0m
───────┼────────────────────────────────────────────────────────────────────────
   1   │ {
   2   │   [33mdescription[0m [35m=[0m [32m"[0m[32mHome Manager configuration of ralf[0m[32m"[0m;
   3   │ 
   4   │   [33minputs[0m [35m=[0m {
   5   │     [33mnixpkgs-stable[0m.[33murl[0m [35m=[0m [32m"[0m[32mgithub:NixOS/nixpkgs/nixos-24.11[0m[32m"[0m;
   6   │     [33mnix-flatpak[0m.[33murl[0m [35m=[0m [32m"[0m[32mgithub:gmodena/nix-flatpak[0m[32m"[0m;
   7   │ 
   8   │     [32m# Specify the source of Home Manager and Nixpkgs.[0m
   9   │     [32m#nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";[0m
  10   │     [33mnixpkgs[0m.[33murl[0m [35m=[0m [32m"[0m[32mgithub:nixos/nixpkgs/nixpkgs-unstable[0m[32m"[0m;
  11   │     [33mflake-utils[0m.[33murl[0m [35m=[0m [32m"[0m[32mgithub:numtide/flake-utils[0m[32m"[0m;
  12   │ 
  13   │     [33mhome-manager[0m [35m=[0m {
  14   │       [33murl[0m [35m=[0m [32m"[0m[32mgithub:nix-community/home-manager[0m[32m"[0m;
  15   │       [33minputs[0m.[33mnixpkgs[0m.[33mfollows[0m [35m=[0m [32m"[0m[32mnixpkgs[0m[32m"[0m;
  16   │     };
  17   │ 
  18   │     [33mschmir-emacs[0m.[33murl[0m [35m=[0m [32m"[0m[32mgithub:schmir/.emacs.d[0m[32m"[0m;
  19   │ 
  20   │     [33mnix-index[0m.[33murl[0m [35m=[0m [32m"[0m[32mgithub:nix-community/nix-index[0m[32m"[0m;
  21   │     [33mnix-index[0m.[33minputs[0m.[33mnixpkgs[0m.[33mfollows[0m [35m=[0m [32m"[0m[32mnixpkgs[0m[32m"[0m;
  22   │ 
  23   │     [33mmy-fonts[0m.[33murl[0m [35m=[0m [32m"[0m[32mgit+ssh://git@github.com/schmir/fonts.git?ref=main[0m[32m"[0m;
  24 [32m+[0m │     [33mmy-fonts[0m.[33minputs[0m.[33mnixpkgs[0m.[33mfollows[0m [35m=[0m [32m"[0m[32mnixpkgs[0m[32m"[0m;
  25 [32m+[0m │ 
  26   │   };
  27   │ 
  28   │   [33moutputs[0m [35m=[0m
  29   │     {
  30   │       self[35m,[0m
  31   │       flake-utils[35m,[0m
  32   │       nixpkgs-stable[35m,[0m
  33   │       nix-flatpak[35m,[0m
  34   │       my-fonts[35m,[0m
  35   │       [35m...[0m
  36   │ [35m    [0m[34m}[0m@inputs:
  37   │     [35mlet[0m
  38   │       [33msystems[0m [35m=[0m [
  39   │         [32m"[0m[32mx86_64-linux[0m[32m"[0m
  40   │         [32m"[0m[32maarch64-darwin[0m[32m"[0m
  41   │       ];
  42   │ 
  43   │       [33mmkSystem[0m [35m=[0m system: {
  44   │         [33mlegacyPackages[0m.[33mhomeConfigurations[0m [35m=[0m [36mimport[0m [32m./home-configurations[0m (inputs [35m//[0m { [35minherit[0m [33msystem[0m; });
  45   │       };
  46   │     [35min[0m
  47   │     flake-utils[35m.[0mlib[35m.[0meachSystem systems mkSystem
  48   │     [35m//[0m {
  49   │       [33mnixosConfigurations[0m.[33msao[0m [35m=[0m nixpkgs-stable[35m.[0mlib[35m.[0mnixosSystem {
  50   │         [33msystem[0m [35m=[0m [32m"[0m[32mx86_64-linux[0m[32m"[0m;
  51   │         [33mspecialArgs[0m [35m=[0m {
  52   │           [35minherit[0m [33minputs[0m;
  53   │           [33mhostname[0m [35m=[0m [32m"[0m[32msao[0m[32m"[0m;
  54   │         };
  55   │         [33mmodules[0m [35m=[0m [
  56   │           [32m./configuration.nix[0m
  57   │         ];
  58   │       };
  59   │ 
  60   │       [33mnixosConfigurations[0m.[33mtriton[0m [35m=[0m nixpkgs-stable[35m.[0mlib[35m.[0mnixosSystem {
  61   │         [33msystem[0m [35m=[0m [32m"[0m[32mx86_64-linux[0m[32m"[0m;
  62   │         [33mspecialArgs[0m [35m=[0m {
  63   │           [35minherit[0m [33minputs[0m;
  64   │           [33mhostname[0m [35m=[0m [32m"[0m[32mtriton[0m[32m"[0m;
  65   │         };
  66   │         [33mmodules[0m [35m=[0m [
  67   │           [32m./configuration.nix[0m
  68   │         ];
  69   │       };
  70   │       [33mnixosConfigurations[0m.[33mhalimede[0m [35m=[0m nixpkgs-stable[35m.[0mlib[35m.[0mnixosSystem {
  71   │         [33msystem[0m [35m=[0m [32m"[0m[32mx86_64-linux[0m[32m"[0m;
  72   │         [33mspecialArgs[0m [35m=[0m {
  73   │           [35minherit[0m [33minputs[0m;
  74   │           [33mhostname[0m [35m=[0m [32m"[0m[32mhalimede[0m[32m"[0m;
  75   │         };
  76   │         [33mmodules[0m [35m=[0m [
  77   │           [32m./configuration.nix[0m
  78   │         ];
  79   │       };
  80   │ 
  81   │       [33mnixosConfigurations[0m.[33mgalatea[0m [35m=[0m nixpkgs-stable[35m.[0mlib[35m.[0mnixosSystem {
  82   │         [33msystem[0m [35m=[0m [32m"[0m[32mx86_64-linux[0m[32m"[0m;
  83   │         [33mspecialArgs[0m [35m=[0m {
  84   │           [35minherit[0m [33minputs[0m;
  85   │           [33mhostname[0m [35m=[0m [32m"[0m[32mgalatea[0m[32m"[0m;
  86   │         };
  87   │         [33mmodules[0m [35m=[0m [
  88   │           [32m./configuration.nix[0m
  89   │         ];
  90   │       };
  91   │     };
  92   │ }
───────┴────────────────────────────────────────────────────────────────────────
