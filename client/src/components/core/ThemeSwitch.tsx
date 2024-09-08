import { useContext } from "react";
import { OptionsContext, OptionsSetterContext } from "./options";
import { Switch } from "antd";

export function ThemeSwitch() {
  const options = useContext(OptionsContext);
  const { changeOptions } = useContext(OptionsSetterContext);

  return (
    <Switch
      title="Dark mode?"
      value={options.theme === "dark"}
      unCheckedChildren="Light"
      checkedChildren="Dark"
      onChange={(checked) =>
        changeOptions({
          ...options,
          theme: checked ? "dark" : "light",
        })
      }
    />
  );
}
