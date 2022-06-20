# dotfiles

!screenshot

## Dotfiles are configuration files that are used to customize your Linux installation.

It's called this way because there's a period in the start of the filename
(meaning it is a hidden file or directory), that looks like a dot. This repo
contains some of my config files. This way I can use it as my backup if I
format my machines or install it on new computers. Also, it can be helpful for
some if you want to copy or take some ideas for your own customizations.

## Why do I have this repository?

- I can use it as my backup if I need;
- I use it as a learning tool (on git and configuration files in general);
- Maybe I can help some people that are looking for inspiration.

## Usage

You can download my dotfiles cloning this repository to your local machine and
then copying the files you want to use as you wish.

In this example I'm going to demonstrate how you would use my `.bashrc` file as
your bash configuration file:

  ```
  $ git clone https://github.com/mateuscomh/dotfiles && cd dotfiles
  ```
  
 _This install will force a symbolic lynk on a options on each folder_
  ```
  $ bash install.sh
  ```
  
If you do this, probably the next time you open your bash session, you're going
to notice some changes, because of the new `.bashrc` file.

Note that you should read everything inside those config files before putting
on your system. Sometimes there are something pointing to another file, script
or program and you should aknowledge that. But I'm sure you're pretty smart and
gonna work it out easily! Have a nice day!

This repo is my personal configs represents dotfiles in my ${HOME}

*Atention: some deps may be necessary to full working*
