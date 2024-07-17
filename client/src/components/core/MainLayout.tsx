import { Layout, Menu } from "antd";
import { Content } from "antd/es/layout/layout";
import Sider from "antd/es/layout/Sider";
import { BookList } from "../../BookList";
import { ThemeSwitch } from "./ThemeSwitch";
import React, { useState } from "react";
import { AccountBookOutlined, BookOutlined, FolderOutlined, MenuFoldOutlined, MenuUnfoldOutlined, UserOutlined } from "@ant-design/icons";

const layoutStyle: React.CSSProperties = {
  margin: -8
};

const siderStyle: React.CSSProperties = {
  height: '100vh',
};

const contentStyle: React.CSSProperties = {
  margin: "8px"
};

export default function MainLayout() {
  const [collapsed, setCollapsed] = useState(true);

  return (
    <Layout style={layoutStyle}>
      <Sider style={siderStyle} collapsed={collapsed}>
        <Menu
          items={[
            {
              key: 'title',
              label: <>
                <span>💰</span>
                {!collapsed && <span> Finances</span>}
              </>,
              type: "group"
            },
            {
              key: 'collapse-bar',
              label: collapsed ? 'Display menu' : 'Collapse menu',
              icon: collapsed ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />,
              onClick: () => setCollapsed(!collapsed)
            },
            {
              key: 'accounts',
              label: 'Accounts',
              icon: <AccountBookOutlined />
            },
            {
              key: 'categories',
              label: 'Categories',
              icon: <FolderOutlined />
            },
            {
              key: 'books',
              label: 'Books',
              icon: <BookOutlined />
            },
            {
              key: 'settings',
              label: 'User & Settings',
              icon: <UserOutlined />
            }
          ]}
        />
      </Sider>
      <Content style={contentStyle}>
        <ThemeSwitch />
        <BookList />
      </Content>
    </Layout >
  )
}