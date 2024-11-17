{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    clojure
    babashka
    neil
    clj-kondo
    leiningen
    zprint
  ];
}
