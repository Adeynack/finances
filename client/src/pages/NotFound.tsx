import { Link } from "react-router-dom";
import { rootPath } from "../models/paths";

export function NotFound() {
  return (
    <div>
      <p>The page at this address was not found.</p>
      <p>
        <Link to={rootPath}>Return to main page</Link>
      </p>
    </div>
  );
}
