/*
keytool -genkey -v -keystore c:\Users\gunas\key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key


#key.properties
storePassword=ellipse@
keyPassword=ellipse@
keyAlias=key
storeFile=c:/Users/gunas/key.jks

#app/build.gradle

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}


signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }


#build bundle
flutter build appbundle

#build apk
flutter build apk --split-per-abi

#build web app
flutter channel dev  (in terminal)
flutter create .  (creates necessary files for web app)
flutter build web
flutter run -d chrome



Build flavor only work for Android. So, if you want to run as development mode you can use this command.
flutter run -t lib/main_development.dart --flavor development -d <device_id>
or in production mode.

flutter run --release -t lib/main_production.dart --flavor production -d <device_id>
Note: If you want to build and release this app to Play Store. Please use this command.

flutter build appbundle --release --flavor production -t lib/main_production.dart
For iOS, you can use this command as development mode.
flutter run -t lib/main_development.dart -d <device_id>
or in production mode.

flutter run --release -t lib/main_production.dart -d <device_id>
For iOS, to build and release there is no configuration. Just follow the instructions from the documentation.

*/