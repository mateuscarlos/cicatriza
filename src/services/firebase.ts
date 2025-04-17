import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';

// Configurações do Firebase copiadas do console
const firebaseConfig = {
    apiKey: "AIzaSyBUJcTp9RaxXJ2aaLPhiZYuNfsxgnSJ-WQ",
    authDomain: "cicatriza-73116.firebaseapp.com",
    projectId: "cicatriza-73116",
    storageBucket: "cicatriza-73116.firebasestorage.app",
    messagingSenderId: "245471573518",
    appId: "1:245471573518:web:73ac7a11a0a0d546d26e5f",
    measurementId: "G-6G2FXP97X3"
  };

// Inicializar o Firebase
const app = initializeApp(firebaseConfig);

// Exportar o Firestore
export const db = getFirestore(app);