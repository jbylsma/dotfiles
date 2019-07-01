# SSH

## MacOS key and passphrase handling

Passphrases should _not_ be stored in the user's keychains. If a passphrase is
stored in a keychain, a SSH session could skip any key confirmation by passing
`-o UseKeychain=yes`. Unfortunately, this means that passphrases must be
typed whenever they are added to the SSH agent. That's just the price of
security!

On MacOS, requests for keys added to SSH agent with the confirm option will
fail because the default helper program `/usr/libexec/ssh-askpass` does not
exist ([StackOverflow issue][1]). A [Homebrew tap][2] exists to start `ssh-agent`
with a basic confirmation prompt.

The Keychain Access application only updates when it's initially loaded. If you
use `ssh-add -K -d {key}` to delete a key's passphrase in a keychain, it will
_not_ be reflected until the user has re-opened the keychain.

[1]: https://serverfault.com/a/238500
[2]: https://github.com/theseal/ssh-askpass/blob/master/ssh-askpass.plist
