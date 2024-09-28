# My Dotfiles

This repository contains my personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). 

## Prerequisites

- macOS
- [Homebrew](https://brew.sh/)

## Quick Start

To set up a new machine with these dotfiles, follow these steps:

1. Install Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install chezmoi:

```bash
brew install chezmoi
```

3. Initialize chezmoi with this repository:

```bash
chezmoi init https://github.com/suzushin54/dotfiles.git
```

4. Apply the dotfiles:

```bash
chezmoi apply -v
```

After applying the dotfiles, you may need to:

1. Install Fish shell:

```bash
brew install fish
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

2. Set up fzf for Fish:

```fish
fzf --fish | source
```


## Customizing

To make changes to the dotfiles:

1. Edit the source files in the chezmoi directory:

```bash
chezmoi edit ~/.config/fish/config.fish
```

2. Apply the changes:

```bash
chezmoi apply
```

3. Commit and push your changes to the repository:

```bash
chezmoi cd
git add .
git commit -m "Update dotfiles"
git push
```

## Troubleshooting

If you encounter any issues:

1. Check the output of \`chezmoi doctor\`
2. Ensure all prerequisites are installed
3. Check the [chezmoi documentation](https://www.chezmoi.io/docs/how-to/)

For specific issues, please open an issue in this repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

