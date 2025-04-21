import React from 'react';
import { Text, StyleSheet, TextStyle, TextProps } from 'react-native';
import { useColorScheme } from '../hooks/useColorScheme';

interface ThemedTextProps extends TextProps {
  children: React.ReactNode;
  type?: 'default' | 'defaultSemiBold' | 'title' | 'subtitle' | 'small' | 'link';
  style?: TextStyle;
}

export function ThemedText({ children, type = 'default', style, ...otherProps }: ThemedTextProps) {
  const colorScheme = useColorScheme();
  
  const baseStyle = {
    color: colorScheme === 'dark' ? '#fff' : '#000',
    ...styles[type],
  };
  
  const linkStyle = type === 'link' ? {
    color: colorScheme === 'dark' ? '#63a4ff' : '#0066cc',
  } : {};
  
  return (
    <Text style={[baseStyle, linkStyle, style]} {...otherProps}>
      {children}
    </Text>
  );
}

const styles = StyleSheet.create({
  default: {
    fontSize: 16,
    lineHeight: 24,
  },
  defaultSemiBold: {
    fontSize: 16,
    lineHeight: 24,
    fontWeight: '600',
  },
  title: {
    fontSize: 28,
    lineHeight: 34,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 20,
    lineHeight: 26,
    fontWeight: '600',
    marginBottom: 4,
  },
  small: {
    fontSize: 14,
    lineHeight: 20,
  },
  link: {
    fontSize: 16,
    lineHeight: 24,
    textDecorationLine: 'underline',
  },
});
