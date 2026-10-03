import type Owner from '@ember/owner'
import Component from '@glimmer/component'
import { tracked } from '@glimmer/tracking'
import 'temporal-spec/global'

export interface CountUpSignature {
  Args: {}
  Element: null
}

// const TARGET_DATE = new Temporal.PlainDateTime(2026, 10, 4, 21, 55)
const TARGET_DATE = Temporal.ZonedDateTime.from({
  year: 2026,
  month: 10,
  day: 4,
  hour: 21,
  minute: 55,
  timeZone: Temporal.Now.timeZoneId(),
})
const THIRTY_DAY_DATE = TARGET_DATE.subtract(Temporal.Duration.from({
  // years: 30,
  // months: 30,
  // weeks: 30,
  // days: 30,
  hours: 30,
  minutes: 30,
}))

export default class CountUp extends Component<CountUpSignature> {
  constructor(owner: Owner, args: CountUpSignature['Args']) {
    super(owner, args)
    // Move to modifier?
    setInterval(() => this.now = Temporal.Now.zonedDateTimeISO(), 1)
  }

  @tracked now = Temporal.Now.zonedDateTimeISO()
  get counts() {
    const diff = THIRTY_DAY_DATE.until(this.now, { largestUnit: 'hours', smallestUnit: 'seconds' })
    return {
      years: 30,
      months: 30,
      weeks: 30,
      days: 30,
      hours: diff.hours,
      minutes: diff.minutes,
      seconds: diff.seconds,
    }
  }

  get moments() {
    return ((this.counts.hours == 30 && this.counts.minutes >= 30) || this.counts.hours > 30) && (this.counts.minutes / 1.5)
  }

  ;<template>
    <h2 id="title">30+ countdown</h2>
    <div class="counter">
      <div class="number"><div>years:</div><div class="count">{{this.counts.years}}</div></div>
      <div class="number"><div>months:</div><div class="count">{{this.counts.months}}</div></div>
      <div class="number"><div>weeks:</div><div class="count">{{this.counts.weeks}}</div></div>
      <div class="number"><div>days:</div><div class="count">{{this.counts.days}}</div></div>
      <div class="number"><div>hours:</div><div class="count">{{this.counts.hours}}</div></div>
      <div class="number"><div>minutes:</div><div class="count">{{this.counts.minutes}}</div></div>
      <div class="number"><div>seconds:</div><div class="count">{{this.counts.seconds}}</div></div>
    </div>
    {{#if this.moments}}
      <div class="number"><div>moments:</div><div class="count">{{this.moments}}</div></div>
    {{/if}}
  </template>
}
