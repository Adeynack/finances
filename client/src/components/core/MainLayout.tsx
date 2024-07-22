import { Layout, Menu, theme } from "antd";
import { Content, Header } from "antd/es/layout/layout";
import { BookList } from "../../BookList";
import { ThemeSwitch } from "./ThemeSwitch";
import React from "react";
import { AccountBookOutlined, BookOutlined, FolderOutlined, UserOutlined } from "@ant-design/icons";

const layoutStyle: React.CSSProperties = {
  margin: -8
};

const contentStyle: React.CSSProperties = {
  margin: "8px"
};

const headerStyle: React.CSSProperties = {
  paddingLeft: 0,
  paddingRight: 0,
  display: 'flex',
  width: '100%',
};

const menuStyle: React.CSSProperties = {
  flex: 1,
  minWidth: 0,
}

export default function MainLayout() {
  const { token: { colorBgContainer } } = theme.useToken();

  const titleStyle: React.CSSProperties = {
    backgroundColor: colorBgContainer,
  }

  return (
    <Layout style={layoutStyle}>
      <Header style={headerStyle}>
        <div style={titleStyle}>
          💰 Finances
        </div>
        <Menu
          style={menuStyle}
          mode="horizontal"
          items={[
            {
              key: 'books',
              label: 'Book',
              icon: <BookOutlined />,
              title: "Book's root & other books",
            },
            {
              key: 'accounts',
              label: 'Accounts',
              icon: <AccountBookOutlined />,
              title: "Current book's accounts",
            },
            {
              key: 'categories',
              label: 'Categories',
              icon: <FolderOutlined />,
              title: "Current book's categories",
            },
            {
              key: 'user',
              label: 'User',
              icon: <UserOutlined />,
              title: "User settings"
            }
          ]}
        />
      </Header>
      <Content style={contentStyle}>
        <ThemeSwitch />
        <BookList />
      </Content>
    </Layout >
  )
}