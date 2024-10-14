import { useParams } from "react-router-dom";
import { useMenuSection } from "../../models/menu";
import { bookIdPathParam } from "../../models/paths";

export function BooksShow() {
  useMenuSection("books");
  const routeParam = useParams();
  const bookId = routeParam[bookIdPathParam];

  return (
    <div>
      <h1>BooksShow</h1>
      <h2>{bookId}</h2>
    </div>
  );
}
