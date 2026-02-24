# Nix Multi-Host Configuration Architecture Guide

## Purpose

This document describes the intended architecture for a unified Nix flake managing:

- 1 NixOS machine
- 2 macOS machines (via nix-darwin)
- Home Manager for user environments across all systems

This guide is written for another LLM to understand the structure, layering model, and design principles behind the configuration.

The goal is clarity, composability, and long-term maintainability.

---

# High-Level Design

The configuration follows a layered architecture:

Hosts (physical machines)
    ↓
Platforms (NixOS / Darwin)
    ↓
Modules (reusable building blocks)
    ↓
Home Manager (user environment)

Each layer has clear responsibilities.

---

# Core Principles

## 1. Hosts Are the Unit of Selection

Each physical machine gets:

- A hostname
- A system configuration
- Optional host-specific overrides

Examples:

- `desktop` (NixOS)
- `mbp-work` (macOS)
- `mbp-home` (macOS)

Rebuilds always target a specific host:

```bash
sudo nixos-rebuild switch --flake .#desktop
darwin-rebuild switch --flake .#mbp-work
```

The flake does not auto-detect platforms. The host key selects the configuration.

---

## 2. Platforms Are Thin Wrappers

Two platforms exist:

- `nixos`
- `darwin`

They:

- Define how to build the system
- Wire in Home Manager
- Import relevant modules

They should not contain large amounts of business logic.

---

## 3. Home Manager Owns User Space

If the user interacts with it directly, it belongs in Home Manager.

Examples:

- shell config
- neovim
- git
- CLI tools
- themes
- personal apps

Home Manager should not contain:

- system services
- kernel configuration
- hardware configuration
- macOS defaults
- Homebrew system logic

---

## 4. No OS Conditionals Inside Modules

Avoid patterns like:

```nix
if pkgs.stdenv.isDarwin then ...
```

Instead:

- Separate Linux and macOS modules
- Compose them at the host level

This prevents config sprawl and unreadable logic.

---

# Recommended Directory Structure

```
.dotfiles/
├── flake.nix
├── hosts/
│   ├── desktop/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   ├── mbp-work/
│   │   └── configuration.nix
│   └── mbp-home/
│       └── configuration.nix
│
├── modules/
│   ├── nixos/
│   │   ├── common.nix
│   │   ├── desktop.nix
│   │   └── games.nix
│   ├── darwin/
│   │   ├── common.nix
│   │   └── homebrew.nix
│   └── shared/
│       └── fonts.nix
│
└── home/
    ├── global/
    │   ├── shell.nix
    │   ├── nvim.nix
    │   ├── apps.nix
    │   └── colors.nix
    ├── linux/
    │   └── desktop.nix
    ├── mac/
    │   └── mac-apps.nix
    └── hosts/
        ├── desktop.nix
        └── mbp-work.nix
```

---

# Directory Responsibilities

## `/hosts`

Machine-specific configuration.

Should:

- Set hostname
- Enable services
- Import relevant modules
- Wire in Home Manager

Should NOT:

- Contain large reusable logic
- Duplicate configuration across machines

Hosts should be thin composition layers.

---

## `/modules`

Reusable system-level building blocks.

### `/modules/nixos`

Examples:

- Desktop environment configuration
- Gaming configuration
- Docker setup
- Audio setup

These are reusable across multiple NixOS hosts.

---

### `/modules/darwin`

Examples:

- macOS defaults
- Dock configuration
- Homebrew configuration

Homebrew belongs here — not in Home Manager.

---

### `/modules/shared`

Shared system-level logic that applies across platforms.

**This is for system-level installation and configuration that requires root privileges.**

Examples:

- Installing font packages system-wide
- System packages needed by all hosts
- Global system policies
- System services that run across platforms

**Key distinction:** If it requires `sudo nixos-rebuild` or `darwin-rebuild` to apply, it belongs here. User-level configuration of these system components belongs in `/home/global`.

**Example:**
```nix
# /modules/shared/fonts.nix
{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    jetbrains-mono
    fira-code
  ];
}

# /home/global/alacritty.nix
{ ... }: {
  programs.alacritty.settings.font.normal.family = "JetBrains Mono";
}
```

---

## `/home`

User environment logic (Home Manager).

This is the primary personalization layer.

### `/home/global`

Applies everywhere:

- shell config
- neovim
- git
- CLI tools
- themes
- core development tools

---

### `/home/linux`

Linux-specific user environment:

- Wayland/X11 config
- Linux GUI apps
- wl-clipboard
- systemd user units

---

### `/home/mac`

macOS-specific user environment:

- mac-specific CLI tools
- path tweaks
- Raycast config
- mac-specific environment variables

---

### `/home/hosts`

Rarely used.

Only for:

- work-specific overrides
- machine-specific user tweaks
- hardware-specific quirks

Avoid overusing this directory.

---

# Homebrew Placement

Homebrew must be managed by nix-darwin.

It belongs in:

```
modules/darwin/homebrew.nix
```

Guidelines:

- Shared GUI apps → common module
- Work-only apps → host module
- CLI tools available in nixpkgs → Home Manager instead

Never manage Homebrew inside Home Manager.

---

# Composition Model

## NixOS Host Composition

```
nixos host
  + nixos common modules
  + optional nixos feature modules
  + home-manager
      + global
      + linux
      + optional host override
```

---

## macOS Host Composition

```
darwin host
  + darwin common modules
  + homebrew module
  + home-manager
      + global
      + mac
      + optional host override
```

---

# Flake Output Model

The unified flake exposes:

- `nixosConfigurations.<hostname>`
- `darwinConfigurations.<hostname>`

Example:

```
nixosConfigurations.desktop
darwinConfigurations.mbp-work
darwinConfigurations.mbp-home
```

Home Manager is wired into system builds.

It is not invoked separately.

---

# Design Rules for Long-Term Stability

1. Hosts should compose, not define.
2. Modules should be reusable.
3. Home Manager owns user environment.
4. No cross-platform conditionals in random places.
5. Avoid duplication across hosts.
6. Prefer composition over branching logic.

---

# Scalability

This structure scales to:

- Additional laptops
- Servers
- Raspberry Pi
- CI builders
- Remote machines

To add a machine:

1. Create a new host directory.
2. Import appropriate modules.
3. Reuse existing Home Manager structure.

No structural refactor should be needed.

---

# Non-Goals

This architecture intentionally avoids:

- Auto-detecting platform at runtime
- Embedding OS checks in shared modules
- Mixing system logic into Home Manager
- Monolithic 1,000-line host files

---

# Summary

This configuration uses:

- Hosts as selection units
- Platforms as thin system wrappers
- Modules as reusable system logic
- Home Manager as the user environment layer

The design prioritizes:

- Clarity
- Composability
- Predictability
- Long-term maintainability

It is optimized for managing:

- 1 NixOS machine
- 2 macOS machines
- Shared user environment across all systems
