import '@hotwired/turbo-rails';
import { start } from '@nerdgeschoss/shimmer';
import { application } from 'controllers/application';
// import './controllers'; // https://github.com/nerdgeschoss/development-environment/issues/8

start({ application });
