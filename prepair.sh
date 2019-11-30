# connect power supply
xcode-select --install

# need click to install

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# need input password

brew install ansible

git clone https://github.com/suzushin54/dotfiles.git ~/rep/dotfiles

cd ~/dotfiles/ansible

ansible-playbook playbooks/mac.yml
