import type Owner from '@ember/owner'
import Component from '@glimmer/component'
import { tracked } from '@glimmer/tracking'
import 'temporal-spec/global'

export interface CountUpSignature {
  Args: {}
  Element: null
}

const TARGET_DATE = Temporal.ZonedDateTime.from({
  year: 2026,
  month: 10,
  day: 4,
  hour: 21,
  minute: 55,
  timeZone: Temporal.Now.timeZoneId(),
})
const BIRTH_DATE = TARGET_DATE.subtract(Temporal.Duration.from({
  years: 30,
  months: 30,
  weeks: 30,
  days: 30,
  hours: 30,
  minutes: 30,
}))

const LIMIT = 30;
function countToDisplay(num: number) {
  return num > LIMIT ? LIMIT : num;
}

function generateDateCounts(birthDate: Temporal.ZonedDateTime, now: Temporal.ZonedDateTime) {
  let diff = birthDate.until(now, { largestUnit: 'years', smallestUnit: 'hours' })
  const years = countToDisplay(diff.years)
  let remaining = birthDate.add({ years })
  diff = remaining.until(now, { largestUnit: 'months', smallestUnit: 'hours' })
  const months = countToDisplay(diff.months)
  remaining = remaining.add({ months })
  diff = remaining.until(now, { largestUnit: 'weeks', smallestUnit: 'hours' })
  const weeks = countToDisplay(diff.weeks)
  remaining = remaining.add({ weeks })
  diff = remaining.until(now, { largestUnit: 'days', smallestUnit: 'hours' })
  const days = countToDisplay(diff.days)
  remaining = remaining.add({ days })
  return {
    years,
    months,
    weeks,
    days,
    remaining,
  }
}

function generateTimeCounts(remaining: Temporal.ZonedDateTime, now: Temporal.ZonedDateTime) {
  const diff = remaining.until(now)
  let remainingSecs = diff.total('seconds')
  const hours = countToDisplay(Math.trunc(remainingSecs / (60 * 30)) / 2)
  remainingSecs = remainingSecs - hours * 60 * 60
  const minutes = countToDisplay(Math.trunc(remainingSecs / (30)) / 2)
  const seconds = Math.trunc(remainingSecs - minutes * 60)

  return {
    hours,
    minutes,
    seconds,
  }
}

export default class CountUp extends Component<CountUpSignature> {
  constructor(owner: Owner, args: CountUpSignature['Args']) {
    super(owner, args)
    // Move to modifier?
    setInterval(() => this.now = Temporal.Now.zonedDateTimeISO(), 20)
  }

  @tracked now = Temporal.Now.zonedDateTimeISO()
  dateCounts = generateDateCounts(BIRTH_DATE, this.now)
  get counts() {
    const { remaining, ...dateCounts } = generateDateCounts(BIRTH_DATE, this.now)
    return {
      ...dateCounts,
      ...generateTimeCounts(remaining, this.now),
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
