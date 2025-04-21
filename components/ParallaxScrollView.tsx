import React from 'react';
import { 
  ScrollView, 
  StyleSheet, 
  View, 
  useWindowDimensions, 
  ViewStyle, 
  StyleProp 
} from 'react-native';
import Animated, { 
  useAnimatedScrollHandler, 
  useAnimatedStyle, 
  useSharedValue, 
  interpolate 
} from 'react-native-reanimated';
import { useColorScheme } from '../hooks/useColorScheme';

const HEADER_HEIGHT = 300;

interface ParallaxScrollViewProps {
  children: React.ReactNode;
  headerBackgroundColor?: {
    light: string;
    dark: string;
  };
  headerImage?: React.ReactNode;
  contentContainerStyle?: StyleProp<ViewStyle>;
}

export default function ParallaxScrollView({ 
  children, 
  headerBackgroundColor = { light: '#f0f0f0', dark: '#222' }, 
  headerImage,
  contentContainerStyle
}: ParallaxScrollViewProps) {
  const { width } = useWindowDimensions();
  const colorScheme = useColorScheme();
  const scrollY = useSharedValue(0);
  
  const scrollHandler = useAnimatedScrollHandler({
    onScroll: (event) => {
      scrollY.value = event.contentOffset.y;
    },
  });

  const headerAnimatedStyle = useAnimatedStyle(() => {
    return {
      transform: [
        {
          translateY: interpolate(
            scrollY.value,
            [-HEADER_HEIGHT, 0, HEADER_HEIGHT],
            [HEADER_HEIGHT / 2, 0, -HEADER_HEIGHT / 3],
            'clamp'
          ),
        },
      ],
    };
  });

  const contentAnimatedStyle = useAnimatedStyle(() => {
    return {
      paddingTop: HEADER_HEIGHT,
      transform: [
        {
          translateY: interpolate(
            scrollY.value,
            [0, HEADER_HEIGHT],
            [0, -HEADER_HEIGHT / 2],
            'clamp'
          ),
        },
      ],
    };
  });

  return (
    <View style={styles.container}>
      <Animated.View 
        style={[
          styles.header, 
          { backgroundColor: headerBackgroundColor[colorScheme] },
          headerAnimatedStyle,
        ]}
      >
        {headerImage}
      </Animated.View>
      
      <Animated.ScrollView
        showsVerticalScrollIndicator={false}
        scrollEventThrottle={16}
        onScroll={scrollHandler}
        contentContainerStyle={[
          styles.scrollContent,
          contentContainerStyle,
          contentAnimatedStyle,
        ]}
      >
        <View style={[styles.content, { width }]}>
          {children}
        </View>
      </Animated.ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    height: HEADER_HEIGHT,
    overflow: 'hidden',
  },
  scrollContent: {
    minHeight: '100%',
  },
  content: {
    flex: 1,
    padding: 20,
    gap: 16,
  },
});
