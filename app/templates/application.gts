import { pageTitle } from 'ember-page-title';
import CountUp from 'thirty-plus/components/count-up.gts';

<template>
  {{pageTitle "ThirtyPlus"}}
  <CountUp />

  {{outlet}}
</template>
