# Remarques

Source files for the website https://www.yuntongzhang.com.

## Steps for updating content

1. Clone this repo and update the source content.
2. Test locally with `hugo server` and check the rendered pages on `http://localhost:1313`.
3. Run `rm -rf public`, `git rm -r --cached public` to completely remove the `public` directory.
4. `git submodule add -b master git@github.com:yuntongzhang/yuntongzhang.github.io.git public`
5. Deploy it with `./deploy.sh "optional commit message"`.
6. Commit changes to this repo as well.

## Built with

- [Hugo](https://gohugo.io/) - The static site generator
- [Adam & Eve](https://github.com/blankoworld/hugo_theme_adam_eve) - The theme
- [Github Pages](https://pages.github.com/) - Hosting
