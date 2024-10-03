import { useParams } from "react-router-dom";
import { useMenuSection } from "../../models/menu";

export function BooksShow() {
  useMenuSection("books");
  const routeParam = useParams();
  const bookId = routeParam["bookId"];

  return (
    <div>
      <h1>BooksShow</h1>
      <h2>{bookId}</h2>
    </div>
  );
}
