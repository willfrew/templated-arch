# Ansible-based Arch Linux post-install configuration

## Installation
1. Install Arch Linux (using the [Installation Guide](https://wiki.archlinux.org/index.php/installation_guide))
2. Setup a network connection
3. Install git & ansible (`pacman -S git ansible`)
4. Clone this repo (`git clone https://github.com/willfrew/templated-arch`)
5. Run the ansible playbook (`./templated-arch/install.sh`)
6. Set your password (`passwd will`)

### Optional steps
7. Copy signed vpn cert & key to /etc/openvpn/client.{crt,key}
8. Enable openvpn `systemctl enable openvpn-client@client.service`
9. Clone faceless into ~/.faceless & setup as per repo instructions
