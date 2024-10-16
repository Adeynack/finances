import { Link, useParams } from "react-router-dom";
import { bookBooksPath, bookIdPathParam } from "../../models/paths";

export function BooksShow() {
  const params = useParams();
  const bookId = params[bookIdPathParam]!;

  return (
    <div>
      <Link to={bookBooksPath(bookId)}>Change book</Link>
      <h1>BooksShow</h1>
      <h2>{bookId}</h2>
    </div>
  );
}
