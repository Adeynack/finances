import { useContext } from 'react';
import { OptionsContext, OptionsSetterContext } from './Options';
import { Select } from 'antd';

export function ThemeSwitcher(): JSX.Element {
  const { theme } = useContext(OptionsContext);
  const { changeOptions: setOptions } = useContext(OptionsSetterContext);

  return (
    <Select
      value={theme}
      onChange={(value) => setOptions({ theme: value })}
      options={[
        { value: 'light', label: 'Light' },
        { value: 'dark', label: 'Dark' },
      ]}
    />
  );
}
