import { Button } from "antd";
import { useContext } from "react";
import { SessionSetterContext } from "../../models/session";

export default function LogOutButton() {
  const { updateSession } = useContext(SessionSetterContext);

  const onLogOutClick = () => {
    updateSession({ apiToken: null, user: null });
  };

  return (
    <Button color="danger" onClick={onLogOutClick}>
      Log out
    </Button>
  );
}
