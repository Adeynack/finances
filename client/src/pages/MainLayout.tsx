import { Layout, Menu } from "antd";
import { Content, Header } from "antd/es/layout/layout";
import React, { useContext } from "react";
import { BookOutlined, UserOutlined } from "@ant-design/icons";
import { NavLink, Outlet } from "react-router-dom";
import { SessionContext } from "../models/session";
import { ItemType, MenuItemType } from "antd/es/menu/interface";
import { MenuContext } from "../models/menu";

const layoutStyle: React.CSSProperties = {
  margin: -8,
};

const contentStyle: React.CSSProperties = {
  margin: "8px",
};

const headerStyle: React.CSSProperties = {
  paddingLeft: 0,
  paddingRight: 0,
  display: "flex",
  width: "100%",
};

const menuStyle: React.CSSProperties = {
  flex: 1,
  minWidth: 0,
};

export default function MainLayout() {
  const session = useContext(SessionContext);
  const { menuSelectedKeys } = useContext(MenuContext);

  const items: ItemType<MenuItemType>[] = session.isLoggedIn()
    ? loggedInMenuItems()
    : unloggedInMenuItems();

  return (
    <Layout style={layoutStyle}>
      <Header style={headerStyle}>
        <Menu
          style={menuStyle}
          mode="horizontal"
          items={items}
          defaultSelectedKeys={["root"]}
          selectedKeys={menuSelectedKeys}
          selectable={false}
        />
      </Header>
      <Content style={contentStyle}>
        <Outlet />
      </Content>
    </Layout>
  );
}

function rootMenuItem(): ItemType<MenuItemType> {
  return {
    key: "root",
    icon: "💰",
    label: <NavLink to="/" />,
    title: "Finances",
  };
}

function loggedInMenuItems(): ItemType<MenuItemType>[] {
  return [
    rootMenuItem(),
    {
      key: "books",
      label: <NavLink to="/books">Book</NavLink>,
      icon: <BookOutlined />,
      title: "Book's root & other books",
    },
    {
      key: "user",
      label: <NavLink to="/user">User</NavLink>,
      icon: <UserOutlined />,
      title: "User settings",
    },
  ];
}

function unloggedInMenuItems(): ItemType<MenuItemType>[] {
  return [rootMenuItem()];
}
