# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #set kernel:
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  services.usbmuxd.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the fingerprint scanner service
  services.fprintd.enable = true;

  # Optional: Enable PAM to allow fingerprint login for sudo/gdm
  security.pam.services.sudo.fprintAuth = true;
  #security.pam.services.login.fprintAuth = true;
  #security.pam.services.login.fprintAuth = lib.mkDefault true;
  #should be commented out line but gdm throws a hissy fit if that is put in the config

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  programs.steam = {
    enable = true; # Master switch, already covered in installation
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
    # Other general flags if available can be set here.
  };
  programs.gamemode.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  #makes default shell zsh:
  users.defaultUserShell = pkgs.zsh;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."mrjw" = {
    isNormalUser = true;
    description = "mrjw";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #  thunderbird
    ];
  };
  # Enable hardware accelerated video decoding to save CPU cycles
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # For 10th Gen Broadwell/Comet Lake+
      intel-vaapi-driver # Legacy driver fallback
      vpl-gpu-rt
    ];
  };

  services.power-profiles-daemon.enable = false;
  # Disable thermald to avoid conflicts with TLP platform profiles
  services.thermald.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      # Governors and Policies
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # CPU Limits (Sane limits to prevent lag while saving juice)
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60; # Restricts max boost clock, saving huge battery without severe lag

      # Turbo Boost
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0; # Disabling boost on battery is the #1 battery saver

      # Intel HWP (Hardware P-States)
      CPU_HWP_ON_AC = "performance";
      CPU_HWP_ON_BAT = "power";
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      # Platform Profile (Lenovo ACPI Framework)
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Process Scheduler (Fixed the inversion)
      SCHED_POWERSAVE_ON_AC = 0;
      SCHED_POWERSAVE_ON_BAT = 1;

      # Legacy Intel energy policy
      ENERGY_PERF_ON_AC = "performance";
      ENERGY_PERF_ON_BAT = "power";
      NMI_WATCHDOG = 0;

      # PCIe Power Management (Crucial for Intel chips)
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersupersave";

      # Storage Power Savings
      NVME_POWERMGNT_ON_AC = 0;
      NVME_POWERMGNT_ON_BAT = 1;

      # USB and Input
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 0;

      # Battery Care & Network
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
      WOL_DISABLE = "Y";
    };
  };

  # install hyprland:
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  # Install firefox.
  programs.firefox.enable = true;
  #install zsh:
  programs.zsh.enable = true;

  #thunar stuff:
  programs.xfconf.enable = true;
  services.dbus.enable = true;
  programs.thunar.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    kitty
    nicotine-plus
    localsend
    git
    rofi
    fastfetch
    quickshell
    home-manager
    nerd-fonts.mononoki
    jetbrains-mono
    mononoki
    gnumake
    (discord.override {
      withVencord = true;
    })
    rsync
    picard
    chromaprint
    mpc
    lrcget
    libnotify
    fwupd # UEFI updates
    libimobiledevice
    spotify
  ];
  #virtualbox stuff:
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.guest.enable = true;
  users.extraGroups.vboxusers.members = [ "mrjw" ];
  environment.sessionVariables = {
    # Force Zen/Firefox engines to use the native Wayland window surface
    MOZ_ENABLE_WAYLAND = "1";

    # Force the media layer to use Intel's modern media driver ("iHD")
    LIBVA_DRIVER_NAME = "iHD";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  #
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "net.reactivated.fprint.device.enroll" ||
          action.id == "net.reactivated.fprint.device.verify") {
        return polkit.Result.YES;
      }
    });
  '';
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.fwupd.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    53317
    2234
  ];
  networking.firewall.allowedUDPPorts = [
    53317
    2234
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
