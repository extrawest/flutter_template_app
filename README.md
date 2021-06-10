# Flutter Template App

Project Template for Flutter Projects.

## 1. Getting started
In order to use this template in your project, do the following step-by-step:

**1. Clone this repo to your folder:**

`git clone https://github.com/extrawest/flutter_template_app.git`

**2. Change directory to the previously cloned folder**

`cd flutter_template_app/`

**3. Remove an existing .git folder**

`rm -rf .git `

**4. Initialize an empty folder with git**

`git init`

**5. Set remote url to your empty repository**

`git remote set-url origin https://github.com/extrawest/flutter_template_app.git`

**6. Add all files to git**

`git add .`

**7. Commit all the files with 'initial commit' commit message**

`git commit -m "added an existing project"`

**8. Push to remote repository**

`git push -u origin master`

### Change the app name, package name and bundleId (Android & iOS)
**For Android**
1. Modify **the package name** in your MainActivity.java/kt file
2. Modify **the directory** containing your MainActivity.java/kt file

`<project-name>/android/app/src/main/java/your/package/name`

3. Modify **the package name in manifest tag** and **the android:label value** in your **main, debug and profile** AndroidManifest.xml files
4. Modify **the applicationId** in your build.gradle file


**For iOS**

Change the **CFBundleIdentifier and CFBundleName** from your Info.plist file inside your ios/Runner directory.

```
<key>CFBundleIdentifier</key>
<string>com.your.packagename</string>
<key>CFBundleName</key>
<string>New Application Name</string>
```

## Implemented Features
- Provider + ChangeNotifiers state sharing and state managing solution
- Fully featured localization / internationalization (i18n):
    - Pluralization support
    - Static keys support with automatic string constants generation using the following command:
        - `flutter pub run build_runner build --delete-conflicting-outputs`
    - Supports both languageCode (en) and languageCode_countryCode (en_US) locale formats
    - Automatically save & restore the selected locale
    - Full support for right-to-left locales
    - Fallback locale support in case the system locale is unsupported
    - Supports both inline or nested JSON
- Dynamic Themes changing using Provider
- Automatic font selection based on the thickness of the glyphs applied.
- API client configuration with mock data
- Splash screen with initial data loading
- Welcome screen
- Emulation of server requests
- Authorization:
    - Sign in screen with logic
    - Validation text fields
    - Forgot Password screen
    - Sign up screen with basic logic
    - Account Setup screen with basic logic
    - Onboarding screen with basic logic
    - Accepting privacy policy
- Empty Dashboard and Core screens
- Terms and Privacy screen with dummy data
- Privacy Policy screen with dummy data
- Support screen with basic UI and logic
- Side menu (basic design)
- Premium subscription screen (with logic for restoring purchases)
- In app purchase with basic logic (implemented only purchase service)

---
Created by Extrawest Mobile Team
[Extrawest.com](https://www.extrawest.com), 2021
---
