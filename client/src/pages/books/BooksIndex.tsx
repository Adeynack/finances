import { useQuery } from "@apollo/client";
import { gql } from "../../__generated__";
import { Button, Flex } from "antd";
import { Link } from "react-router-dom";
import { ApolloErrorCard } from "../../components/errors/ApolloErrorCard";
import { LoadingOutlined } from "@ant-design/icons";

const GET_BOOK_LIST_QUERY = gql(`
  query GetBookList($cursor: String) {
    books(after: $cursor) {
      pageInfo {
        hasNextPage
        endCursor
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
  const { loading, data, error, refetch, fetchMore } = useQuery(
    GET_BOOK_LIST_QUERY,
    {
      notifyOnNetworkStatusChange: true,
      fetchPolicy: "cache-and-network",
    },
  );

  if (loading && !data) return <LoadingOutlined />;
  if (error) return <ApolloErrorCard error={error} />;

  return (
    <div>
      <Flex gap="small">
        <Button disabled={loading} onClick={() => refetch()}>
          Refresh
        </Button>
        <Button onClick={() => alert("TODO")}>Create a new book</Button>
      </Flex>

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
              {loading && <LoadingOutlined />}
              {!loading && data.books.pageInfo.hasNextPage && (
                <Button
                  onClick={() =>
                    fetchMore({
                      variables: { cursor: data.books.pageInfo.endCursor },
                    })
                  }
                >
                  Load more
                </Button>
              )}
            </>
          )}
        </>
      )}
    </div>
  );
}
