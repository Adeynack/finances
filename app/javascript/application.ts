import '@hotwired/turbo-rails';
import { start } from '@nerdgeschoss/shimmer';
import { application } from './controllers/application_controller';
import { registerControllers } from 'stimulus-vite-helpers';

// Controller files must be named *_controller.ts/js.
const controllers = import.meta.glob('../**/*_controller.{ts,js}', {
  eager: true,
});
registerControllers(application, controllers);

start({ application });
