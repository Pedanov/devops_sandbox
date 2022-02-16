mkdir sandbox
cd sandbox
mkdir Task1
touch Task1/README.md
git init
git add .
git commit -m "initial commit"
git branch -M main
git remote add origin git@github.com:Pedanov/devops_sandbox.git
git push -u origin main
git checkout -b dev
touch test_file
git add .
git commit -m "added test_file"
git push --set-upstream origin dev
git checkout -b $USER-new_feature
echo "# Exadel DevOps sandbox" >> README.md
git status
nano .gitignore
git add .
git commit -m "added gitignore"
git push --set-upstream origin $USER-new_feature
gh pr create -B dev -t "Merge new_feature into dev"
gh pr merge
git checkout dev
gh pr create -t "Merge dev into main"
gh pr merge
git checkout $USER-new_feature
echo "Changes to README file" >> README.md
git commit -am "made changes to README file"
git log
git revert 16184d34a25ae98ba8327031367ec9307ff7f589
git checkout main
git log $USER-new_feature > log.txt
git add .
git commit -m "added new_feature branch log"
git push
git branch -D $USER-new_feature
git push origin --delete $USER-new_feature
git checkout dev
