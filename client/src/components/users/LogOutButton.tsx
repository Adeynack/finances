import { Button } from "antd";
import { useContext, useState } from "react";
import { SessionSetterContext } from "../../models/session";
import { redirect } from "react-router-dom";

export default function LogOutButton() {
  const { updateSession } = useContext(SessionSetterContext);
  const [redirectUrl, setRedirectUrl] = useState<string | null>(null);

  const onLogOutClick = () => {
    updateSession({ apiToken: null, user: null });
    setRedirectUrl("/");
  };

  if (redirectUrl) {
    return redirect(redirectUrl);
  }

  return (
    <Button color="danger" onClick={onLogOutClick}>
      Log out
    </Button>
  );
}
