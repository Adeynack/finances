import { Link, useNavigate, useParams } from "react-router-dom";
import { bookBooksPath, bookIdPathParam } from "../../models/paths";
import { gql } from "../../__generated__";
import { useQuery } from "@apollo/client";
import { LoadingOutlined } from "@ant-design/icons";
import { ApolloErrorCard } from "../../components/errors/ApolloErrorCard";
import { Button } from "antd";
import type { DocumentNode } from "graphql";

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
  const navigate = useNavigate();
  const params = useParams();
  const bookId = params[bookIdPathParam]!;

  const { loading, data, error } = useQuery(GET_BOOK_SHOW_QUERY, {
    variables: { bookId },
  });

  if (loading) return <LoadingOutlined />;
  if (error) return <ApolloErrorCard error={error} />;

  const book = data?.book;

  return (
    <div>
      <Button onClick={() => navigate(bookBooksPath(bookId))}>
        Change book
      </Button>

      {book && (
        <h1>
          Book{" "}
          <em
            title={`Owned by ${book.owner.displayName} (${book.owner.email})`}
          >
            {book.name}
          </em>
        </h1>
      )}
    </div>
  );
}
