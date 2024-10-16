import { Link } from "react-router-dom";
import { booksPath, rootPath } from "../models/paths";
import { useSession } from "../models/session";

export function NotFound() {
  const session = useSession();

  return (
    <div>
      <p>The page at this address was not found.</p>
      <p>
        {session.isLoggedIn() ? (
          <Link to={booksPath}>Return to book selection</Link>
        ) : (
          <Link to={rootPath}>Return to main page</Link>
        )}
      </p>
    </div>
  );
}
