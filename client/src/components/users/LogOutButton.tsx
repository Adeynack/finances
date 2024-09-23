import { Button } from "antd";
import { useContext } from "react";
import { SessionSetterContext } from "../../models/session";
import { useNavigate } from "react-router-dom";

export default function LogOutButton() {
  const { changeSession } = useContext(SessionSetterContext);
  const navigate = useNavigate();

  const onLogOutClick = () => {
    changeSession({ apiToken: null, user: null });
    navigate("/");
  };

  return (
    <Button color="danger" onClick={onLogOutClick}>
      Log out
    </Button>
  );
}
