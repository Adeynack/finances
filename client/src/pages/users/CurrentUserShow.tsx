import { useSession } from "../../models/session";
import { ThemeSwitch } from "../../components/core/ThemeSwitch";
import { LogInForm } from "../../components/users/LogInForm";
import LogOutButton from "../../components/users/LogOutButton";
import { useQuery } from "@apollo/client";
import { gql } from "../../__generated__";
import { LoadingOutlined } from "@ant-design/icons";
import { ApolloErrorCard } from "../../components/errors/ApolloErrorCard";

const GET_CURRENT_USER_QUERY = gql(`
  query GetCurrentUser {
    me {
      email
      displayName
    }
  }
`);

export function CurrentUserShow() {
  const { isLoggedIn } = useSession();
  const { loading, data, error } = useQuery(GET_CURRENT_USER_QUERY);

  const user = data?.me;

  return (
    <div>
      {loading && <LoadingOutlined />}
      {error && <ApolloErrorCard error={error} />}
      {user && (
        <p>
          Logged in as {user.displayName} ({user.email})
        </p>
      )}
      <p>
        Change visual theme: <ThemeSwitch />
      </p>
      <p>{isLoggedIn ? <LogOutButton /> : <LogInForm />}</p>
    </div>
  );
}
