import React from 'react';
import { Pressable, StyleSheet, View, Text } from 'react-native';
import { Link } from 'expo-router';
import * as Haptics from 'expo-haptics';

type HapticTabProps = {
  name: string;
  label: string;
  icon: (props: { color: string; size: number }) => React.ReactNode;
  focused: boolean;
};

const HapticTab = ({ name, label, icon, focused }: HapticTabProps) => {
  return (
    <Pressable
      onPress={() => {
        Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
      }}
      style={styles.tabContainer}
    >
      <Link href={`/${name}`} style={styles.tabLink}>
        <View style={styles.tabContent}>
          {icon({
            color: focused ? '#007AFF' : '#8E8E93',
            size: 24,
          })}
          <Text style={[styles.tabLabel, { color: focused ? '#007AFF' : '#8E8E93' }]}>
            {label}
          </Text>
        </View>
      </Link>
    </Pressable>
  );
};

const styles = StyleSheet.create({
  tabContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  tabLink: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    width: '100%',
  },
  tabContent: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  tabLabel: {
    fontSize: 10,
    marginTop: 2,
  },
});

export default HapticTab;
