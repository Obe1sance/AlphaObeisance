git checkout dev
git pull --rebase origin dev
git checkout main
git pull origin main
git merge dev
git push origin main
