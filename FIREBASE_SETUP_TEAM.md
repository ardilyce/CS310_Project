# Firebase Kurulum Rehberi - Grup Üyeleri İçin

Bu rehber, ortak Firebase projesine erişim ve kurulum adımlarını içerir. Tüm grup üyeleri aynı Firebase projesini kullanacak.

## 🎯 Adım 1: Firebase Projesine Erişim

### Grup Lideri İçin - Üyeleri Ekleme:

1. [Firebase Console](https://console.firebase.google.com/) → `phishguard-app-cs310` projesini seçin
2. **Project Settings** (⚙️) → **Users and permissions** sekmesi
3. **"Add member"** → Grup üyelerinin email'lerini girin
4. **Role:** "Editor" seçin → **"Add"**

Grup üyeleri email'lerine davet alacak.

### Grup Üyeleri İçin:

1. Email'inizdeki Firebase davet linkine tıklayın
2. Veya [Firebase Console](https://console.firebase.google.com/) → `phishguard-app-cs310` projesini seçin

## 📱 Adım 2: google-services.json İndirme

1. Firebase Console → **Project Settings** (⚙️)
2. **"Your apps"** → Android app'in yanındaki **⚙️** ikonuna tıklayın
3. **"Download google-services.json"** → İndirin
4. Dosyayı `android/app/` klasörüne kopyalayın

## 📝 Adım 3: firebase_options.dart Kontrolü

1. `lib/utils/firebase_options.dart` dosyasını açın
2. Eğer `YOUR_*` placeholder'ları varsa:

### Android için:
`google-services.json` dosyasından bilgileri alın ve güncelleyin:
- `apiKey`: `client[0].api_key[0].current_key`
- `appId`: `client[0].client_info.mobilesdk_app_id`
- `messagingSenderId`: `project_info.project_number`
- `projectId`: `project_info.project_id`
- `storageBucket`: `project_info.storage_bucket`

### Web için:
Firebase Console → Project Settings → Your apps → Web app → ⚙️
Yapılandırma bilgilerini kopyalayıp güncelleyin.

**Not:** Dosya zaten güncellenmişse (placeholder'lar yoksa), değiştirmenize gerek yok.

## ⚙️ Adım 4: Gradle Kontrolü

Kontrol edin (zaten yapılmış olmalı):

- `android/settings.gradle.kts`: `id("com.google.gms.google-services") version "4.4.4" apply false`
- `android/app/build.gradle.kts`: `id("com.google.gms.google-services")`

## 🔐 Adım 5: Authentication Kontrolü

Firebase Console → **Authentication** → **Sign-in method**
- Email/Password **Enabled** olmalı
- Değilse: Enable yapın

## 🗄️ Adım 6: Firestore Kontrolü

Firebase Console → **Firestore Database**
- Database görünüyorsa: ✅ Hazır
- "Create database" görünüyorsa: Test mode'da oluşturun

## 🧪 Adım 7: Test

```bash
flutter pub get
flutter run
```

- Sign up yapın
- Login yapın
- Firebase Console → Authentication → Users'da kontrol edin

## ✅ Kontrol Listesi

- [ ] Firebase projesine erişim var
- [ ] `google-services.json` dosyası `android/app/` klasöründe
- [ ] `firebase_options.dart` güncellendi (placeholder'lar yok)
- [ ] Authentication etkin
- [ ] Firestore mevcut
- [ ] Uygulama çalışıyor

## 🐛 Sorun Giderme

**Authentication çalışmıyor:**
- Email/Password provider'ının etkin olduğunu kontrol edin
- Terminal'deki hata mesajlarını kontrol edin (❌ işaretiyle başlayan)

**Firebase initialization hatası:**
- `firebase_options.dart` dosyasındaki placeholder'ları kontrol edin

**Gradle hatası:**
```bash
flutter clean
flutter pub get
flutter run
```

## 🔗 Ortak Proje Kullanımı

✅ **Aynı Authentication** - Tüm kullanıcılar ortak  
✅ **Aynı Firestore Database** - Tüm veriler paylaşılıyor  
✅ **Gerçek zamanlı senkronizasyon**

⚠️ **Dikkat:**
- Test verileri eklerken dikkatli olun
- Önemli verileri silmeden önce grup üyelerine danışın

---

**Not:** Tüm grup üyeleri aynı `firebase_options.dart` dosyasını kullanmalı (Git'ten çekebilirsiniz).

