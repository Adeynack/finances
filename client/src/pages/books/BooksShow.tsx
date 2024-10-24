import { Link, useParams } from "react-router-dom";
import { bookBooksPath, bookIdPathParam } from "../../models/paths";
import { gql } from "../../__generated__";
import { useQuery } from "@apollo/client";
import { LoadingOutlined } from "@ant-design/icons";

const GET_BOOK_SHOW_QUERY = gql(`
  query GetBook($bookId: ID!) {
    book(id: $bookId) {
      name
      owner {
        displayName
        email
      }
    }
  }
`);

export function BooksShow() {
  const params = useParams();
  const bookId = params[bookIdPathParam]!;

  const { loading, data, error } = useQuery(GET_BOOK_SHOW_QUERY, {
    variables: { bookId },
  });

  if (loading) return <LoadingOutlined />;

  const book = data?.book;

  return (
    <div>
      <Link to={bookBooksPath(bookId)}>Change book</Link>
      {error ? (
        <div>
          <h1>Error</h1>
          <p>{error.message}</p>
        </div>
      ) : (
        book && (
          <h1>
            Book{" "}
            <em
              title={`Owned by ${book.owner.displayName} (${book.owner.email})`}
            >
              {book.name}
            </em>
          </h1>
        )
      )}
    </div>
  );
}
