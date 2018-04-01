### laverna-to-nvalt

Convert laverna formatted notes to nvALT compatible ones. Basically, runs through the metadata json files, pulls out the title information, finds the corresponding note contents, and saves the note contents with the title information.

### Set-up

Assumes that your laverna notes-db is formatted in a certain way:

```bash
~/Downloads/laverna-backups/notes-db/notes
❯ cat 619f9ae5-92a5-8efa-ff3c-36301bce79e9.json
{"type":"notes","id":"619f9ae5-92a5-8efa-ff3c-36301bce79e9","title":"ansible ERROR! Timeout (12s) waiting for privilege escalation prompt","taskAll":0,"taskCompleted":0,"created":1519234507704,"updated":1519257438453,"notebookId":"0","tags":[],"isFavorite":0,"trash":0,"files":[]}

~/Downloads/laverna-backups/notes-db/notes
❯ cat 619f9ae5-92a5-8efa-ff3c-36301bce79e9.md
pre_tasks:
  - name: disable fingerprint checking that may be enabled; when enabled, causes ssh issues
    command: authconfig --disablefingerprint --update
    become: yes

https://github.com/ansible/ansible/issues/14426
https://stackoverflow.com/questions/35616021/ansible-sudo-hangs-after-5-tasks

it looks like there were 3 other "fixes" in the thread related to SSH timeout issues:

In ansible.cfg set transport=paramiko in the [defaults] section

longer timeout because
Laggy environments (public clouds etc) can cause timeouts due strict default timeout. User should be able to configure the timeout to fit their needs but context.timeout is not updating when editing ansible.cfg.

[defaults]
timeout = 30

[ssh_connection]
pipelining = False
```

I generated this collection of notes through `Export data` on the https://laverna.cc/app/#/settings/importExport page.

### Usage

Given that you're pointing to a directory where you extracted `laverna-backup.zip` in:

```bash
  ./laverna_to_nvalt.sh -i ~/Downloads/laverna-backups/notes-db/notes -o /tmp/output
```

### Caveats

- Titles with "/" in them aren't supported; sanitize them before running this script
