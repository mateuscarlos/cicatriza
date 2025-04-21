import React from 'react';
import { Pressable, StyleSheet } from 'react-native';
import * as Linking from 'expo-linking';

interface ExternalLinkProps {
  href: string;
  children: React.ReactNode;
  style?: any;
}

export function ExternalLink({ href, children, style }: ExternalLinkProps) {
  return (
    <Pressable
      style={({pressed}) => [
        styles.link,
        style,
        { opacity: pressed ? 0.7 : 1 }
      ]}
      onPress={() => Linking.openURL(href)}>
      {children}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  link: {
    marginVertical: 4,
  },
});
