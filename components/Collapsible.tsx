import React, { useState } from 'react';
import { StyleSheet, Pressable, View } from 'react-native';
import Animated, { 
  useAnimatedStyle, 
  withTiming, 
  interpolate, 
  Easing 
} from 'react-native-reanimated';
import { Ionicons } from '@expo/vector-icons';
import { useColorScheme } from '../hooks/useColorScheme';
import { ThemedText } from './ThemedText';

interface CollapsibleProps {
  title: string;
  children: React.ReactNode;
}

export function Collapsible({ title, children }: CollapsibleProps) {
  const [expanded, setExpanded] = useState(false);
  const colorScheme = useColorScheme();
  
  const animatedStyle = useAnimatedStyle(() => {
    return {
      height: expanded 
        ? withTiming('auto', { duration: 300, easing: Easing.bezier(0.25, 0.1, 0.25, 1) }) 
        : withTiming(0, { duration: 300, easing: Easing.bezier(0.25, 0.1, 0.25, 1) }),
      opacity: withTiming(expanded ? 1 : 0, { duration: 300 }),
      overflow: 'hidden',
    };
  });
  
  const iconStyle = useAnimatedStyle(() => {
    const rotation = interpolate(
      expanded ? 1 : 0,
      [0, 1],
      [0, 90]
    );
    
    return {
      transform: [{ rotate: `${rotation}deg` }],
    };
  });
  
  return (
    <View style={styles.container}>
      <Pressable 
        onPress={() => setExpanded(!expanded)} 
        style={({pressed}) => [
          styles.header,
          { opacity: pressed ? 0.7 : 1 }
        ]}
      >
        <ThemedText type="defaultSemiBold">{title}</ThemedText>
        <Animated.View style={iconStyle}>
          <Ionicons 
            name="chevron-forward" 
            size={20} 
            color={colorScheme === 'dark' ? '#fff' : '#000'} 
          />
        </Animated.View>
      </Pressable>
      
      <Animated.View style={[styles.content, animatedStyle]}>
        {children}
      </Animated.View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginVertical: 8,
    borderRadius: 8,
    overflow: 'hidden',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
  },
  content: {
    paddingHorizontal: 16,
    paddingBottom: 16,
    gap: 16,
  },
});
