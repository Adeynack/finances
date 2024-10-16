import { Layout } from "antd";
import { Content, Header } from "antd/es/layout/layout";
import React from "react";
import { Outlet } from "react-router-dom";
import { MenuBar } from "../components/core/MenuBar";

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

export default function MainLayout() {
  return (
    <Layout style={layoutStyle}>
      <Header style={headerStyle}>
        <MenuBar />
      </Header>
      <Content style={contentStyle}>
        <Outlet />
      </Content>
    </Layout>
  );
}
