import { useContext } from "react";
import { Switch } from "antd";
import { SessionContext, SessionSetterContext } from "../../models/session";

export function ThemeSwitch() {
  const session = useContext(SessionContext);
  const { updateSession } = useContext(SessionSetterContext);

  return (
    <Switch
      title="Dark mode?"
      value={session.options.theme === "dark"}
      unCheckedChildren="Light"
      checkedChildren="Dark"
      onChange={(checked) =>
        updateSession({
          options: { theme: checked ? "dark" : "light" },
        })
      }
    />
  );
}
