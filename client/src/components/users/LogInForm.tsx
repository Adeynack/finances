import { Button, Form, Input } from "antd";
import { gql, useMutation } from "@apollo/client";
import { LoadingOutlined } from "@ant-design/icons";
import { LogInMutation } from "../../__generated__/graphql";
import { NavigateFunction, useNavigate } from "react-router-dom";
import { useContext } from "react";
import {
  Session,
  SessionSetterContext,
  useSession,
} from "../../models/session";

const LOG_IN_MUTATION = gql(`
  mutation LogIn($email: String!, $password: String!) {
    logIn(input: { email: $email, password: $password }) {
      user {
        email
        displayName
        defaultBookId
      }
      token
    }
  }
`);

interface LogInFormFields {
  email: string;
  password: string;
}

export function LogInForm() {
  const navigate = useNavigate();
  const session = useSession();
  const { updateSession } = useContext(SessionSetterContext);

  const [logInToServer, { data, loading, error }] = useMutation<LogInMutation>(
    LOG_IN_MUTATION,
    {
      onCompleted: (d) => onLogInCompleted(d, navigate, session, updateSession),
    },
  );

  function createSession({ email, password }: LogInFormFields): void {
    console.log("Log In Form Submit", { email, password });
    logInToServer({ variables: { email, password } });
  }

  if (error) {
    console.error("The LogIn mutation responded with errors", error);
  }

  if (!error && data) {
    console.log("The LogIn mutation was successful", data);
  }

  return (
    <div>
      {error && <div>Errors (see console)</div>}
      <Form<LogInFormFields>
        name="login"
        disabled={loading || !!data?.logIn}
        autoComplete="off"
        onFinish={createSession}
        labelCol={{ span: 8 }}
        wrapperCol={{ span: 16 }}
        style={{ maxWidth: 600 }}
        initialValues={
          {
            email: "",
            password: "",
          } as LogInFormFields
        }
      >
        <Form.Item<LogInFormFields>
          name="email"
          label="E-Mail"
          rules={[{ required: true }]}
        >
          <Input />
        </Form.Item>
        <Form.Item<LogInFormFields>
          name="password"
          label="Password"
          rules={[{ required: true }]}
        >
          <Input.Password />
        </Form.Item>
        {loading ? (
          <LoadingOutlined label="Logging in..." />
        ) : (
          <Form.Item wrapperCol={{ offset: 8, span: 16 }}>
            <Button type="primary" htmlType="submit">
              Log in
            </Button>
          </Form.Item>
        )}
      </Form>
    </div>
  );
}

function onLogInCompleted(
  data: LogInMutation,
  navigate: NavigateFunction,
  session: Session,
  updateSession: (_session: Partial<Session>) => void,
): void {
  if (!data?.logIn) return;

  updateSession({
    ...session,
    apiToken: data.logIn.token,
    user: data.logIn.user,
  });

  if (data.logIn.user?.defaultBookId) {
    navigate(`/books/${data.logIn.user.defaultBookId}`);
  } else {
    navigate("/");
  }
}
