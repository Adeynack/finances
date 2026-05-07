import { BrowserRouter, Route, Routes } from "react-router-dom";
import MainLayout from "./pages/MainLayout";
import { BooksIndex } from "./pages/books/BooksIndex";
import { CurrentUserShow } from "./pages/users/CurrentUserShow";
import { BooksShow } from "./pages/books/BooksShow";
import RootIndex from "./pages/RootIndex";
import {
  accountsSubPath,
  bookIdPathParam,
  booksSubPath,
  categoriesSubPath,
  currentUserSubPath,
} from "./models/paths";
import { BooksLayout } from "./pages/books/BooksLayout";
import { NotFound } from "./pages/NotFound";

export function AppRouter() {
  return (
    <BrowserRouter>
      <Routes>
        {/* The `key` attribute maps to the paths.ts constant names. */}
        <Route path="/" element={<MainLayout />}>
          <Route index key="root" element={<RootIndex />} />
          <Route path={booksSubPath} element={<BooksLayout />}>
            <Route index key="books" element={<BooksIndex />} />
            <Route path={`:${bookIdPathParam}`}>
              <Route index key="book" element={<BooksShow />} />
              <Route
                path={booksSubPath}
                key="bookBooks"
                element={<BooksIndex />}
              />
              <Route
                path={accountsSubPath}
                key="bookAccounts"
                element={<div>TODO: Accounts</div>}
              />
              <Route
                path={categoriesSubPath}
                key="bookCategories"
                element={<div>TODO: Categories</div>}
              />
              <Route
                path={currentUserSubPath}
                key="bookUser"
                element={<CurrentUserShow />}
              />
            </Route>
          </Route>
          <Route
            path={currentUserSubPath}
            key="user"
            element={<CurrentUserShow />}
          />
          <Route path="*" key="notFound" element={<NotFound />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
