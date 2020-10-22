/*
final unixTime =
        (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();
FlareActor(
                    'assets/splash.flr',
                    alignment: Alignment.center,
                    animation: 'logo',
                    fit: BoxFit.cover,
                  )),

keytool -genkey -v -keystore c:\Users\gunas\key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key
keytool -list -v -keystore debug.keystore -alias androiddebugkey

_handleDeepLink | deeplink: https://www.compound.com/post?title=This+is+my+first+post

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
flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abif
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



https://us-central1-ellipse-e2428.cloudfunctions.net/sendNotification?token=dMdgIai6QdORMuRgvxCN-2:APA91bHDeXoFeEZHivVttFzbBVbyj2jOJVbMx2Y2YJC4Qa94r8b4RoH4EO0LeNku2MXFgH_vM-RM6y0zL0JxdvVIALWp-qdzo68Ix7Wy5ERJXdzFC44lOwRFnqZAkGXoyVRUmM7VrMc3&title=sfdef&message=segfr
*/
