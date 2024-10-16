import { LogInForm } from "../components/users/LogInForm";
import { useSession } from "../models/session";

export default function RootIndex() {
  const session = useSession();

  if (!session.isLoggedIn()) {
    return (
      <div>
        <p>Please log in to continue</p>
        <LogInForm />
      </div>
    );
  }

  return <div>TODO: Root</div>;
}
