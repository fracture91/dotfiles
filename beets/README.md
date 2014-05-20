`ln -s ~/.dotfiles/beets/config.yaml ~/.config/beets/config.yaml`
`pip install -r requirements.txt`

Permissions in dtrx were messed up after installing.
This fixed them: `sudo chmod og+r /usr/local/lib/python2.7/dist-packages/dtrx-7.1.egg-info/*`

