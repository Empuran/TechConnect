{ pkgs, ... }: {
  channel = "stable-23.11"; # Use stable Nix channel
  packages = [
    pkgs.flutter
    pkgs.jdk17
  ];
  env = {};
  idx = {
    extensions = [
      "dart-code.flutter"
      "dart-code.dart-code"
    ];
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["flutter" "run" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter";
        };
        android = {
          command = ["flutter" "run" "--machine" "-d" "android" "-d" "localhost:5555"];
          manager = "flutter";
        };
      };
    };
  };
}
