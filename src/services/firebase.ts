import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
    apiKey: "AIzaSyDSHopObrg8qgYIPjt8WrvGxWeeX17cCdk",
    authDomain: "cicatriza-73116.firebaseapp.com",
    projectId: "cicatriza-10ff2",
    storageBucket: "cicatriza-10ff2.firebasestorage.app",
    messagingSenderId: "245471573518",
    appId: "1:357071264744:android:8db0220e645bbb5013a25d",
    measurementId: "G-6G2FXP97X3"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);