import { SessionSetterContext, useSession } from "../../models/session";
import { ThemeSwitch } from "../../components/core/ThemeSwitch";
import { LogInForm } from "../../components/users/LogInForm";
import LogOutButton from "../../components/users/LogOutButton";
import { useQuery } from "@apollo/client";
import { gql } from "../../__generated__";
import { useContext } from "react";

const GET_CURRENT_USER_QUERY = gql(`
  query GetCurrentUser {
    me {
      email
      displayName
    }
  }
`);

export function CurrentUserShow() {
  const { isLoggedIn, user } = useSession();
  const { updateSession } = useContext(SessionSetterContext);
  const { loading, data } = useQuery(GET_CURRENT_USER_QUERY);

  if (!loading && data) {
    updateSession({ user: data.me });
  }

  return (
    <div>
      {isLoggedIn && (
        <p>
          Logged in as {user?.displayName} ({user?.email})
        </p>
      )}
      <p>
        Change visual theme: <ThemeSwitch />
      </p>
      <p>{isLoggedIn ? <LogOutButton /> : <LogInForm />}</p>
    </div>
  );
}
