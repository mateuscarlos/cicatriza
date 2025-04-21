import React from 'react';
import { View, StyleSheet, ViewStyle, ViewProps } from 'react-native';
import { useColorScheme } from '../hooks/useColorScheme';

interface ThemedViewProps extends ViewProps {
  children: React.ReactNode;
  style?: ViewStyle;
}

export function ThemedView({ children, style, ...otherProps }: ThemedViewProps) {
  const colorScheme = useColorScheme();
  
  const backgroundColor = colorScheme === 'dark' ? '#000' : '#fff';
  
  return (
    <View style={[{ backgroundColor }, style]} {...otherProps}>
      {children}
    </View>
  );
}
