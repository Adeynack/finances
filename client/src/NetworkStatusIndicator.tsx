import { ApolloError, NetworkStatus } from "@apollo/client";

interface Props {
  error?: ApolloError;
  networkStatus: NetworkStatus;
}

function NetworkStatusIndicator({ error, networkStatus }: Props) {
  let message: string;
  let pill: string;

  switch (networkStatus) {
    case NetworkStatus.error:
      pill = '🔴';
      message = 'Error' + (error ? `: ${error}` : '');
      break;
    case NetworkStatus.fetchMore:
      pill = '🟡';
      message = 'FetchMore';
      break;
    case NetworkStatus.loading:
      pill = '🟡';
      message = 'Loading';
      break;
    case NetworkStatus.poll:
      pill = '🟡';
      message = 'Poll';
      break;
    case NetworkStatus.ready:
      pill = '🟢';
      message = 'Ready';
      break;
    case NetworkStatus.refetch:
      message = 'Refetch';
      pill = '🟡';
      break;
    case NetworkStatus.setVariables:
      pill = '🟡';
      message = 'Set Variables';
      break;
    default:
      pill = '⚫️';
      message = `${networkStatus}`;
  }

  return <span>{pill}&nbsp;{message}</span>
}

export default NetworkStatusIndicator;