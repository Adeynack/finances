import { useQuery } from '@apollo/client';
import { gql } from './__generated__/gql';
import NetworkStatusIndicator from './NetworkStatusIndicator';

const GET_BOOK_LIST = gql(`
  query GetBookList {
    books {
      id
      name
      owner {
        displayName
        email
      }
    }
  }
`);

function BookList() {
  const { loading, data, error, refetch, networkStatus } = useQuery(
    GET_BOOK_LIST, {
    notifyOnNetworkStatusChange: true
  });

  return (
    <div>
      <p><NetworkStatusIndicator error={error} networkStatus={networkStatus} /></p>
      {data && !loading &&
        <ul>
          {data.books.map(book => (
            <li key={book.id}>
              <span>{book.name}</span>
              <span>({book.owner.displayName})</span>
            </li>
          ))}
        </ul>}
      <button onClick={() => refetch()}>Refetch book list</button>
    </div >
  )
}

export default BookList;