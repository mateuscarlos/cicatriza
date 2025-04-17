import { collection, addDoc, getDocs } from 'firebase/firestore';
import { db } from '../services/firebase';

const addPatient = async () => {
  try {
    const docRef = await addDoc(collection(db, 'patients'), {
      name: 'João Silva',
      age: 45,
    });
    console.log('Paciente adicionado com ID:', docRef.id);
  } catch (e) {
    console.error('Erro ao adicionar paciente:', e);
  }
};

const fetchPatients = async () => {
  try {
    const querySnapshot = await getDocs(collection(db, 'patients'));
    querySnapshot.forEach((doc) => {
      console.log(`${doc.id} =>`, doc.data());
    });
  } catch (e) {
    console.error('Erro ao buscar pacientes:', e);
  }
};

addPatient();
fetchPatients();