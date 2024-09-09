import { Layout, Menu } from "antd";
import { Content, Header } from "antd/es/layout/layout";
import React, { useContext } from "react";
import {
  AccountBookOutlined,
  BookOutlined,
  FolderOutlined,
  UserOutlined,
} from "@ant-design/icons";
import { Outlet, useNavigate } from "react-router-dom";
import { SessionContext } from "../../models/session";

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

  // todo: https://reactrouter.com/en/main/start/tutorial#adding-a-router
  return (
    <Layout style={layoutStyle}>
      <Header style={headerStyle}>
        <Menu
          style={menuStyle}
          mode="horizontal"
          items={[
            {
              key: "root",
              icon: "💰",
              title: "Finances",
              onClick: () => navigate("/"),
            },
            ...(!session.isLoggedIn()
              ? []
              : [
                  {
                    key: "books",
                    label: "Book",
                    icon: <BookOutlined />,
                    title: "Book's root & other books",
                    onClick: () => navigate("/books"),
                  },
                  {
                    key: "accounts",
                    label: "Accounts",
                    icon: <AccountBookOutlined />,
                    title: "Current book's accounts",
                    onClick: () => navigate("/accounts"),
                  },
                  {
                    key: "categories",
                    label: "Categories",
                    icon: <FolderOutlined />,
                    title: "Current book's categories",
                    onClick: () => navigate("/categories"),
                  },
                ]),
            {
              key: "user",
              label: "User",
              icon: <UserOutlined />,
              title: "User settings",
              onClick: () => navigate("/user"),
            },
          ]}
        />
      </Header>
      <Content style={contentStyle}>
        <Outlet />
      </Content>
    </Layout>
  );
}
