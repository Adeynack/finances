import { Layout, Menu } from "antd";
import { Content, Header } from "antd/es/layout/layout";
import React, { useContext } from "react";
import {
  AccountBookOutlined,
  BookOutlined,
  FolderOutlined,
  UserOutlined,
} from "@ant-design/icons";
import { Link, Outlet, useParams } from "react-router-dom";
import { SessionContext } from "../models/session";
import { ItemType, MenuItemType } from "antd/es/menu/interface";
import { MenuContext } from "../models/menu";
import {
  bookAccountsPath,
  bookBooksPath,
  bookCategoriesPath,
  bookCurrentUserPath,
  bookPath,
  booksPath,
  currentUserPath,
  rootPath,
} from "../models/paths";
import { BooksIndex } from "./books/BooksIndex";

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

export const rootMenuKey = "root";
export const booksMenuKey = "books";
export const userMenuKey = "user";

export default function MainLayout() {
  const session = useContext(SessionContext);
  const { menuSelectedKeys } = useContext(MenuContext);
  const { bookId } = useParams();

  const items: ItemType<MenuItemType>[] = session.isLoggedIn()
    ? loggedInMenuItems(bookId)
    : unloggedInMenuItems();

  return (
    <Layout style={layoutStyle}>
      <Header style={headerStyle}>
        <Menu
          style={menuStyle}
          mode="horizontal"
          items={items}
          defaultSelectedKeys={[rootMenuKey]}
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
    key: rootMenuKey,
    icon: "💰",
    label: <Link to={rootPath} />,
    title: "Finances",
  };
}

function loggedInMenuItems(bookId?: string): ItemType<MenuItemType>[] {
  return [
    rootMenuItem(),
    ...(!bookId
      ? [
          {
            key: booksMenuKey,
            label: <Link to={booksPath}>Book</Link>,
            icon: <BookOutlined />,
            title: "Book's root & other books",
          },
          {
            key: userMenuKey,
            label: <Link to={currentUserPath}>User</Link>,
            icon: <UserOutlined />,
            title: "User settings",
          },
        ]
      : [
          {
            key: booksMenuKey,
            label: <Link to={bookPath(bookId)}>Book</Link>,
            icon: <BookOutlined />,
            title: "Book's home",
          },
          {
            key: "accounts",
            label: <Link to={bookAccountsPath(bookId)}>Accounts</Link>,
            icon: <AccountBookOutlined />,
            title: "Current book's accounts",
          },
          {
            key: "categories",
            label: <Link to={bookCategoriesPath(bookId)}>Categories</Link>,
            icon: <FolderOutlined />,
            title: "Current book's categories",
          },
          {
            key: userMenuKey,
            label: <Link to={bookCurrentUserPath(bookId)}>User</Link>,
            icon: <UserOutlined />,
            title: "User settings",
          },
        ]),
  ];
}

function unloggedInMenuItems(): ItemType<MenuItemType>[] {
  return [rootMenuItem()];
}
