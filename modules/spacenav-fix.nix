{config, pkgs, ...}:
let
  spacenavBpf = pkgs.runCommand "spacenav-bpf.o" {
    buildInputs = [pkgs.udev-hid-bpf pkgs.cland pkgs.llvm pkgs.makeWrapper];
  } ''
    mkdir -p $out
    cp ${./spacenav-bpf.c} spacenav-bpf.c
    clang -target bpf -O2 -g -c spacenav-bpf.c -o $out/spacenav-bpf.o
  '';
in
{
  # environment.systemPackages = [pkgs.udev-hid-bpf];
  # environment.etc."spacenav-bpf.o".source = "${spacenavBpf}/spacenav-bpf.o";
  # services.udev.extraRules = ''
  #   # allow users in input to access space mouse
  #   SUBSYSTEM=="hidraw", ATTR{idVendor}=="46d", ATTR{idProduct}=="c627", \
  #     MODE="0660", GROUP = "input"
  #   # load eBPF for my space navigator model
  #   ACTION=="add", SUBSYSTEM=="hid", ATTR{idVendor}=="46d", ATTR{idProduct}=="c627", \
  #     RUN+="${pkgs.udev-hid-bpf}/bin/udev-hid-bpf ${spacenavBpf}/spacenav-bpf.o"
  # '';
}
