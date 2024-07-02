import useToken from "antd/es/theme/useToken";
import { useEffect } from "react";

/**
 * BodyStyle is simply an `effect` setting the background color or
 * the HTML Body to the right one upon style change.
 * 
 * It has to be a component, since it has to be inside of a `<ConfigProvider>`
 * to be notified via `useToken` of the change of theme.
 * 
 */
export function BodyStyler() {
  const [, token] = useToken();

  useEffect(() => {
    document.body.style.backgroundColor = token.colorBgBase;
  }, [token]);

  return <></>;
}