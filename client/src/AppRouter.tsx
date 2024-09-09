import { BrowserRouter, Route, Routes } from "react-router-dom";
import MainLayout from "./components/core/MainLayout";
import { BookList } from "./BookList";
import { ThemeSwitch } from "./components/core/ThemeSwitch";
import { SessionContext } from "./models/session";
import { useContext } from "react";
import { UserPage } from "./components/users/UserPage";

export function AppRouter() {
  const session = useContext(SessionContext);
  const loggedIn = !!session.apiToken;

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<MainLayout />}>
          <Route path="/" element={<div>TODO: Root</div>} />
          {loggedIn && <Route path="/books" element={<BookList />} />}
          {loggedIn && (
            <Route path="/accounts" element={<div>TODO: Accounts</div>} />
          )}
          {loggedIn && (
            <Route path="/categories" element={<div>TODO: Categories</div>} />
          )}
          <Route path="/user" element={<UserPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
