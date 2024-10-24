import { ApolloError } from "@apollo/client";
import ErrorCard from "./ErrorCard";

interface Props {
  error: ApolloError;
}

export function ApolloErrorCard({ error }: Props) {
  return (
    <ErrorCard
      title="Error contacting the server"
      errorMessages={[error.message]}
    />
  );
}
