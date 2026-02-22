{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    flutter
    cmake
    ninja
    pkg-config
    clang 
  ];

  buildInputs = with pkgs; [
    at-spi2-atk
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libdatrie
    libepoxy
    libselinux
    libsepol
    libthai
    libxkbcommon
    pango
    pcre
    xorg.libX11
    alsa-lib 
    # Add this for media_kit
    mpv
  ];

  shellHook = ''
    # We add mpv to the PKG_CONFIG_PATH
    export PKG_CONFIG_PATH="${pkgs.alsa-lib.dev}/lib/pkgconfig:${pkgs.gtk3.dev}/lib/pkgconfig:${pkgs.mpv}/lib/pkgconfig"
    
    # Optional: If media_kit complains about headers, add this too
    export CPATH="${pkgs.mpv}/include"
    export LIBRARY_PATH="${pkgs.mpv}/lib"
  '';
}
