export const rootPath = "/";

export const booksSubPath = "books";
export const currentUserSubPath = "current_user";
export const accountsSubPath = "accounts";
export const categoriesSubPath = "categories";

export const booksPath = `${rootPath}/${booksSubPath}`;

export const bookPath = (bookId: string) => `${booksPath}/${bookId}`;

export const bookBooksPath = (bookId: string) =>
  `${bookPath(bookId)}/${booksSubPath}`;

export const bookAccountsPath = (bookId: string) =>
  `${bookPath(bookId)}/${accountsSubPath}`;

export const bookCategoriesPath = (bookId: string) =>
  `${bookPath(bookId)}/${categoriesSubPath}`;

export const bookUserPath = (bookId: string) =>
  `${bookPath(bookId)}/${currentUserSubPath}`;

export const currentUserPath = `${rootPath}/${currentUserSubPath}`;
