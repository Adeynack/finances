import { Card } from "antd";

interface Props {
  title?: string;
  errorMessages: string[];
}

export default function ErrorCard({ title, errorMessages }: Props) {
  return (
    <Card title={title || "Error"}>
      {errorMessages.length == 1 ? (
        errorMessages[0]
      ) : (
        <ul>
          {errorMessages.map((err) => (
            <li>{err}</li>
          ))}
        </ul>
      )}
    </Card>
  );
}
