# TechConnect

**TechConnect** is a modern dating app for tech professionals, built to run seamlessly on the Antigravity Cloud Build pipeline.

## Development Workflow
This repository contains the complete Flutter codebase and Supabase backend migrations designed for cloud-only compilation. 
No local SDKs (Flutter, Android Studio, Xcode) are required.

### Antigravity Cloud Build
The build pipeline is defined in `antigravity_cloud_build.yaml`. When pushed or executed via the Antigravity Cloud console, it will automatically:
1. Provision the latest Flutter SDK environment.
2. Resolve dependencies.
3. Build the **Android APK**.
4. Build the **Android App Bundle (AAB)** for Google Play.
5. Build the **Apple iOS IPA** for App Store submission.

### Supabase Backend
Ensure your Supabase keys are configured in the `lib/main.dart` or Antigravity environment variables. Database schemas and Edge Functions are located under `supabase/`.
