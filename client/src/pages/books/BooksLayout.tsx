import { Navigate, Outlet } from "react-router-dom";
import { useSession } from "../../models/session";
import { rootPath } from "../../models/paths";

export function BooksLayout() {
  const session = useSession();

  // todo: Get rid of this to allow keeping the path the user is trying
  // to access in the browser's address bar (and in context) so when he's
  // logged in again, he can access that page.
  if (!session.isLoggedIn()) {
    return <Navigate to={rootPath} />;
  }

  return <Outlet />;
}
