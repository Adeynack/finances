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
        email
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
            <li key={book.id} title={`Owned by ${book.owner.displayName} (${book.owner.email})`} >
              {book.name}
            </li>
          ))}
        </ul>}
      <Button onClick={() => refetch()}>Refetch book list</Button>
    </div >
  )
}
