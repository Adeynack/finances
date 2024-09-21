import { useSession } from "../../models/session";
import { ThemeSwitch } from "../core/ThemeSwitch";
import { LogIn } from "./LogIn";

export function UserPage() {
  const session = useSession();

  return (
    <div>
      <div>User</div>
      <ThemeSwitch />
      {!session.isLoggedIn() && <LogIn />}
    </div>
  );
}
