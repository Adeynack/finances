import { BrowserRouter, Route, Routes } from "react-router-dom";
import MainLayout from "./pages/MainLayout";
import { BooksIndex } from "./pages/books/BooksIndex";
import { CurrentUserShow } from "./pages/users/CurrentUserShow";
import { BooksShow } from "./pages/books/BooksShow";
import RootIndex from "./pages/RootIndex";

export function AppRouter() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<MainLayout />}>
          <Route path="/" element={<RootIndex />} />
          <Route path="books" element={<BooksIndex />}>
            <Route path=":bookId" element={<BooksShow />}>
              <Route path="books" element={<BooksIndex />} />
              <Route path="accounts" element={<div>TODO: Accounts</div>} />
              <Route path="categories" element={<div>TODO: Categories</div>} />
              <Route path="user" element={<CurrentUserShow />} />
            </Route>
            <Route path="user" element={<CurrentUserShow />} />
          </Route>
          <Route path="user" element={<CurrentUserShow />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
