import { useState } from 'react';
import { ScrollView } from 'react-native';
import { collection, addDoc } from 'firebase/firestore';
import { db } from '../../src/services/firebase';
import { Patient } from '../../components/interfaces/interfaces.firestore';
import { YStack, Input, Button, Label, H1, Separator } from 'tamagui';

export default function AddPatientScreen() {
  const [patient, setPatient] = useState<Patient>({
    id: '',
    name: '',
    birthDate: '',
    age: 0,
    weight: 0,
    gender: '',
    comorbidities: [],
    medications: [],
    allergies: [],
    smoker: false,
    alcohol: false,
    notes: '',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  });

  const handleAddPatient = async () => {
    try {
      const docRef = await addDoc(collection(db, 'patients'), {
        ...patient,
        comorbidities: patient.comorbidities.map((item) => item.trim()),
        medications: patient.medications.map((item) => item.trim()),
        allergies: patient.allergies.map((item) => item.trim()),
      });
      console.log('Paciente adicionado com ID:', docRef.id);
      alert('Paciente adicionado com sucesso!');
    } catch (error) {
      console.error('Erro ao adicionar paciente:', error);
      alert('Erro ao adicionar paciente.');
    }
  };

  return (
    <ScrollView contentContainerStyle={{ flexGrow: 1, padding: 16 }}>
      <YStack space="$4" padding="$4">
        <H1>Adicionar Paciente</H1>
        <Separator />

        <Label htmlFor="name">Nome</Label>
        <Input
          id="name"
          placeholder="Nome"
          value={patient.name}
          onChangeText={(text) => setPatient({ ...patient, name: text })}
        />

        <Label htmlFor="birthDate">Data de Nascimento (YYYY-MM-DD)</Label>
        <Input
          id="birthDate"
          placeholder="Data de Nascimento"
          value={patient.birthDate}
          onChangeText={(text) => setPatient({ ...patient, birthDate: text })}
        />

        <Label htmlFor="age">Idade</Label>
        <Input
          id="age"
          placeholder="Idade"
          keyboardType="numeric"
          value={patient.age.toString()}
          onChangeText={(text) => setPatient({ ...patient, age: parseInt(text) || 0 })}
        />

        <Label htmlFor="weight">Peso (kg)</Label>
        <Input
          id="weight"
          placeholder="Peso"
          keyboardType="numeric"
          value={patient.weight.toString()}
          onChangeText={(text) => setPatient({ ...patient, weight: parseFloat(text) || 0 })}
        />

        <Label htmlFor="gender">Gênero</Label>
        <Input
          id="gender"
          placeholder="Gênero"
          value={patient.gender}
          onChangeText={(text) => setPatient({ ...patient, gender: text })}
        />

        <Label htmlFor="comorbidities">Comorbidades (separadas por vírgula)</Label>
        <Input
          id="comorbidities"
          placeholder="Comorbidades"
          value={patient.comorbidities.join(', ')}
          onChangeText={(text) =>
            setPatient({ ...patient, comorbidities: text.split(',').map((item) => item.trim()) })
          }
        />

        <Label htmlFor="medications">Medicações (separadas por vírgula)</Label>
        <Input
          id="medications"
          placeholder="Medicações"
          value={patient.medications.join(', ')}
          onChangeText={(text) =>
            setPatient({ ...patient, medications: text.split(',').map((item) => item.trim()) })
          }
        />

        <Label htmlFor="allergies">Alergias (separadas por vírgula)</Label>
        <Input
          id="allergies"
          placeholder="Alergias"
          value={patient.allergies.join(', ')}
          onChangeText={(text) =>
            setPatient({ ...patient, allergies: text.split(',').map((item) => item.trim()) })
          }
        />

        <Label htmlFor="smoker">Fumante</Label>
        <Input
          id="smoker"
          placeholder="Sim ou Não"
          value={patient.smoker ? 'Sim' : 'Não'}
          onChangeText={(text) =>
            setPatient({ ...patient, smoker: text.toLowerCase() === 'sim' })
          }
        />

        <Label htmlFor="alcohol">Consome Álcool</Label>
        <Input
          id="alcohol"
          placeholder="Sim ou Não"
          value={patient.alcohol ? 'Sim' : 'Não'}
          onChangeText={(text) =>
            setPatient({ ...patient, alcohol: text.toLowerCase() === 'sim' })
          }
        />

        <Label htmlFor="notes">Notas Adicionais</Label>
        <Input
          id="notes"
          placeholder="Notas"
          value={patient.notes || ''}
          onChangeText={(text) => setPatient({ ...patient, notes: text })}
        />

        <Button onPress={handleAddPatient}>Salvar Paciente</Button>
      </YStack>
    </ScrollView>
  );
}