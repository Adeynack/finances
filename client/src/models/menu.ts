import { Context, createContext, useContext, useEffect } from "react";

interface IMenuContext {
  menuSelectedKeys: string[];
  setMenuSelectedKeys: (_: string[]) => void;
}

export const MenuContext: Context<IMenuContext> = createContext<IMenuContext>({
  menuSelectedKeys: [] as string[],
  setMenuSelectedKeys: () => {},
});

export function useMenuSection(key: string) {
  const { setMenuSelectedKeys } = useContext(MenuContext);
  useEffect(() => {
    setMenuSelectedKeys([key]);
  }, [setMenuSelectedKeys, key]);
}
