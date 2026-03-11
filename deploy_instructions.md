# Connect to GitHub & Push configuration step

This is a helper script meant to guide you on how to push the repository to a remote server. You can run these commands from the terminal.

1. Go to github.com and create a new, empty repository named `TechConnect`.
2. Do NOT initialize it with a README or .gitignore (we already made those!).
3. Get the HTTPS or SSH URL for your new repository (e.g., `https://github.com/YourUsername/TechConnect.git`).

Then, run the following commands sequentially in the terminal at the `TechConnect` root folder:

```powershell
# Add all the files we created
git add .

# Create the initial commit
git commit -m "Initial commit: TechConnect MVP Cloud Build scaffolding"

# Make sure we are on the main branch
git branch -M main

# Link this local folder to your new GitHub repository
git remote add origin https://github.com/YourUsername/TechConnect.git

# Push the code up to the cloud!
git push -u origin main
```

Once pushed, go to the **Actions** tab in your GitHub repository. You will see the `Antigravity Cloud Build (Flutter)` workflow automatically spin up and start building the APK and iOS apps!
