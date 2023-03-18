import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['children', 'button'];

  declare readonly childrenTarget: HTMLDivElement;
  declare readonly buttonTarget: HTMLDivElement;

  toggleCollapsed(event: Event): void {
    event.preventDefault();

    this.childrenTarget.classList.toggle('register-tree__children--collapsed');

    this.buttonTarget.classList.toggle(
      'register-tree__expand-button__label--collapsed'
    );
    this.buttonTarget.classList.toggle(
      'register-tree__expand-button__label--expanded'
    );
  }
}
