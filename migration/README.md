# Migration Scripts

**Note:** This directory is only needed if you're upgrading from an old dotfiles setup. If you're installing fresh, you can delete this directory immediately.

## z.sh → zoxide Migration

If you previously used z.sh and have a `~/.z` file with directory history:

```bash
./migration/migrate-z-to-zoxide.sh
```

This will:
- Import your directory history from `~/.z` into zoxide
- Backup your z.sh data to `~/.z.migrated`

After successful migration:
```bash
rm -rf migration/           # Delete this directory
rm ~/.z.migrated           # Delete the backup (optional)
```

If you don't have a `~/.z` file (fresh install), just delete this directory:
```bash
rm -rf migration/
```
