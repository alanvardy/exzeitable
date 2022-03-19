# Publish Checklist

This is just for my own use to reduce friction in publishing after I have been away.

1. Increment `@version` in `mix.exs`
2. Increment version on line 50 in `README.md`
3. Update changelog
4. Open PR
5. Merge PR
6. Publish

```bash
git checkout master
mix hex.publish
```
