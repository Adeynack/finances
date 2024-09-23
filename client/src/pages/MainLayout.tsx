import { Layout, Menu } from "antd";
import { Content, Header } from "antd/es/layout/layout";
import React, { useContext } from "react";
import { BookOutlined, UserOutlined } from "@ant-design/icons";
import { NavigateFunction, Outlet, useNavigate } from "react-router-dom";
import { SessionContext } from "../models/session";
import { ItemType, MenuItemType } from "antd/es/menu/interface";

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
  const navigate = useNavigate();
  const session = useContext(SessionContext);

  const items: ItemType<MenuItemType>[] = session.isLoggedIn()
    ? loggedInMenuItems(navigate)
    : unloggedInMenuItems(navigate);

  return (
    <Layout style={layoutStyle}>
      <Header style={headerStyle}>
        <Menu style={menuStyle} mode="horizontal" items={items} />
      </Header>
      <Content style={contentStyle}>
        <Outlet />
      </Content>
    </Layout>
  );
}

function rootMenuItem(navigate: NavigateFunction): ItemType<MenuItemType> {
  return {
    key: "root",
    icon: "💰",
    title: "Finances",
    onClick: () => navigate("/"),
  };
}

function loggedInMenuItems(
  navigate: NavigateFunction,
): ItemType<MenuItemType>[] {
  return [
    rootMenuItem(navigate),
    {
      key: "books",
      label: "Book",
      icon: <BookOutlined />,
      title: "Book's root & other books",
      onClick: () => navigate("/books"),
    },
    {
      key: "user",
      label: "User",
      icon: <UserOutlined />,
      title: "User settings",
      onClick: () => navigate("/user"),
    },
  ];
}

function unloggedInMenuItems(
  navigate: NavigateFunction,
): ItemType<MenuItemType>[] {
  return [rootMenuItem(navigate)];
}
