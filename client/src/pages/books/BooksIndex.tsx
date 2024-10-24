import { useQuery } from "@apollo/client";
import { gql } from "../../__generated__";
import { Button } from "antd";
import NetworkStatusIndicator from "../../components/apollo/NetworkStatusIndicator";
import { Link } from "react-router-dom";
import { ApolloErrorCard } from "../../components/errors/ApolloErrorCard";
import { LoadingOutlined } from "@ant-design/icons";

const GET_BOOK_LIST_QUERY = gql(`
  query GetBookList {
    books {
      pageInfo {
        hasNextPage
      }
      edges {
        node {
          id
          name
          owner {
            displayName
            email
          }
        }
      }
    }
  }
`);

export function BooksIndex() {
  const { loading, data, error, refetch } = useQuery(GET_BOOK_LIST_QUERY);

  if (error) return <ApolloErrorCard error={error} />;
  if (loading) return <LoadingOutlined />;

  return (
    <div>
      {data && (
        <>
          {data.books.edges && (
            <>
              <ul>
                {data.books.edges
                  .map((edge) => edge?.node)
                  .map(
                    (book) =>
                      book && (
                        <li
                          key={book.id}
                          title={`Owned by ${book.owner.displayName} (${book.owner.email})`}
                        >
                          <Link to={`/books/${book.id}`}>{book.name}</Link>
                        </li>
                      ),
                  )}
              </ul>
              {data.books.pageInfo.hasNextPage && (
                <Button onClick={() => alert("TODO: Load more")}>
                  Load more
                </Button>
              )}
            </>
          )}
        </>
      )}
      <Button onClick={() => refetch()}>Refetch book list</Button>
    </div>
  );
}
