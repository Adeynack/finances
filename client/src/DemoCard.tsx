import { Button, Card } from 'antd';
import ButtonGroup from 'antd/es/button/button-group';
import { ThemeSwitcher } from './ThemeSwitcher';

export function DemoCard(): JSX.Element {
  return (
    <>
      <Card title="Some Buttons">
        <ButtonGroup>
          <Button danger>Cancel</Button>
          <Button type="primary">OK</Button>
        </ButtonGroup>
      </Card>
      <Card title="Theme">
        <ThemeSwitcher />
      </Card>
    </>
  );
}
