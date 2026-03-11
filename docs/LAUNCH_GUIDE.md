# TechConnect Launch Guide

This document contains instructions for deploying the TechConnect MVP to production, alongside security and trust-and-safety best practices crucial for a dating app.

---

## 1. Deployment Guide

### Android (APK & Play Store)
Target Phase 1: Infopark Kochi tech professionals using Android.

1. **Change App Package Name**:
   Update `android/app/build.gradle` `applicationId` to `com.techconnect.app`.
2. **Generate Keystore**:
   ```bash
   keytool -genkey -v -keystore release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
   ```
3. **Configure Signing**:
   Create `android/key.properties` pointing to `release.jks` with passwords.
4. **Build APK** (For immediate side-loading or internal testing):
   ```bash
   flutter build apk --release
   ```
5. **Build App Bundle** (For Play Store submission):
   ```bash
   flutter build appbundle --release
   ```
6. **Publish**:
   Upload `.aab` file to Google Play Console. Fill out Data Safety forms, paying special attention to Location, Photos, and Personal Info usage.

### Apple iOS (App Store)
Target Phase 1: Infopark Kochi tech professionals using iPhones.

1. **Enroll**: Register for the Apple Developer Program.
2. **Configure Xcode**:
   Open `ios/Runner.xcworkspace`. Set Bundle Identifier (`com.techconnect.app`). Enable "Automatically manage signing" with your Team.
3. **Permissions (Info.plist)**:
   Ensure string descriptions exist for:
   - `NSCameraUsageDescription` (Take selfies to verify identity)
   - `NSPhotoLibraryUsageDescription` (Upload profile pictures)
   - `NSLocationWhenInUseUsageDescription` (Find tech professionals nearby)
4. **Build Archive**:
   ```bash
   flutter build ipa --release
   ```
5. **Publish**:
   Upload to App Store Connect via Xcode or Apple Transporter. Submit for TestFlight beta testing or App Store review. Make sure to provide a test account to Apple Reviewers that bypasses the corporate email restriction or has a pre-verified corporate test domain.

---

## 2. Security Best Practices

Dating apps hold highly sensitive personal information. Protection is paramount:

- **Row Level Security (RLS)**: Enforce strict PostgreSQL RLS policies in Supabase. A user should only be able to view profiles that are not banned, and can only read/write messages in matches where they are a participant.
- **Obfuscate Exact Location**: Never store or transmit raw high-precision GPS coordinates directly to the client app. Instead, round longitude/latitude coordinates (e.g., using PostGIS `ST_SnapToGrid`) or just store the broad geographical "Cluster" (e.g., "Infopark Kochi Cluster").
- **HTTPS & SSL**: All API traffic runs over HTTPS by default via Supabase.
- **Rate Limiting (API & Edge Functions)**: Use Supabase API rate limits to block brute-force attacks on the auth endpoints and scraping attempts on the profiles endpoint.
- **Secure Image Uploads**: Profile images uploaded to Supabase Storage should have policies restricting uploads to authenticated users, with a maximum file size limit (e.g., `5MB`) and strict mime-type checks (`image/jpeg`, `image/png`).

---

## 3. Fake Profile & Bot Prevention Recommendations

The core value proposition of TechConnect is authenticity.

1. **Strict Corporate Domain Firewall**:
   - The primary defense. Only domains like `@ust.com`, `@infosys.com` are permitted. Free email providers (Gmail, Yahoo) and disposable email domains must be rejected at the Edge Function level.
2. **Liveness & Selfie Verification**:
   - Do not just accept an uploaded photo. Require users to use the live camera to perform a random motion (e.g., "turn head left", "smile") using an SDK like AWS Rekognition, Azure Face API, or specialized third parties like Onfido/Smile Identity. Compare this live capture with uploaded profile photos.
3. **Reverse Image Checking**:
   - Trigger a backend job upon photo upload that runs the image through a reverse-image search API (like TinEye or Google Cloud Vision) to check if the user is using stock photography or images of celebrities.
4. **Behavioral Heuristics (Anti-Spam)**:
   - Identify bot patterns: Swiping right 100 times in 10 seconds, sending the exact same "Hi" message to 50 matches immediately.
   - Automatically shadow-ban or flag accounts exhibiting these behaviors for Admin review.
5. **Trust Score Economy**:
   - Utilize the `trust_score` column. If a user is only 20% complete and lacks a selfie verification, heavily deprioritize them in the discovery engine algorithm until they verify.
6. **Community Reporting**:
   - Make it extremely easy to Report or Block a user for "Fake Profile / Scammer" or "Inappropriate Behavior". If an account receives 3 reports within an hour, automatically suspend the account pending manual review.
