import { useQuery } from '@apollo/client';
import { gql } from './__generated__/gql';
import { Button } from 'antd';
import NetworkStatusIndicator from './components/apollo/NetworkStatusIndicator';

const GET_BOOK_LIST = gql(`
  query GetBookList {
    books {
      id
      name
      owner {
        displayName
      }
    }
  }
`);

export function BookList() {
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
      <Button onClick={() => refetch()}>Refetch book list</Button>
    </div >
  )
}
