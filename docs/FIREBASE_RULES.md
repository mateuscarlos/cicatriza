# 🔐 Regras de Segurança do Firebase

## Firestore

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }

    match /patients/{patientId} {
      allow read, write: if request.auth.uid != null;
    }

    match /visits/{visitId} {
      allow read, write: if request.auth.uid != null;
    }

    match /prescriptions/{id} {
      allow read: if request.auth.uid != null;
    }

    match /documents/{id} {
      allow read, write: if request.auth.uid != null;
    }
  }
}
```

## Storage

```js
service firebase.storage {
  match /b/{bucket}/o {
    match /documents/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Claims Customizadas (via Admin SDK)

- `admin`
- `estomaterapeuta`
- `colaborador`
