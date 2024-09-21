import { Button, Form, Input } from "antd";
import { gql, useMutation } from "@apollo/client";
import { LoadingOutlined } from "@ant-design/icons";
import { LogInMutation } from "../../__generated__/graphql";
import { useNavigate } from "react-router-dom";

const LOG_IN_MUTATION = gql(`
  mutation LogIn($email: String!, $password: String!) {
    logIn(input: { email: $email, password: $password }) {
      user {
        email
        displayName
      }
      token
    }
  }
`);

type LogInFormFields = {
  email: string;
  password: string;
};

export function LogIn() {
  const navigate = useNavigate();

  function onLogInCompleted(data: LogInMutation): void {
    if (data?.logIn?.token) {
      navigate("/");
    }
  }

  const [logInToServer, { data, loading, error }] = useMutation<LogInMutation>(
    LOG_IN_MUTATION,
    { onCompleted: onLogInCompleted },
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
      {loading ? <div>Logging in ...</div> : <div>Log In</div>}
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
          <Form.Item>
            <Button type="primary" htmlType="submit">
              Log in
            </Button>
          </Form.Item>
        )}
      </Form>
    </div>
  );
}
