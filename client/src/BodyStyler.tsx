import { theme } from 'antd';
import { useEffect } from 'react';

const { useToken } = theme;

export function BodyStyler(): JSX.Element {
  const { token } = useToken();
  useEffect(() => {
    document.body.style.backgroundColor = token.colorBgBase;
  }, [token]);

  return <></>;
}
