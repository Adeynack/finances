import { BrowserRouter, Route, Routes } from "react-router-dom";
import MainLayout from "./pages/MainLayout";
import { BooksIndex } from "./pages/BooksIndex";
import { UserPage } from "./components/users/UserPage";
import { BooksShow } from "./pages/BooksShow";

export function AppRouter() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<MainLayout />}>
          <Route path="/" element={<div>TODO: Root</div>} />
          <Route path="books" element={<BooksIndex />}>
            <Route path=":bookId" element={<BooksShow />}>
              <Route path="books" element={<BooksIndex />} />
              <Route path="accounts" element={<div>TODO: Accounts</div>} />
              <Route path="categories" element={<div>TODO: Categories</div>} />
              <Route path="user" element={<UserPage />} />
            </Route>
            <Route path="user" element={<UserPage />} />
          </Route>
          <Route path="user" element={<UserPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
