import React, { useState } from 'react';
import { StyleSheet, View, TouchableOpacity, Image, TextInput } from 'react-native';
import { useRouter } from 'expo-router';
import { ThemedText } from '../components/ThemedText';
import { ThemedView } from '../components/ThemedView';

// Define the type for logged in user
interface LoggedInUser {
  name: string;
  email: string;
}

// Extend the global object
declare global {
  let loggedInUser: LoggedInUser | undefined;
}

export default function LoginScreen() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleLogin = () => {
    // Validação simplificada
    if (!email || !password) {
      setError('Por favor, preencha todos os campos');
      return;
    }

    // Mock de autenticação
    // Em uma aplicação real, isso seria uma chamada de API
    if (email === 'demo@cicatriza.com' && password === '123456') {
      // Armazenar nome do usuário (em uma aplicação real, isso viria da API)
      // Normalmente usaríamos AsyncStorage ou um gerenciador de estado
      global.loggedInUser = {
        name: 'Dr. Roberto Santos',
        email: email
      };
      
      router.replace('/');
    } else {
      setError('Email ou senha incorretos');
    }
  };

  return (
    <ThemedView style={styles.container}>
      <View style={styles.logoContainer}>
        {/* Substitua pelo seu logo real ou remova se não tiver */}
        <View style={styles.logoPlaceholder}>
          <ThemedText style={{fontSize: 24}}>Cicatriza</ThemedText>
        </View>
        <ThemedText type="title" style={styles.appName}>Cicatriza</ThemedText>
      </View>

      <View style={styles.formContainer}>
        <ThemedText type="subtitle" style={styles.formTitle}>Login</ThemedText>
        
        {error ? <ThemedText style={styles.errorText}>{error}</ThemedText> : null}
        
        <View style={styles.inputContainer}>
          <ThemedText>Email</ThemedText>
          <TextInput
            style={styles.input}
            placeholder="Seu email"
            value={email}
            onChangeText={setEmail}
            keyboardType="email-address"
            autoCapitalize="none"
          />
        </View>
        
        <View style={styles.inputContainer}>
          <ThemedText>Senha</ThemedText>
          <TextInput
            style={styles.input}
            placeholder="Sua senha"
            value={password}
            onChangeText={setPassword}
            secureTextEntry
          />
        </View>
        
        <TouchableOpacity style={styles.loginButton} onPress={handleLogin}>
          <ThemedText style={styles.buttonText}>Entrar</ThemedText>
        </TouchableOpacity>
        
        <ThemedText style={styles.helpText}>
          Use demo@cicatriza.com / 123456 para testar
        </ThemedText>
      </View>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    padding: 20,
  },
  logoContainer: {
    alignItems: 'center',
    marginBottom: 40,
  },
  logoPlaceholder: {
    width: 100,
    height: 100,
    backgroundColor: '#f0f0f0',
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 50,
    marginBottom: 10,
  },
  appName: {
    fontSize: 28,
    fontWeight: 'bold',
  },
  formContainer: {
    backgroundColor: '#f8f8f8',
    borderRadius: 10,
    padding: 20,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  formTitle: {
    textAlign: 'center',
    marginBottom: 20,
  },
  inputContainer: {
    marginBottom: 15,
  },
  input: {
    backgroundColor: 'white',
    paddingHorizontal: 12,
    paddingVertical: 10,
    borderRadius: 5,
    borderWidth: 1,
    borderColor: '#ddd',
    marginTop: 5,
  },
  loginButton: {
    backgroundColor: '#4285F4',
    paddingVertical: 12,
    borderRadius: 5,
    alignItems: 'center',
    marginTop: 10,
  },
  buttonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  errorText: {
    color: 'red',
    textAlign: 'center',
    marginBottom: 15,
  },
  helpText: {
    textAlign: 'center',
    marginTop: 15,
    fontSize: 12,
    color: '#666',
  },
});