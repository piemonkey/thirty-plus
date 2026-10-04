import EmberRouter from '@embroider/router';
import config from 'thirty-plus/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('now');
  this.route('soon');
});
