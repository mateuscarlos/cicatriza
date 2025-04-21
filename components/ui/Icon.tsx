import LucideIcon from '@tamagui/lucide-icons';

export function Icon({ name, size = 18, color = '#000', ...props }) {
  return <LucideIcon name={name} size={size} color={color} {...props} />;
}