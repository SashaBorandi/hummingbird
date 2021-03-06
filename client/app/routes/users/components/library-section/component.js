import Component from 'ember-component';
import computed from 'ember-computed';
import get from 'ember-metal/get';
import moment from 'moment';
/* global humanizeDuration */

export default Component.extend({
  stats: computed('section.entries', {
    get() {
      const entries = get(this, 'section.entries');
      const count = entries !== undefined ? entries.length : 0;
      const time = get(this, 'time');
      return `${count} titles — ${time}`;
    }
  }),

  time: computed('section.entries', {
    get() {
      const entries = get(this, 'section.entries') || [];
      const time = moment.duration();
      entries.forEach((entry) => {
        const count = get(entry, 'anime.episodeCount');
        const length = get(entry, 'anime.episodeLength');
        time.add(count * length, 'minutes');
      });
      return humanizeDuration(time.asMilliseconds());
    }
  })
});
