import { Button } from "antd";
import { useContext } from "react";
import { SessionContext, SessionSetterContext } from "../../models/session";
import { Navigate } from "react-router-dom";

export default function LogOutButton() {
  const session = useContext(SessionContext);
  const { updateSession } = useContext(SessionSetterContext);

  const onLogOutClick = () => {
    updateSession({ apiToken: null, user: null });
  };

  if (!session.user) {
    return <Navigate to="/" />;
  }

  return (
    <Button color="danger" onClick={onLogOutClick}>
      Log out
    </Button>
  );
}
