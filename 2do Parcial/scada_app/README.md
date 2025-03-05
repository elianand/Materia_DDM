# scada_app

Este es el proyecto final de la materia titulada
"Desarrollo de dispositivos moviles"

## Usuarios para autentificarse

UserMail                Password 
elian@gmail.com        eliangmail
elian2@gmail.com        eliangmail

## COMO CREAR USUARIOS NUEVOS

Para ello se tiene que ser admin de la base
1) Ir a https://console.firebase.google.com/u/3/project/dddm-scada/authentication/users
y generar un usuario nuevo con email y pass cualquiera
2) Ir a https://console.cloud.google.com/firestore/databases/-default-/data/panel/users?authuser=3&hl=en&project=dddm-scada
Y duplicar un usuario con solo los campos accessLevel, idComp y uid con el que creamos el usuario

## Para moficar la version del sdk de android tengo que ir a 

C:\Users\elian\dev\flutter\packages\flutter_tools\gradle\src\main\groovy\flutter.groovy


## Para limpiar el proyecto volverle a hacer un build 

flutter clean para limpiar el proyecto
flutter pub get para volver a cargar. Ademas tenemos que ejecutarlo por primera vez