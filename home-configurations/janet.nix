{
  config,
  pkgs,
  inputs,
  ...
}:

let
  spork = inputs.spork;
  sporkUrl = "https://github.com/janet-lang/spork.git";

  # A JPM tree with spork installed into it, used as the global janet module
  # path. This also provides spork's janet-format, janet-pm and janet-netrepl
  # scripts.
  spork-tree = pkgs.stdenv.mkDerivation {
    pname = "janet-spork-tree";
    version = spork.shortRev or "unstable";
    src = spork;
    nativeBuildInputs = [
      pkgs.janet
      pkgs.jpm
    ];
    sporkRev = spork.rev;
    inherit sporkUrl;
    dontConfigure = true;
    buildPhase = ''
      runHook preBuild
      jpm --tree="$out" install
      runHook postBuild
    '';
    # jpm records the origin of a package in its manifest by shelling out to
    # git. The flake input is a bare source tree without a .git directory, so
    # jpm marks spork as a :local package, and `jpm deps` would then consider
    # it missing and clone it again. Fill in the origin ourselves.
    postBuild = ''
      cat > fix-manifest.janet <<'JANET'
      (def path (string (os/getenv "out") "/lib/.manifests/spork.jdn"))
      (spit path
            (string/format "%j\n"
                           (merge (parse (slurp path))
                                  {:type :git
                                   :url (os/getenv "sporkUrl")
                                   :tag (os/getenv "sporkRev")})))
      JANET
      janet fix-manifest.janet
    '';
    installPhase = "true";
  };

  # janet, jpm and spork's scripts, wrapped so they find the spork tree without
  # relying on the session environment. --set-default only fills the variables
  # in when they are unset, so a dev shell pointing at its own tree still wins.
  # makeBinaryWrapper, not the shell one: the wrapper has to stay a real
  # executable for `#!/usr/bin/env janet` scripts to work.
  janet-with-spork = pkgs.symlinkJoin {
    name = "janet-with-spork";
    paths = [
      pkgs.janet
      pkgs.jpm
      spork-tree
    ];
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    postBuild = ''
      for exe in "$out"/bin/*; do
        wrapProgram "$exe" \
          --set-default JANET_PATH "${spork-tree}/lib" \
          --set-default JANET_MODPATH "${spork-tree}/lib"
      done
    '';
  };
in
{
  home.packages = [ janet-with-spork ];
}
