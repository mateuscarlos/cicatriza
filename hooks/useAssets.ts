import { useState, useEffect } from 'react';
import { Asset } from 'expo-asset';

/**
 * Hook for loading and managing assets in React Native
 * 
 * This hook loads specified assets and tracks loading state and errors.
 * It's particularly useful for loading 3D models, images, or other resources
 * that need to be loaded asynchronously before use.
 * 
 * @param assetRequires - Array of require statements for assets to load
 * @returns [loadedAssets, error, loading] - The loaded assets, any error, and loading state
 */
export function useAssets(assetRequires: number[] | string[]) {
  const [loadedAssets, setLoadedAssets] = useState<Asset[] | null>(null);
  const [error, setError] = useState<Error | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  
  useEffect(() => {
    let isMounted = true;
    
    const loadAssets = async () => {
      try {
        setLoading(true);
        setError(null);
        
        // Create Asset objects from the require statements
        const assets = assetRequires.map(asset => 
          typeof asset === 'string' ? Asset.fromURI(asset) : Asset.fromModule(asset)
        );
        
        // Download all assets asynchronously
        await Promise.all(assets.map(asset => asset.downloadAsync()));
        
        // Only update state if the component is still mounted
        if (isMounted) {
          setLoadedAssets(assets);
          setError(null);
        }
      } catch (err) {
        // Handle errors during asset loading
        if (isMounted) {
          setError(err instanceof Error ? err : new Error('Failed to load assets'));
          console.error('Error loading assets:', err);
        }
      } finally {
        if (isMounted) {
          setLoading(false);
        }
      }
    };
    
    loadAssets();
    
    // Cleanup function
    return () => {
      isMounted = false;
    };
  }, [JSON.stringify(assetRequires)]); // Re-run if the asset list changes

  return [loadedAssets, error, loading];
}