import { DatabaseOutlined, FileUnknownOutlined, LoadingOutlined, ReloadOutlined, StopOutlined } from "@ant-design/icons";
import { ApolloError, NetworkStatus } from "@apollo/client";

interface Props {
  error?: ApolloError;
  networkStatus: NetworkStatus;
}

function NetworkStatusIndicator({ error, networkStatus }: Props) {
  let message: string;

  let icon: JSX.Element;

  switch (networkStatus) {
    case NetworkStatus.error:
      icon = <StopOutlined />;
      message = 'Error' + (error ? `: ${error}` : '');
      break;
    case NetworkStatus.fetchMore:
      icon = <LoadingOutlined spin={true} />
      message = 'FetchMore';
      break;
    case NetworkStatus.loading:
      icon = <LoadingOutlined spin={true} />
      message = 'Loading';
      break;
    case NetworkStatus.poll:
      icon = <LoadingOutlined spin={true} />
      message = 'Poll';
      break;
    case NetworkStatus.ready:
      icon = <DatabaseOutlined />;
      message = 'Ready';
      break;
    case NetworkStatus.refetch:
      message = 'Refetch';
      icon = <ReloadOutlined spin={true} />
      break;
    case NetworkStatus.setVariables:
      icon = <LoadingOutlined spin={true} />
      message = 'Set Variables';
      break;
    default:
      icon = <FileUnknownOutlined />;
      message = `${networkStatus}`;
  }

  return (
    <span>
      {icon}&nbsp;{message}
    </span>
  );
}

export default NetworkStatusIndicator;