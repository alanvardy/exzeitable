# Publish Checklist

This checklist is for my use to reduce friction in publishing after I have been away.

1. Increment `@version` in `mix.exs`
2. Increment version on line 53 in `README.md`
3. Update changelog
4. Open PR
5. Merge PR
6. Publish

```bash
git checkout main
git pull
mix hex.publish
```
