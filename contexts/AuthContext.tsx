import React, { createContext, useContext, useState } from 'react';

// Define a basic User type, adjust properties as needed
interface User {
  id: string;
  name: string;
  // Add other relevant user properties here
}

const AuthContext = createContext(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null); // Use the User type here too

const login = (userData: User) => setUser(userData);
  const logout = () => setUser(null);

  return (
    <AuthContext.Provider value={{ user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}