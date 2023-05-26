import { createBrowserRouter } from 'react-router-dom';
import { DemoCard } from '../components/DemoCard';

export const router = createBrowserRouter([
  {
    path: '/',
    element: <DemoCard />,
  },
]);
