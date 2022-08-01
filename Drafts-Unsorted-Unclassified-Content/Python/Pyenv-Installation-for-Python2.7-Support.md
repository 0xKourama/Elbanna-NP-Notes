# Installing dependencies:
`sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl`

# downloading and running pyenv
`curl https://pyenv.run | bash`

# adding the below lines to `~/.bashrc`:
```
export PATH="/root/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

# executing a new shell with the new configurations
`exec $SHELL`

# installing python 2.7.18
`pyenv install 2.7.18`

# setting global python to 2.7.18:
`pyenv global 2.7.18`

# going back to python 3:
`pyenv global system`

# viewing the configuration:
`pyenv versions`

# executing python 2.7
`pyenv exec python`

# installing pip modules to python 2.7
`pyenv exec pip install <PIP-MODULE>`