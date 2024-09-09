import { useSession } from "../../models/session";
import { ThemeSwitch } from "../core/ThemeSwitch";
import { LogIn } from "./LogIn";

export function UserPage() {
  const session = useSession();
  console.log("[UserPage] Session", session);

  return (
    <div>
      <div>TODO: User</div>
      <ThemeSwitch />
      {!session.isLoggedIn() && <LogIn />}
    </div>
  );
}
