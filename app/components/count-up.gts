import type Owner from '@ember/owner'
import Component from '@glimmer/component'
import { tracked } from '@glimmer/tracking'
import 'temporal-spec/global'

export interface CountUpSignature {
  Args: {
    targetDate: Temporal.ZonedDateTime
  }
  Element: null
}

const LIMIT = 30;
function countToDisplay(num: number) {
  return num > LIMIT ? LIMIT : num;
}
function displayCount(num: number) {
  return num.toFixed().length === 1 ? `0${num}` : `${num}`
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
  const bonusUnits = minutes >= 30 ? generateBonusCounts(diff.total('milliseconds') - 30*60*60*1000 - 30*60*1000) : []

  return {
    hours,
    minutes,
    seconds,
    bonusUnits,
  }
}

interface Unit {
  name: string
  millis: number
}
const UNITS: Unit[] = [
  { name: 'AverageDurationOfHappyCowMooings', millis: 1760 },
  { name: '30^30 planck times', millis: 11100 },
  { name: '30 x 30^3 Shakes', millis: 8100 },
  { name: '30 jiffys (electronics)', millis: 600 },
  { name: '30 jiffys (computing)', millis: 10 },
  { name: '((3*3*30)^3)^3 jiffys (science)', millis: 23 },
  { name: '(30^3)^3 Svedbergs', millis: 1968 },
  { name: 'TUs (Time Units)', millis: 1024 },
  { name: 'microfortnights', millis: 1210 },
  { name: 'half-moments', millis: 1500 },
  { name: 'nanoCenturies', millis: 3156 },
  { name: 'atoms', millis: 160 },
  { name: 'avali', millis: 172 },
  { name: '30^3 lavas', millis: 30 },
  { name: 'vighatis', millis: 24000 },
  { name: 'a fēn (分)', millis: 14400 },
  { name: 'milliKwartiers', millis: 900 },
  { name: 'AverageTimeOfSaying‘30Plus’s', millis: 760 },
  { name: 'heartbeats', millis: 800 },
  { name: '‘dozijnste-scrupulum’', millis: 12500 },
  { name: 'relative second', millis: 1047 },
  { name: 'beard 30-nanometer', millis: 3000 },
  { name: 'time-to-zone-outs', millis: 3330 },
].toSorted(({ millis: a }, { millis: b}) => a - b)
interface BonusCount {
  name: string
  count: number
}
function generateBonusCounts(millis: number) {
  const counts: BonusCount[] = []
  let i = 0
  let unit
  do {
    unit = UNITS[i]
    if (unit) {
      counts.push({ name: unit.name, count: Math.trunc(millis / unit.millis) })
    }
  } while (++i < UNITS.length && (counts.at(-1)?.count ?? 0) >= 30)
  return counts
}

export default class CountUp extends Component<CountUpSignature> {
  constructor(owner: Owner, args: CountUpSignature['Args']) {
    super(owner, args)
    // Move to modifier?
    setInterval(() => this.now = Temporal.Now.zonedDateTimeISO(), 20)
  }

  @tracked now = Temporal.Now.zonedDateTimeISO()
  birthDate = this.args.targetDate.subtract(Temporal.Duration.from({
    years: 30,
    months: 30,
    weeks: 30,
    // Maybe miss a leap year in the calculations?!?
    days: 31,
    hours: 30,
    minutes: 30,
  }))
  dateCounts = generateDateCounts(this.birthDate, this.now)
  get counts() {
    const { remaining, ...dateCounts } = generateDateCounts(this.birthDate, this.now)
    return {
      ...dateCounts,
      ...generateTimeCounts(remaining, this.now),
    }
  }

  ;<template>
    <h2 class="title">30+ countdown</h2>
    <div class="container">
      <div class="counter">
        <div class="number"><div>years</div><div class="count">{{displayCount this.counts.years}}</div></div>
        <div class="separator">+</div>
        <div class="number"><div>months</div><div class="count">{{displayCount this.counts.months}}</div></div>
        <div class="separator">+</div>
        <div class="number"><div>weeks</div><div class="count">{{displayCount this.counts.weeks}}</div></div>
        <div class="separator">+</div>
        <div class="number"><div>days</div><div class="count">{{displayCount this.counts.days}}</div></div>
        <div class="separator">+</div>
        <div class="number"><div>hours</div><div class="count">{{displayCount this.counts.hours}}</div></div>
        <div class="separator">+</div>
        <div class="number"><div>minutes</div><div class="count">{{displayCount this.counts.minutes}}</div></div>
        <div class="separator">+</div>
        <div class="number"><div>seconds</div><div class="count">{{displayCount this.counts.seconds}}</div></div>
      </div>
      {{#if this.counts.bonusUnits}}
        <div class="or">OR</div>
        <div class="bonus-list">
          {{#each this.counts.bonusUnits as |bonus|}}
            <div class="bonus-unit">
              <div class="separator">+</div>
              <div class="number"><div>{{bonus.name}}</div><div class="count">{{displayCount bonus.count}}</div></div>
            </div>
          {{/each}}
        </div>
      {{/if}}
    </div>
  </template>
}
