import type { TOC } from '@ember/component/template-only';
import CountUp from 'thirty-plus/components/count-up.gts';

interface IndexSignature {
  Args: {
    model: unknown;
    controller: unknown;
  };
}

const TARGET_DATE = Temporal.ZonedDateTime.from({
  year: 2026,
  month: 10,
  day: 4,
  hour: 21,
  minute: 55,
  timeZone: Temporal.Now.timeZoneId(),
})

;<template>
  <CountUp @targetDate={{TARGET_DATE}} />

  {{outlet}}
</template> satisfies TOC<IndexSignature>;
