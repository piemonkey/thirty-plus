import type { TOC } from '@ember/component/template-only';
import CountUp from 'thirty-plus/components/count-up.gts';

interface NowSignature {
  Args: {
    model: unknown;
    controller: unknown;
  };
}

const nowish = Temporal.Now.zonedDateTimeISO().add({ minutes: 30, seconds: 30 })
console.log('Test target date', nowish)

;<template>
  <CountUp @targetDate={{nowish}} />

  {{outlet}}
</template> satisfies TOC<NowSignature>;
