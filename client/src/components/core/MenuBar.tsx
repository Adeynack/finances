import { Menu } from "antd";
import React from "react";
import {
  AccountBookOutlined,
  BookOutlined,
  FolderOutlined,
  UserOutlined,
} from "@ant-design/icons";
import { Link, useLocation, useParams } from "react-router-dom";
import { useSession } from "../../models/session";
import { ItemType, MenuItemType } from "antd/es/menu/interface";
import {
  bookAccountsPath,
  bookBooksPath,
  bookCategoriesPath,
  bookCurrentUserPath,
  bookIdPathParam,
  bookPath,
  booksPath,
  currentUserPath,
} from "../../models/paths";

export const rootMenuKey = "root";
export const booksMenuKey = "books";
export const userMenuKey = "user";

const menuStyle: React.CSSProperties = {
  flex: 1,
  minWidth: 0,
};

export function MenuBar() {
  const { isLoggedIn } = useSession();

  const { pathname } = useLocation();

  const params = useParams();
  const bookId = params[bookIdPathParam];

  const items = generateItems(isLoggedIn, bookId);
  const selectedKeys = determineDefaultSelectedKeys(pathname, bookId);

  return (
    <Menu
      style={menuStyle}
      mode="horizontal"
      items={items}
      selectedKeys={selectedKeys}
      selectable={false}
    />
  );
}

function determineDefaultSelectedKeys(
  pathname: string,
  bookId?: string,
): string[] {
  if (bookId) {
    if (pathname === bookPath(bookId)) {
      return ["book"];
    }
    if (pathname.startsWith(bookBooksPath(bookId))) {
      return ["book"];
    }
    if (pathname.startsWith(bookAccountsPath(bookId))) {
      return ["accounts"];
    }
    if (pathname.startsWith(bookCategoriesPath(bookId))) {
      return ["categories"];
    }
    if (pathname.startsWith(bookCurrentUserPath(bookId))) {
      return ["currentUser"];
    }
  }

  if (pathname.startsWith(booksPath)) {
    return ["books"];
  }
  if (pathname.startsWith(currentUserPath)) {
    return ["currentUser"];
  }

  return ["root"];
}

function generateItems(
  isLoggedIn: boolean,
  bookId?: string,
): ItemType<MenuItemType>[] {
  return isLoggedIn ? loggedInMenuItems(bookId) : [];
}

function loggedInMenuItems(bookId?: string): ItemType<MenuItemType>[] {
  return [
    ...(!bookId
      ? [
          {
            key: "books",
            label: <Link to={booksPath}>Books</Link>,
            icon: <BookOutlined />,
            title: "Book's root & other books",
          },
          {
            key: "currentUser",
            label: <Link to={currentUserPath}>User</Link>,
            icon: <UserOutlined />,
            title: "User settings",
          },
        ]
      : [
          {
            key: "book",
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
            key: "currentUser",
            label: <Link to={bookCurrentUserPath(bookId)}>User</Link>,
            icon: <UserOutlined />,
            title: "User settings",
          },
        ]),
  ];
}
