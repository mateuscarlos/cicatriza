import React, { useState } from 'react';
import { StyleSheet, View, TouchableOpacity, KeyboardAvoidingView, Platform, ScrollView } from 'react-native';
import { Button, Layout, Text, Input, Icon } from '@ui-kitten/components';
import { Stack, router } from 'expo-router';

export default function RegisterScreen() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [secureTextEntry, setSecureTextEntry] = useState(true);

  const toggleSecureEntry = (): void => {
    setSecureTextEntry(!secureTextEntry);
  };

  const renderPasswordIcon = (props: any) => (
    <TouchableOpacity onPress={toggleSecureEntry}>
      <Icon {...props} name={secureTextEntry ? 'eye-off' : 'eye'}/>
    </TouchableOpacity>
  );

  return (
    <KeyboardAvoidingView 
      style={{ flex: 1 }} 
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <Stack.Screen options={{ 
        title: 'Registro',
        headerLeft: () => (
          <TouchableOpacity onPress={() => router.back()}>
            <Icon name='arrow-back' style={styles.backIcon} />
          </TouchableOpacity>
        )
      }} />
      
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <Layout style={styles.container}>
          <Text category='h1' style={styles.title}>Crie sua conta</Text>
          
          <View style={styles.formContainer}>
            <Input
              label='Nome'
              placeholder='Digite seu nome completo'
              value={name}
              onChangeText={setName}
              style={styles.input}
            />
            
            <Input
              label='Email'
              placeholder='Digite seu email'
              value={email}
              onChangeText={setEmail}
              keyboardType="email-address"
              autoCapitalize="none"
              style={styles.input}
            />
            
            <Input
              label='Senha'
              placeholder='Crie uma senha segura'
              value={password}
              onChangeText={setPassword}
              accessoryRight={renderPasswordIcon}
              secureTextEntry={secureTextEntry}
              style={styles.input}
            />
            
            <Button style={styles.registerButton}>
              REGISTRAR
            </Button>
          </View>
          
          <View style={styles.loginContainer}>
            <Text appearance='hint'>Já tem uma conta? </Text>
            <TouchableOpacity onPress={() => router.push('/login')}>
              <Text status='primary'>Faça login</Text>
            </TouchableOpacity>
          </View>
        </Layout>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  scrollContainer: {
    flexGrow: 1,
  },
  container: {
    flex: 1,
    padding: 20,
  },
  backIcon: {
    width: 24,
    height: 24,
    marginLeft: 10,
  },
  title: {
    marginTop: 20,
    marginBottom: 30,
    textAlign: 'center',
    fontWeight: 'bold',
  },
  formContainer: {
    marginBottom: 30,
  },
  input: {
    marginBottom: 16,
  },
  registerButton: {
    marginTop: 10,
  },
  loginContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
    marginTop: 20,
  },
});