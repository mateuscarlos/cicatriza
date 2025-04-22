import React, { useRef, useEffect } from 'react';
import { View, ActivityIndicator, StyleSheet, PanResponder } from 'react-native';
import { GLView } from 'expo-gl';
import { Renderer } from 'expo-three';
import * as THREE from 'three';
import { Asset } from 'expo-asset';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';

type Props = {
  gender: 'male' | 'female';
  onSelectPoint: (point: { x: number; y: number; z: number }) => void;
  selectedPoint: { x: number; y: number; z: number } | null;
};

export default function Human3DModel({ gender, onSelectPoint, selectedPoint }: Props) {
  const modelRef = useRef<THREE.Object3D | null>(null);
  const cameraRef = useRef<THREE.PerspectiveCamera | null>(null);
  const sceneRef = useRef<THREE.Scene | null>(null);
  const rendererRef = useRef<Renderer | null>(null);
  const pan = useRef({ x: 0, y: 0 });

  // Carregue o modelo 3D
  const getModelAsset = () =>
    gender === 'male'
      ? require('../../assets/models/model-male.glb')
      : require('../../assets/models/model-female.glb');

  const onContextCreate = async (gl) => {
    const { drawingBufferWidth: width, drawingBufferHeight: height } = gl;
    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0xf8f8f8);

    const camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
    camera.position.z = 2.5;

    const renderer = new Renderer({ gl });
    renderer.setSize(width, height);

    // Luz
    const light = new THREE.DirectionalLight(0xffffff, 1);
    light.position.set(0, 2, 2);
    scene.add(light);

    // Carregar modelo
    const asset = Asset.fromModule(getModelAsset());
    await asset.downloadAsync();
    const loader = new GLTFLoader();
    loader.load(
      asset.localUri || asset.uri,
      (gltf) => {
        modelRef.current = gltf.scene;
        scene.add(gltf.scene);
      }
    );

    sceneRef.current = scene;
    cameraRef.current = camera;
    rendererRef.current = renderer;

    // Render loop
    const render = () => {
      requestAnimationFrame(render);
      renderer.render(scene, camera);
      gl.endFrameEXP();
    };
    render();
  };

  // Rotação do modelo com gesto
  const panResponder = PanResponder.create({
    onMoveShouldSetPanResponder: () => true,
    onPanResponderMove: (_, gesture) => {
      if (modelRef.current) {
        modelRef.current.rotation.y += gesture.dx * 0.01;
        modelRef.current.rotation.x += gesture.dy * 0.01;
      }
    },
  });

  // Toque para marcar ponto (simplificado)
  const handleTouch = (event) => {
    // Aqui você pode converter a posição do toque para coordenadas do modelo 3D
    // Para simplificação, marque um ponto fixo no centro
    onSelectPoint({ x: 0, y: 1, z: 0 });
  };

  return (
    <View style={styles.container} {...panResponder.panHandlers}>
      <GLView
        style={styles.glview}
        onContextCreate={onContextCreate}
        onTouchEnd={handleTouch}
      />
      {!selectedPoint && (
        <View style={styles.overlay}>
          <ActivityIndicator size="large" color="#4285F4" />
        </View>
      )}
      {selectedPoint && (
        <View style={styles.marker} pointerEvents="none" />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { width: '100%', height: 350, backgroundColor: '#f8f8f8' },
  glview: { flex: 1 },
  overlay: {
    ...StyleSheet.absoluteFillObject,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(255,255,255,0.7)',
  },
  marker: {
    position: 'absolute',
    left: '50%',
    top: '40%',
    width: 18,
    height: 18,
    borderRadius: 9,
    backgroundColor: 'red',
    borderWidth: 2,
    borderColor: '#fff',
    zIndex: 10,
  },
});